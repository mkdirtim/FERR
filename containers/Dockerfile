# OpenHack container: Kali + Bun development environment
FROM kalilinux/kali-last-release@sha256:c77f241fcd12bb7835e09f8fc1073d7d9c7cf50b531808d9afa95e9cb63a6113

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    # Kali pentesting tools (nmap, metasploit, hydra, etc.)
    kali-linux-headless \
    # Not bundled by kali-linux-headless
    nuclei \
    # Scripting / native module builds
    python3 \
    python3-venv \
    python3-pip \
    build-essential \
    make \
    # Python tool manager
    pipx \
    # Go toolchain (httpx, katana, interactsh, gospider)
    golang-go \
    # CLI utilities
    jq \
    ripgrep \
    unzip \
    # Not installed with --no-install-recommends
    git \
    # HTTPS and cert handling
    ca-certificates \
    openssl \
    # nmap capabilities for non-root use
    libcap2-bin \
    # NOPASSWD sudo for opencode user
    sudo \
    # MCP servers run via npx
    nodejs \
    npm \
    # Playwright-compatible browser stack
    chromium \
    fonts-liberation \
    xdg-utils \
    # MITM proxy and Chromium NSS cert utilities
    mitmproxy \
    libnss3-tools \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN setcap cap_net_raw,cap_net_admin,cap_net_bind_service+eip "$(which nmap)"

ENV BUN_INSTALL=/opt/bun
RUN set -eux; \
    mkdir -p /opt/bun; \
    curl -fsSL https://bun.sh/install | bash; \
    test -x /opt/bun/bin/bun; \
    ln -s /opt/bun/bin/bun /usr/local/bin/bun

WORKDIR /app

RUN useradd -m -s /bin/bash opencode \
    && chown -R opencode:opencode /app /opt/bun \
    && echo "opencode ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers \
    && curl -sSfL https://raw.githubusercontent.com/trufflesecurity/trufflehog/main/scripts/install.sh \
        | sh -s -- -b /usr/local/bin

COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENV PYTHONUNBUFFERED=1
ENV PATH="/opt/bun/bin:/home/opencode/go/bin:/home/opencode/.local/bin:${PATH}"
# Python requests and SSL libs use the system trust store (includes our CA).
ENV REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
ENV SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt

USER opencode

# Generate a local CA cert bundle for HTTPS interception workflows.
RUN mkdir -p /app/certs && \
    openssl ecparam -name prime256v1 -genkey -noout -out /app/certs/ca.key && \
    openssl req -x509 -new -key /app/certs/ca.key \
        -out /app/certs/ca.crt \
        -days 3650 \
        -subj "/C=US/ST=CA/O=OpenHack Testing/CN=OpenHack Root CA" \
        -addext "basicConstraints=critical,CA:TRUE" \
        -addext "keyUsage=critical,digitalSignature,keyEncipherment,keyCertSign" && \
    openssl pkcs12 -export \
        -out /app/certs/ca.p12 \
        -inkey /app/certs/ca.key \
        -in /app/certs/ca.crt \
        -passout pass:"" \
        -name "OpenHack Root CA" && \
    chmod 644 /app/certs/ca.crt && \
    chmod 600 /app/certs/ca.key /app/certs/ca.p12

USER root
RUN cp /app/certs/ca.crt /usr/local/share/ca-certificates/openhack-ca.crt \
    && update-ca-certificates

USER opencode

RUN go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest && \
    go install -v github.com/projectdiscovery/katana/cmd/katana@latest && \
    go install -v github.com/projectdiscovery/interactsh/cmd/interactsh-client@latest && \
    go install -v github.com/jaeles-project/gospider@latest

RUN pipx install arjun && \
    pipx install dirsearch && \
    pipx install wafw00f

# jwt_tool has no setup.py/pyproject.toml so pipx/pip install won't work.
# Clone it, create a venv, install its requirements, and drop a wrapper into PATH.
RUN git clone --depth 1 https://github.com/ticarpi/jwt_tool.git /home/opencode/tools/jwt_tool && \
    python3 -m venv /home/opencode/tools/jwt_tool/.venv && \
    /home/opencode/tools/jwt_tool/.venv/bin/pip install -q \
        -r /home/opencode/tools/jwt_tool/requirements.txt && \
    printf '#!/bin/sh\nexec /home/opencode/tools/jwt_tool/.venv/bin/python /home/opencode/tools/jwt_tool/jwt_tool.py "$@"\n' \
        > /home/opencode/.local/bin/jwt_tool && \
    chmod +x /home/opencode/.local/bin/jwt_tool
RUN nuclei -update-templates

EXPOSE 4096 3000

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["/bin/bash"]
