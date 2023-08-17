#!/usr/bin/env bash

confirm() {
    # call with a prompt string or use a default
    read -r -p "${1:-Are you sure?} [y/N]" response
    case "$response" in
        [yY][eE][sS]|[yY])
            true
            ;;
        *)
            false
            ;;
    esac
}

pushd zlib || exit

container=$(command -v docker || command -v podman)
echo "$container"
if [ -n "$container" ] && confirm "build within a container?" ; then
  $container run -v "$(pwd)":/src -w /src ghcr.io/webassembly/wasi-sdk sh -c './configure && make'
else
  CHOST=wasm32-unknown-wasi CC=wasm32-unknown-wasi-clang AR=wasm32-unknown-wasi-ar RANLIB=wasm32-unknown-wasi-ranlib NM=wasm32-unknown-wasi-nm CFLAGS="-nostdlib -Wl,--no-entry" ./configure --static
  make
fi

popd || exit

