FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

# Install base tools and networking
RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    ca-certificates \
    curl \
    wget \
    git \
    python3 \
    python3-pip \
    python3-venv \
    procps \
    net-tools \
    iproute2 \
    iptables \
    dnsutils \
    iputils-ping \
    htop \
    tree \
    nano \
    vim \
    less \
    tar \
    gzip \
    bzip2 \
    xz-utils \
    unzip \
    sudo \
    locales \
    libatomic1 \
    && rm -rf /var/lib/apt/lists/*

# Install ttyd (v1.7.7 x86_64 standalone binary)
RUN curl -fsSL -o /usr/local/bin/ttyd https://github.com/tsl0922/ttyd/releases/download/1.7.7/ttyd.x86_64 && \
    chmod 755 /usr/local/bin/ttyd

# Install docker-systemctl-replacement to provide complete systemctl support
RUN curl -fsSL -o /usr/local/bin/systemctl https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl3.py && \
    chmod 755 /usr/local/bin/systemctl && \
    ln -sf /usr/local/bin/systemctl /bin/systemctl

# Install Google Antigravity SDK & CLI
RUN pip3 install --no-cache-dir --break-system-packages google-antigravity || true
RUN curl -fsSL https://antigravity.google/cli/install.sh 2>/dev/null | bash || true

# Setup workspace and data persistence directories
RUN mkdir -p /workspace /data /etc/systemd/system /root/.gemini/antigravity-cli

COPY entrypoint.sh /entrypoint.sh
COPY agy-launcher.sh /usr/local/bin/agy
COPY agy-remote-control-start.sh /usr/local/bin/agy-remote-control-start
COPY welcome.sh /etc/profile.d/welcome.sh
COPY agy-remote-control.service /etc/systemd/system/agy-remote-control.service

RUN chmod +x /entrypoint.sh /usr/local/bin/agy /usr/local/bin/agy-remote-control-start /etc/profile.d/welcome.sh

RUN echo 'source /etc/profile' >> /root/.bashrc

WORKDIR /workspace
EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
