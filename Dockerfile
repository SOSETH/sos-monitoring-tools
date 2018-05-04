FROM uubk/debuild:stretch

RUN apt update && \
  apt upgrade -y && \
  apt install -y golang-go \
    golang-any \
    dh-golang \
    libibumad-dev \
    libibnetdisc-dev \
    libboost-all-dev \
    libibmad-dev \
    libopensm-dev \
    libyaml-cpp-dev \
    perl \
    libmodule-install-perl \
    libmonitoring-plugin-perl \
    python3-pysnmp4 \
    python3 \
    libextutils-makemaker-cpanfile-perl \
    libmonitoring-plugin-perl \
    libswitch-perl \
    libjson-xs-perl \
    libtext-trim-perl \
    libtry-tiny-perl \
    libexception-class-perl \
    libnet-snmp-perl \
    python3-setuptools \
    python3-venv \
    cmake \
    libaliased-perl \
    libmodule-pluggable-perl

RUN echo "deb http://ftp.debian.org/debian stretch-backports main" > /etc/apt/sources.list.d/backports.list && \
  apt update && \
  apt install -t stretch-backports -y golang-1.10-go

COPY . /tmp/wd
WORKDIR /tmp/wd
RUN ./build.sh && \
  tar -C /tmp/wd/out -cvf /pkg.tar . && \
  rm -Rf /tmp/wd

ENTRYPOINT ["/bin/tar"]
CMD ["-xvf", "/pkg.tar", "-C", "/data"]
