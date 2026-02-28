# OpenHack container: Kali + Bun development environment
FROM kalilinux/kali-last-release@sha256:c77f241fcd12bb7835e09f8fc1073d7d9c7cf50b531808d9afa95e9cb63a6113

ENV DEBIAN_FRONTEND=noninteractive
ENV BUN_INSTALL=/opt/bun
ENV PYTHONUNBUFFERED=1
ENV PATH="/opt/bun/bin:/home/opencode/go/bin:/home/opencode/.local/bin:${PATH}"
ENV REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt
ENV SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt
# Store Playwright browsers at a system path so the opencode user can find them at runtime.
ENV PLAYWRIGHT_BROWSERS_PATH=/opt/ms-playwright

RUN apt-get update && apt-get install -y --no-install-recommends \
    # System / build essentials
    build-essential make git jq ripgrep unzip sqlite3 ca-certificates openssl libcap2-bin sudo \
    # Kali pentesting tools (nmap, metasploit, hydra, etc.)
    kali-linux-headless nuclei \
    # Python toolchain
    python3 python3-venv python3-pip pipx \
    # Go toolchain (httpx, katana, interactsh, gospider)
    golang-go \
    # Node + browser (MCP servers via npx, Playwright)
    nodejs npm chromium fonts-liberation xdg-utils \
    # MITM proxy and Chromium NSS cert utilities
    mitmproxy libnss3-tools \
    # PDF report generation (pandoc + eisvogel/xelatex)
    pandoc texlive-latex-recommended texlive-fonts-recommended texlive-fonts-extra texlive-latex-extra texlive-xetex \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN setcap cap_net_raw,cap_net_admin,cap_net_bind_service+eip "$(which nmap)"

# SecLists wordlists — downloaded once at build time, cached as a layer
RUN mkdir -p /usr/share/wordlists \
    && curl -fL https://github.com/danielmiessler/SecLists/archive/refs/heads/master.tar.gz \
        | tar xz -C /usr/share/wordlists/ \
    && mv /usr/share/wordlists/SecLists-master /usr/share/wordlists/seclists

RUN set -eux; \
    mkdir -p /opt/bun; \
    curl -fsSL https://bun.sh/install | bash; \
    test -x /opt/bun/bin/bun; \
    ln -s /opt/bun/bin/bun /usr/local/bin/bun

RUN mkdir -p /app \
    && useradd -m -s /bin/bash opencode \
    && chown -R opencode:opencode /app /opt/bun \
    && echo "opencode ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN curl -sSfL https://raw.githubusercontent.com/trufflesecurity/trufflehog/main/scripts/install.sh \
    | sh -s -- -b /usr/local/bin

# Generate a local CA cert bundle for HTTPS interception workflows.
# Done as root so generation and system trust installation happen in one layer.
RUN mkdir -p /app/certs \
    && openssl ecparam -name prime256v1 -genkey -noout -out /app/certs/ca.key \
    && openssl req -x509 -new -key /app/certs/ca.key \
        -out /app/certs/ca.crt \
        -days 3650 \
        -subj "/C=US/ST=CA/O=OpenHack Testing/CN=OpenHack Root CA" \
        -addext "basicConstraints=critical,CA:TRUE" \
        -addext "keyUsage=critical,digitalSignature,keyEncipherment,keyCertSign" \
    && openssl pkcs12 -export \
        -out /app/certs/ca.p12 \
        -inkey /app/certs/ca.key \
        -in /app/certs/ca.crt \
        -passout pass:"" \
        -name "OpenHack Root CA" \
    && chmod 644 /app/certs/ca.crt \
    && chmod 600 /app/certs/ca.key /app/certs/ca.p12 \
    && chown -R opencode:opencode /app/certs \
    && cp /app/certs/ca.crt /usr/local/share/ca-certificates/openhack-ca.crt \
    && update-ca-certificates

# Playwright Chromium — install as root using the exact playwright version bundled with @playwright/mcp
# so the Chromium revision hash matches at runtime. Lands at PLAYWRIGHT_BROWSERS_PATH (/opt/ms-playwright),
# a world-readable system path; no volume mount or sudo needed at runtime.
RUN mkdir -p /tmp/pw-setup \
    && echo '{"name":"pw-setup","private":true}' > /tmp/pw-setup/package.json \
    && cd /tmp/pw-setup \
    && bun add @playwright/mcp@0.0.68 \
    && node_modules/.bin/playwright install chromium --with-deps \
    && rm -rf /tmp/pw-setup \
    && chmod -R a+rx /opt/ms-playwright \
    && chown -R opencode:opencode /opt/bun

WORKDIR /app
USER opencode

# Go-based recon tools
RUN go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest \
    && go install -v github.com/projectdiscovery/katana/cmd/katana@latest \
    && go install -v github.com/projectdiscovery/interactsh/cmd/interactsh-client@latest \
    && go install -v github.com/jaeles-project/gospider@latest

# Python-based recon tools
RUN pipx install arjun \
    && pipx install dirsearch \
    && pipx install wafw00f

# jwt_tool has no setup.py/pyproject.toml so pipx/pip install won't work.
# Clone it, create a venv, install its requirements, and drop a wrapper into PATH.
RUN git clone --depth 1 https://github.com/ticarpi/jwt_tool.git /home/opencode/tools/jwt_tool \
    && python3 -m venv /home/opencode/tools/jwt_tool/.venv \
    && /home/opencode/tools/jwt_tool/.venv/bin/pip install -q \
        -r /home/opencode/tools/jwt_tool/requirements.txt \
    && printf '#!/bin/sh\nexec /home/opencode/tools/jwt_tool/.venv/bin/python /home/opencode/tools/jwt_tool/jwt_tool.py "$@"\n' \
        > /home/opencode/.local/bin/jwt_tool \
    && chmod +x /home/opencode/.local/bin/jwt_tool

# Nuclei templates — own layer so template updates don't bust Go tools cache
RUN nuclei -update-templates

COPY --chmod=755 docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

EXPOSE 4096 3000

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["/bin/bash"]
