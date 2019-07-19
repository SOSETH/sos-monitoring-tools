stretch:
	./dbuild.sh stretch

buster:
	./dbuild.sh buster

snmp.yml:
	./mbuild.sh

clean:
	rm -Rf out out-* *.changes *.buildinfo

dist-clean:
	./srcclean.sh check_lm_sensors
	./srcclean.sh check_raid

all:	stretch
all:	buster
all:	snmp.yml
