#!/bin/bash
set -e

# Create non-root user with sudo access (ignore if exists)
groupadd -g ${USER_GID:-1001} ${USERNAME:-developer} || true
useradd -m -u ${USER_UID:-1001} -g ${USERNAME:-developer} -s /bin/bash ${USERNAME:-developer} || true
echo "${USERNAME:-developer} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME:-developer}
chmod 0440 /etc/sudoers.d/${USERNAME:-developer}
usermod -p '*' ${USERNAME:-developer}

# Create Claude config symlink
if [ -f "/home/${USERNAME:-developer}/.claude/.claude-root.json" ] && [ ! -L "/home/${USERNAME:-developer}/.claude.json" ]; then
  rm -f /home/${USERNAME:-developer}/.claude.json
  ln -sf /home/${USERNAME:-developer}/.claude/.claude-root.json /home/${USERNAME:-developer}/.claude.json
fi

# Setup SSH authorized keys
mkdir -p /home/${USERNAME:-developer}/.ssh
chmod 700 /home/${USERNAME:-developer}/.ssh
chown -R ${USERNAME:-developer}:${USERNAME:-developer} /home/${USERNAME:-developer}/.ssh

if [ -n "$SSH_PUBLIC_KEY" ]; then
  echo "$SSH_PUBLIC_KEY" > /home/${USERNAME:-developer}/.ssh/authorized_keys
  chmod 600 /home/${USERNAME:-developer}/.ssh/authorized_keys
  chown ${USERNAME:-developer}:${USERNAME:-developer} /home/${USERNAME:-developer}/.ssh/authorized_keys
fi

# Start SSH server
mkdir -p /run/sshd
/usr/sbin/sshd

# Fix workspace ownership and switch to user
chown -R ${USERNAME:-developer}:${USERNAME:-developer} /workspace 2>/dev/null || true
exec su - ${USERNAME:-developer} -c "cd /workspace && bash"
