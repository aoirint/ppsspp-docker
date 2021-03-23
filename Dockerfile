FROM nvidia/opengl:1.2-glvnd-devel-ubuntu18.04

ARG PPSSPP_VERSION=9435174d491a2e0c1560898e627b31581c37de4e

RUN apt-get update && \
    apt-get install -y \
        git \
        build-essential \
        cmake \
        libgl1-mesa-dev \
        libsdl2-dev \
        libvulkan-dev && \
    git clone https://github.com/hrydgard/ppsspp.git /ppsspp && \
    cd /ppsspp && \
    git checkout ${PPSSPP_VERSION} && \
    git submodule update --init --recursive

RUN cd /ppsspp && \
    cmake .
RUN cd /ppsspp && \
    make

RUN apt-get install -y \
        gosu

ADD ./docker-entrypoint.sh /
ENTRYPOINT [ "/docker-entrypoint.sh" ]

