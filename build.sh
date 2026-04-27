#!/usr/bin/env bash
set -euo pipefail

PHASE=""
PREFIX="sgi"
BASE_IMAGE="${PREFIX}-base"
GEMS_IMAGE="${PREFIX}-gems"
APP_IMAGE="${PREFIX}-app"


while [[ $# -gt 0 ]]; do
  case "$1" in
    --phase|-p)
      PHASE="$2"
      shift 2
      ;;
    *)
      echo "Unknown argument: $1" >&2
      exit 1
      ;;
  esac
done

build_base() {
  podman build --security-opt label=disable -t ${BASE_IMAGE} -f Containerfile.base .
}

build_gems() {
  podman build --security-opt label=disable -t ${GEMS_IMAGE} -f Containerfile.gems .
}

build_app() {
  podman build --security-opt label=disable -t ${APP_IMAGE} -f Containerfile.app .
  podman create --name ${PREFIX} --replace -p 8080:80 localhost/${APP_IMAGE}
  rm -rf build/
  podman cp ${PREFIX}:/usr/local/apache2/htdocs/ build
  podman rm ${PREFIX}
}

clean() {
  podman rmi -f ${BASE_IMAGE} ${GEMS_IMAGE} ${APP_IMAGE} || true
  rm -rf build/
}

case "${PHASE}" in
  base) build_base ;;
  gems) build_gems ;;
  app)  build_app ;;
  clean) clean ;;
  "")
    build_base
    build_gems
    build_app
    ;;
  *)
    echo "Unknown phase: ${PHASE}. Valid phases: base, gems, app" >&2
    exit 1
    ;;
esac
