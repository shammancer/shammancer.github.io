#!/usr/bin/env bash
set -euo pipefail

PREFIX="sgi"
APP_IMAGE="${PREFIX}-app"
CONTAINER="${PREFIX}-run"
PORT=8888

podman build --security-opt label=disable -t ${APP_IMAGE} -f Containerfile.app .
podman run --security-opt label=disable --rm --name ${CONTAINER} -p ${PORT}:80 localhost/${APP_IMAGE}
