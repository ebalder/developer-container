FROM ubuntu:22.04

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
    && rm -rf /var/lib/apt/lists/*

# Install Node.js LTS
RUN wget -qO- https://nodejs.org/dist/v22.21.1/node-v22.21.1-linux-x64.tar.xz | tar -xJ -C /usr/local --strip-components=1

# Install CLI tools globally
RUN npm install -g @anthropic-ai/claude-code @openai/codex @google/gemini-cli

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
