#!/bin/bash

DIST="${1}"

if [ ! -d out ] ; then
    mkdir out
fi

if [ -z "${BUILD_GOLANG_VERSION}" ] ; then
    export BUILD_GOLANG_VERSION=1.10
fi

set -e

# Golang
# To prevent issues with user-supplied go environments (aka go version != 1.7
# on strech), we reset the environment to a known, clean state
export PATH="/usr/lib/go-${BUILD_GOLANG_VERSION}/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
export GOROOT="/usr/lib/go-${BUILD_GOLANG_VERSION}"
export GOPATH="$(pwd)/gosrc"

go version
cd $GOPATH/src/github.com/prometheus/snmp_exporter
make build
cd /tmp/wd
go build github.com/prometheus/snmp_exporter/generator
go install github.com/prometheus/snmp_exporter/generator
gosrc/bin/generator generate
# vim: set ts=4 sw=4 tw=0 et :
