ARG FFMPEG_VERSION=8
ARG FFMPEG_TAG=nvidia
ARG TARGETPLATFORM
FROM ghcr.io/jrottenberg/ffmpeg:${FFMPEG_VERSION}-${FFMPEG_TAG}

ENV DEBIAN_FRONTEND=nonintercative
ENV HOME=/home/ubuntu

RUN apt-get -yqq update && \
    apt-get install -y git zsh mediainfo curl nano unrar unzip jq locales && \
    sed -i 's/^# *\(en_US.UTF-8 UTF-8\)/\1/' /etc/locale.gen && \
    locale-gen en_US.UTF-8 && \
    update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 && \
    apt-get autoremove -y && \
    apt-get clean -y

ENV LANG=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

RUN if getent group ubuntu >/dev/null 2>&1; then \
        groupmod --gid 1000 ubuntu; \
    else \
        groupadd --gid 1000 ubuntu; \
    fi && \
    if id -u ubuntu >/dev/null 2>&1; then \
        usermod --uid 1000 --gid 1000 --home /home/ubuntu --shell /bin/zsh ubuntu; \
    else \
        useradd --uid 1000 --gid 1000 --create-home --home-dir /home/ubuntu --shell /bin/zsh ubuntu; \
    fi && \
    mkdir -p /home/ubuntu && \
    chown -R 1000:1000 /home/ubuntu
USER ubuntu
WORKDIR /home/ubuntu

RUN sh -c "$(curl -L https://github.com/deluan/zsh-in-docker/releases/download/v1.2.1/zsh-in-docker.sh)" -- \
    -t "robbyrussell" \
    -p "git" \
    -p "https://github.com/zsh-users/zsh-autosuggestions" \
    -p "https://github.com/zsh-users/zsh-syntax-highlighting"

LABEL org.opencontainers.image.authors="hollanbm@gmail.com"
LABEL org.opencontainers.image.source=https://github.com/hollanbm/docker-ffmpeg-mediainfo
LABEL org.opencontainers.image.description=README.md

ENTRYPOINT [ "/bin/zsh" ]
