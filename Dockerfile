# CI image (tag: calculator-ci): tools needed to run `make test`
FROM docker.io/ubuntu:24.04 AS ci
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential git ca-certificates curl sudo dumb-init iverilog nodejs && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
RUN useradd --create-home --shell /bin/bash dev && \
    usermod --append --groups sudo dev && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
ENTRYPOINT ["/usr/bin/dumb-init", "--"]

# Devcontainer image (tag: calculator-dev): CI image + developer conveniences
FROM ci AS dev
USER root
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends man zsh vim procps jq gtkwave && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
USER dev
