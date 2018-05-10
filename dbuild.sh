#!/bin/bash

DIST="$1"

docker build -t "sosmon-${DIST}" -f "Dockerfile.${DIST}" --build-arg "LUID=$(id -u)" .
if [ ! -d "out-${DIST}" ] ; then
	mkdir "out-${DIST}"
fi
docker run -v "$(pwd)/out-${DIST}":/data "sosmon-${DIST}"
