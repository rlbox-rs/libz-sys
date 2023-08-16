#!/usr/bin/env bash

pushd zlib || exit

CHOST=wasm32-unknown-wasi CC=wasm32-unknown-wasi-clang AR=wasm32-unknown-wasi-ar RANLIB=wasm32-unknown-wasi-ranlib NM=wasm32-unknown-wasi-nm CFLAGS="-nostdlib -Wl,--no-entry" ./configure --static
make

popd || exit
