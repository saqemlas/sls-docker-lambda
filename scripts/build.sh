#!/bin/bash
set -Eeuxo pipefail

while :; do
  case "${1:-}" in
    --repo)
      repo="${2}"
      shift;;
    *)
      break
  esac
  shift
done

function die () {
    echo "FATAL: ${*}" 1>&2
    exit 1
}

[[ -z "${repo}" ]] && echo "docker image repository name must be set!"
[[ -z "${repo}" ]] && die "Required variables not provided"

docker build -t $repo .
