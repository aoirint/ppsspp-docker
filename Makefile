ROOT_DIR = $(dir $(realpath $(firstword $(MAKEFILE_LIST))))

build:
	docker build . -t aoirint/ppsspp

run: build
	docker run --rm -it \
		-e DISPLAY \
		-v "/tmp/.X11-unix:/tmp/.X11-unix" \
		--gpus all \
		--group-add "$(shell getent group audio | cut -d: -f3)" \
		-e "PULSE_SERVER=unix:${XDG_RUNTIME_DIR}/pulse/native" \
		-v "${XDG_RUNTIME_DIR}/pulse/native/:${XDG_RUNTIME_DIR}/pulse/native" \
		-v "${HOME}/.config/pulse/cookie:/tmp/pulseaudio_cookie" \
		-e "HOST_UID=$(shell id -u)" \
		-e "HOST_GID=$(shell id -g)" \
		-v "${HOME}/.config/ppsspp:/ppsspp_conf" \
		aoirint/ppsspp

