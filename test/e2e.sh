#!/bin/sh

set -o errexit
set -o nounset
set -o pipefail
set -o xtrace

REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "${REPO_ROOT}"

source "${REPO_ROOT}"/test/boskos.sh

build(){
	bazel build //release:release-tars
}

up() {
	acquire_boskos
	"${REPO_ROOT}"/cluster/kube-up.sh
}

down() {
	"${REPO_ROOT}"/cluster/kube-down.sh
}

cleanup(){
	down
	cleanup_boskos
}

trap "cleanup" EXIT

build
up
