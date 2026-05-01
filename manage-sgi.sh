#!/usr/bin/env bash
set -euo pipefail

PHASE=""
RUN=false
EXTRACT=false
PREFIX="sgi"
BASE_IMAGE="${PREFIX}-base"
GEMS_IMAGE="${PREFIX}-gems"
APP_IMAGE="${PREFIX}-app"
SERVER_IMAGE="${PREFIX}-server"
CONTAINER="${PREFIX}-run"
PORT=8888

while [[ $# -gt 0 ]]; do
  case "$1" in
    --build|-b)
      PHASE="$2"
      shift 2
      ;;
    --run)
      RUN=true
      shift
      ;;
    --extract)
      EXTRACT=true
      shift
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 1
      ;;
  esac
done

MODE_COUNT=0
$RUN     && MODE_COUNT=$((MODE_COUNT + 1))
$EXTRACT && MODE_COUNT=$((MODE_COUNT + 1))
[[ -n "${PHASE}" ]] && MODE_COUNT=$((MODE_COUNT + 1))
if [[ $MODE_COUNT -gt 1 ]]; then
  echo "Error: --run, --extract, and --build are mutually exclusive" >&2
  exit 1
fi

build_base() {
  podman build --security-opt label=disable -t ${BASE_IMAGE} -f Containerfile.base .
}

build_gems() {
  podman build --security-opt label=disable -t ${GEMS_IMAGE} -f Containerfile.gems .
}

build_app() {
  podman build --security-opt label=disable -t ${APP_IMAGE} -f Containerfile.app .
}

build_server() {
  podman build --security-opt label=disable -t ${SERVER_IMAGE} -f Containerfile.server .
}

extract_build() {
  podman create --name ${PREFIX} --replace localhost/${APP_IMAGE}
  rm -rf build/
  podman cp ${PREFIX}:/usr/src/app/build build
  podman rm ${PREFIX}
}

clean() {
  podman rmi -f ${BASE_IMAGE} ${GEMS_IMAGE} ${APP_IMAGE} ${SERVER_IMAGE} || true
  rm -rf build/
}

if $EXTRACT; then
  build_app
  extract_build
  exit 0
fi

if $RUN; then
  build_app
  build_server

  podman run --security-opt label=disable --rm --name ${CONTAINER} -p ${PORT}:80 localhost/${SERVER_IMAGE}
  exit 0
fi

case "${PHASE}" in
  base)   build_base ;;
  gems)   build_gems ;;
  app)    build_app ;;
  server) build_server ;;
  clean)  clean ;;
  "")
    build_base
    build_gems
    build_app
    build_server
    ;;
  *)
    echo "Unknown build phase: ${PHASE}. Valid phases: base, gems, app, server" >&2
    exit 1
    ;;
esac
