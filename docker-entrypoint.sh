#!/bin/bash

set -eu

PULSEAUDIO_COOKIE_TMP_MOUNT_PATH=/tmp/pulseaudio_cookie
#VBAM_CONFIG_TMP_MOUNT_PATH=/tmp/vbam_conf

USER_NAME=user

useradd -u "${HOST_UID}" -o -m "${USER_NAME}"
groupmod -g "${HOST_GID}" "${USER_NAME}"

# chown -R "${USER_NAME}:${USER_NAME}" /vbam

gosu "${USER_NAME}" mkdir -p "/home/${USER_NAME}/.config/pulse"
cp "${PULSEAUDIO_COOKIE_TMP_MOUNT_PATH}" "/home/${USER_NAME}/.config/pulse/cookie"
# cp -r "${VBAM_CONFIG_TMP_MOUNT_PATH}" "/home/${USER_NAME}/.config/visualboyadvance-m"

chown -R "${USER_NAME}:${USER_NAME}" "/ppsspp_conf"
ln -s "/ppsspp_conf" "/home/${USER_NAME}/.config/ppsspp"

gosu "${USER_NAME}" /ppsspp/PPSSPPSDL "$@"


