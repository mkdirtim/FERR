# Kali-based container for OpenCode development + pentesting tools
FROM kalilinux/kali-last-release@sha256:c77f241fcd12bb7835e09f8fc1073d7d9c7cf50b531808d9afa95e9cb63a6113

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    kali-linux-headless \
    nuclei \
    python3 \
    python3-venv \
    build-essential \
    jq \
    curl \
    ca-certificates \
    git \
    libcap2-bin \
    unzip \
    make \
    ripgrep \
    # MCP servers in .opencode/opencode.jsonc run inside this container.
    # We install Node/npm so `npx -y ...` works for local MCP commands.
    nodejs \
    npm \
    # Playwright MCP typically needs a working Chromium + runtime helpers.
    # (Kali rolling occasionally renames some shared library packages; relying on
    # Chromium deps keeps this image building reliably.)
    chromium \
    fonts-liberation \
    xdg-utils \
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

RUN mkdir -p /usr/share/wordlists/seclists

RUN useradd -m -s /bin/bash opencode && \
    chown -R opencode:opencode /app /opt/bun

USER opencode

ENV PYTHONUNBUFFERED=1
ENV PATH="/opt/bun/bin:/home/opencode/.local/bin:${PATH}"

RUN printf '\n# opencodestack shell helper\nif [ -n "$PS1" ] && [ "$$" -ne 1 ]; then\n  echo \"opencodestack: repo mounted at /app\";\n  echo \"opencodestack: from host run: make -C docker help\";\nfi\n' >> /home/opencode/.bashrc

EXPOSE 4096 3000

CMD ["/bin/bash"]
