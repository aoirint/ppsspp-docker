# Common Build Arguments
ARG BASE_BUILD_IMAGE=nvidia/opengl:1.2-glvnd-devel-ubuntu18.04
ARG BASE_RUNTIME_IMAGE=nvidia/opengl:1.2-glvnd-runtime-ubuntu18.04


# Build
FROM ${BASE_BUILD_IMAGE} AS build-env
ARG PPSSPP_VERSION=9435174d491a2e0c1560898e627b31581c37de4e
ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /ppsspp_build

RUN apt-get update && \
    apt-get install -y \
        git \
        build-essential \
        cmake \
        libgl1-mesa-dev \
        libsdl2-dev \
        libvulkan-dev

RUN git clone https://github.com/hrydgard/ppsspp.git . && \
    git checkout ${PPSSPP_VERSION}

RUN git submodule update --init --recursive

RUN cmake . && \
    make -j"$(nproc)"

RUN make install DESTDIR=/ppsspp_install


# Runtime
FROM ${BASE_RUNTIME_IMAGE} AS runtime
ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /ppsspp

RUN apt-get update && \
    apt-get install -y \
        libgl1-mesa-glx \
        libsdl2-2.0-0 \
        libvulkan1 \
        gosu

COPY --from=build-env /ppsspp_install /

ADD ./docker-entrypoint.sh /
ENTRYPOINT [ "/docker-entrypoint.sh" ]
CMD [ "PPSSPPSDL" ]
