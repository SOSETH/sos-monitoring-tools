#!/bin/bash

DIST="${1}"

if [ ! -d out ] ; then
    mkdir out
fi

if [ -z "${BUILD_GOLANG_VERSION}" ] ; then
    export BUILD_GOLANG_VERSION=1.10
fi

set -e

function buildpkg {
    if [ ! -f "out/${1}" ] ; then
        cd "${2}"
        dpkg-buildpackage -b -us -uc
        cd ..
        mv *.deb out/
    fi
}

echo "Building SOS monitoring tools on $(uname -a)"
echo "Target: $(cat /etc/os-release)"

# Shell
buildpkg check-apcupsd_2.6-1_all.deb check_apcupsd
buildpkg check-iostat_0.0.5_all.deb check_iostat

# Python
buildpkg check-sas-smart_0.2_amd64.deb check_sas_smart
buildpkg check-power_0.1_amd64.deb check_power
buildpkg check-mem_0.1-1_all.deb check_mem
buildpkg check-ceph-dash_0.1_amd64.deb check_ceph_dash
buildpkg ceph-dash_0.1_all.deb ceph-dash

# C++
buildpkg check-ib_0.1_amd64.deb check_ib
if [ "${DIST}" != "jessie" ] ; then
    buildpkg tcpdup_0.1+nmu1_amd64.deb tcpdup
fi

# Perl
buildpkg check-ipmi-sensor_3.12-1_all.deb check_ipmi_sensor_v3
buildpkg check-lm-sensors_4.4.1-36e453f-1_all.deb check_lm_sensors
buildpkg check-raid_4.0.8-1_all.deb check_raid
buildpkg check-snmp-int_1.24-1_all.deb check_snmp_int
buildpkg check-smartvalues_0.4-1.1_all.deb check_smartvalues
buildpkg check-lsi-raid_2.5-0495085-1_all.deb check_lsi_raid

# Golang
if [ "${DIST}" != "jessie" ] ; then
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

    buildpkg check-ceph_0.1_amd64.deb check-ceph
    buildpkg prometheus-graphite-exporter_0.2.0-d950808_amd64.deb graphite_exporter
    buildpkg ceph-exporter_2.0.0+git20171216.16c9efb-1_amd64.deb ceph_exporter
    buildpkg prometheus-snmp-exporter_0.10.0-e7d1c92_amd64.deb snmp_exporter
fi
# vim: set ts=4 sw=4 tw=0 et :
