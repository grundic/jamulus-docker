FROM alpine:3.9 as builder

ENV JAMULUS_VERSION 3.4.4

RUN \
 echo "**** updating system packages ****" && \
 apk update

RUN \
 echo "**** install build packages ****" && \
   apk add --no-cache --virtual .build-dependencies \
        build-base \
        wget \
        qt-dev

WORKDIR /tmp
RUN \
 echo "**** getting source code ****" && \
   wget "https://netix.dl.sourceforge.net/project/llcon/Jamulus/${JAMULUS_VERSION}/Jamulus-${JAMULUS_VERSION}.tar.gz" && \
   tar xzf Jamulus-${JAMULUS_VERSION}.tar.gz

# no dash between name and version.
WORKDIR /tmp/Jamulus${JAMULUS_VERSION}
RUN \
 echo "**** compiling source code ****" && \
   qmake "CONFIG+=nosound" Jamulus.pro && \
   make clean && \
   make && \
   cp Jamulus /usr/local/bin/ && \
   rm -rf /tmp/* && \
   apk del .build-dependencies

FROM alpine:3.9

EXPOSE 22124/udp

RUN apk add --update --no-cache \
    qt-x11 icu-libs

COPY --from=builder /usr/local/bin/Jamulus /usr/local/bin/Jamulus
COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
