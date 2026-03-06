FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    git \
    wget \
    ca-certificates \
    tmux \
    sudo \
    openssh-server \
    screen \
    xz-utils \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install nvm, Node.js (latest), npm, and pnpm
ENV NVM_DIR=/usr/local/nvm
RUN mkdir -p "$NVM_DIR" \
    && curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | NVM_DIR="$NVM_DIR" bash \
    && . "$NVM_DIR/nvm.sh" \
    && nvm install node \
    && nvm alias default node \
    && npm install -g pnpm @anthropic-ai/claude-code @openai/codex @google/gemini-cli \
    && NODE_BIN=$(dirname "$(nvm which default)") \
    && ln -sf "$NODE_BIN/node" /usr/local/bin/node \
    && ln -sf "$NODE_BIN/npm" /usr/local/bin/npm \
    && ln -sf "$NODE_BIN/npx" /usr/local/bin/npx \
    && ln -sf "$NODE_BIN/pnpm" /usr/local/bin/pnpm \
    && printf 'export NVM_DIR="/usr/local/nvm"\n[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"\n[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"\n' \
       > /etc/profile.d/nvm.sh \
    && chmod +x /etc/profile.d/nvm.sh

# Security: Block git push capability (read-only git)
RUN git config --system --add push.default nothing \
    && git config --system --add credential.helper "" \
    && git config --system --add core.askPass ""

# Configure SSH server
RUN mkdir -p /run/sshd \
    && ssh-keygen -A \
    && echo "Port 2212" >> /etc/ssh/sshd_config \
    && echo "PermitRootLogin no" >> /etc/ssh/sshd_config \
    && echo "PasswordAuthentication no" >> /etc/ssh/sshd_config \
    && echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config \
    && echo "AllowTcpForwarding yes" >> /etc/ssh/sshd_config \
    && echo "AllowStreamLocalForwarding yes" >> /etc/ssh/sshd_config

# Copy and set entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

WORKDIR /workspace

ENTRYPOINT ["/entrypoint.sh"]
