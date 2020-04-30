FROM alpine:3.9 as builder

ENV JAMULUS_VERSION 3_5_2

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
   wget "https://github.com/corrados/jamulus/archive/r${JAMULUS_VERSION}.tar.gz" && \
   tar xzf r${JAMULUS_VERSION}.tar.gz

# Github directory format for tar.gz export
WORKDIR /tmp/jamulus-r${JAMULUS_VERSION}
RUN \
 echo "**** compiling source code ****" && \
   qmake "CONFIG+=nosound" Jamulus.pro && \
   make clean && \
   make && \
   cp Jamulus /usr/local/bin/ && \
   rm -rf /tmp/* && \
   apk del .build-dependencies

FROM alpine:3.9

RUN apk add --update --no-cache \
    qt-x11 icu-libs tzdata

COPY --from=builder /usr/local/bin/Jamulus /usr/local/bin/Jamulus
ENTRYPOINT ["Jamulus"]
