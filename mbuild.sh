#!/bin/bash

set -e

echo "########################################################################"
echo "################## Building snmp_exporter MIB file #####################"
echo "########################################################################"
echo "## This file will include MIBs with the following licenses:           ##"
echo "##  * Cisco: Proprietary, All rights reserved. Please consult         ##"
echo "##    ftp://ftp.cisco.com/pub/mibs/v2/ for more information           ##"
echo "##  * Synology: Proprietary, All rights reserved.                     ##"
echo "##  * Ubiquiti: Proprietary, All rights reserved.                     ##"
echo "########################################################################"
echo "## Please confirm that you tracked down and agreed to the respective  ##"
echo "## license (y/n)                                                      ##"
read agreed

if [ "${agreed}" != "y" ] ; then
    exit -1
fi

cd mibs
wget -c -Ocisco.tar.gz ftp://ftp.cisco.com/pub/mibs/v2/v2.tar.gz
wget -c -Osyno.zip https://global.download.synology.com/download/Document/MIBGuide/Synology_MIB_File.zip
wget -c http://dl.ubnt-ut.com/snmp/UBNT-UniFi-MIB
wget -c https://dl.ubnt.com/firmwares/airos-ubnt-mib/ubnt-mib.zip
tar -xvf cisco.tar.gz
unzip syno.zip
unzip ubnt-mib.zip
mv Synology_MIB_File_20170410/* .
mv auto/mibs/v2/* .
cd ..

docker build -t "sosmon-mibs" -f "Dockerfile.mibs" --build-arg "LUID=$(id -u)" .
if [ ! -d "out-mibs" ] ; then
    mkdir "out-mibs"
fi
docker run -v "$(pwd)/out-mibs":/data "sosmon-mibs"
