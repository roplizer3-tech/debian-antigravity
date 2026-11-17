FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

# Install clean base Debian packages and essential utilities
RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    ca-certificates \
    curl \
    wget \
    git \
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
    proot \
    rsync \
    && rm -rf /var/lib/apt/lists/*

# Install ttyd (v1.7.7 x86_64 standalone web terminal binary)
RUN curl -fsSL -o /usr/local/bin/ttyd https://github.com/tsl0922/ttyd/releases/download/1.7.7/ttyd.x86_64 && \
    chmod 755 /usr/local/bin/ttyd

# Install docker-systemctl-replacement to provide complete systemctl support
RUN curl -fsSL -o /usr/local/bin/systemctl https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl3.py && \
    chmod 755 /usr/local/bin/systemctl && \
    ln -sf /usr/local/bin/systemctl /bin/systemctl

# Setup workspace and data persistence directories
RUN mkdir -p /workspace /data /run

COPY entrypoint.sh /entrypoint.sh
COPY enter-debian.sh /usr/local/bin/enter-debian
COPY welcome.sh /etc/profile.d/welcome.sh

RUN chmod +x /entrypoint.sh /usr/local/bin/enter-debian /etc/profile.d/welcome.sh

RUN echo 'source /etc/profile' >> /root/.bashrc

WORKDIR /workspace
EXPOSE 8080

ENTRYPOINT ["/entrypoint.sh"]
