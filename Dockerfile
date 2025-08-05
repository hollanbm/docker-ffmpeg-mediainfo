ARG FFMPEG_VERSION=7.1
ARG FFMPEG_TAG=nvidia
FROM ghcr.io/jrottenberg/ffmpeg:${FFMPEG_VERSION}-${FFMPEG_TAG}

ENV DEBIAN_FRONTEND=nonintercative

RUN apt-get -yqq update && \
    apt-get install -y git zsh mediainfo curl nano && \
    apt-get autoremove -y && \
    apt-get clean -y

WORKDIR /root/

RUN sh -c "$(curl -L https://github.com/deluan/zsh-in-docker/releases/download/v1.2.1/zsh-in-docker.sh)" -- \
    -t "robbyrussell" \
    -p "git" \
    -p "https://github.com/zsh-users/zsh-autosuggestions" \
    -p "https://github.com/zsh-users/zsh-syntax-highlighting"

LABEL org.opencontainers.image.authors="hollanbm@gmail.com"
LABEL org.opencontainers.image.source=https://github.com/hollanbm/docker-ffmpeg-mediainfo
LABEL org.opencontainers.image.description README.md

RUN chsh -s /bin/zsh root