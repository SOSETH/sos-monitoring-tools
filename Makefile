jessie:
	./dbuild.sh jessie

stretch:
	./dbuild.sh stretch

snmp.yml:
	./mbuild.sh

clean:
	rm -Rf out out-* *.changes *.buildinfo

dist-clean:
	./srcclean.sh check_lm_sensors
	./srcclean.sh check_raid
	./srcclean.sh ceph-dash

all:	jessie
all:	stretch
all:	snmp.yml
