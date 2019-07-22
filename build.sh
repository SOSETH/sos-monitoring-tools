#!/bin/bash

DIST="${1}"

if [ ! -d out ] ; then
    mkdir out
fi

if [ -z "${BUILD_GOLANG_VERSION}" ] ; then
    export BUILD_GOLANG_VERSION=1.11
fi

set -e

function buildpkg {
    if [ ! -f out/${1} ] ; then
        cd "${2}"
        dpkg-buildpackage -b -us -uc
        cd ..
        mv *.deb out/
    fi
}

echo "Building SOS monitoring tools on $(uname -a)"
echo "Target: $(cat /etc/os-release)"

# Shell
buildpkg check-apcupsd_*.deb check_apcupsd
buildpkg check-iostat_*.deb check_iostat

# Python
buildpkg check-sas-smart_*.deb check_sas_smart
buildpkg check-power_*.deb check_power
buildpkg check-mem_*.deb check_mem

# C++
buildpkg check-ib_*.deb check_ib
buildpkg tcpdup_*.deb tcpdup

# Perl
buildpkg check-ipmi-sensor_*.deb check_ipmi_sensor_v3
buildpkg check-lm-sensors_*.deb check_lm_sensors
buildpkg check-raid_*.deb check_raid
buildpkg check-snmp-int_*.deb check_snmp_int
buildpkg check-smartvalues_*.deb check_smartvalues
buildpkg check-lsi-raid_*.deb check_lsi_raid

# Golang
# To prevent issues with user-supplied go environments (aka go version != 1.7
# on strech), we reset the environment to a known, clean state
export PATH="/usr/lib/go-${BUILD_GOLANG_VERSION}/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
export GOROOT="/usr/lib/go-${BUILD_GOLANG_VERSION}"
export GOPATH="$(pwd)/gosrc"
if [ ! -d gosrc ] ; then
    mkdir gosrc
    # We also need dep since we don't include the vendor dir in GIT
    /usr/lib/go-${BUILD_GOLANG_VERSION}/bin/go get -u github.com/golang/dep/cmd/dep
fi

go version

buildpkg check-ceph_*.deb check-ceph
buildpkg prometheus-graphite-exporter_*.deb graphite_exporter
buildpkg prometheus-snmp-exporter_*.deb snmp_exporter
# vim: set ts=4 sw=4 tw=0 et :
