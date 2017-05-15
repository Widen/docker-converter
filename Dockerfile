FROM quay.io/widen/oracle-server-jre:8

ENV BUILD_DEPS "curl ca-certificates build-essential"

ARG EXIFTOOL_VERSION
ENV EXIFTOOL_VERSION ${EXIFTOOL_VERSION}

ARG GS_VERSION
ENV GS_VERSION ${GS_VERSION}

RUN apt-get update && \
  apt-get -y --no-install-recommends install ${BUILD_DEPS} perl imagemagick && \
  mkdir -p /tmp/exiftool && curl --silent --location --retry 3 \
    http://www.sno.phy.queensu.ca/~phil/exiftool/Image-ExifTool-${EXIFTOOL_VERSION}.tar.gz | \
      tar -xz -C /tmp/exiftool --strip-components=1 && \
  cd /tmp/exiftool && perl Makefile.PL && make test && make install && \
  mkdir -p /tmp/ghostscript && curl --silent --location --retry 3 \
    https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs921/ghostscript-${GS_VERSION}.tar.gz | \
      tar -xz -C /tmp/ghostscript --strip-components=1 && \
  cd /tmp/ghostscript && ./configure && make && make install && cd && \
  rm -rf /tmp/* && \
  apt-get -y --purge remove ${BUILD_DEPS} && \
  apt-get -y --purge autoremove && apt-get -y clean && \
  rm -rf /var/lib/apt/lists/* /var/cache/debconf/* /tmp/* /var/tmp/*
