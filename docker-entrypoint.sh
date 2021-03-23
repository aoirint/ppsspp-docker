#!/bin/bash

set -eu

USER_NAME=user

useradd -u "${HOST_UID}" -o -m "${USER_NAME}"
groupmod -g "${HOST_GID}" "${USER_NAME}"

gosu "${USER_NAME}" mkdir -p "/home/${USER_NAME}/.config/pulse"
ln -s /pulseaudio/cookie "/home/${USER_NAME}/.config/pulse/cookie"

chown -R "${USER_NAME}:${USER_NAME}" "/ppsspp_conf"
ln -s "/ppsspp_conf" "/home/${USER_NAME}/.config/ppsspp"

gosu "${USER_NAME}" /ppsspp/PPSSPPSDL "$@"
