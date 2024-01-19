FROM alpine:3.11 as builder

RUN \
 echo "**** updating system packages ****" && \
 apk update

RUN \
 echo "**** install build packages ****" && \
   apk add --no-cache --virtual .build-dependencies \
        build-base \
        wget \
        qt5-qtbase-dev \
        qt5-qttools-dev \
        qtchooser

WORKDIR /tmp
RUN \
 echo "**** getting source code ****" && \
   wget "https://github.com/jamulussoftware/jamulus/archive/latest.tar.gz" && \
   tar xzf latest.tar.gz

# Github directory format for tar.gz export
WORKDIR /tmp/jamulus-latest
RUN \
 echo "**** compiling source code ****" && \
   qmake "CONFIG+=nosound headless" Jamulus.pro && \
   make clean && \
   make && \
   cp Jamulus /usr/local/bin/ && \
   rm -rf /tmp/* && \
   apk del .build-dependencies

FROM alpine:3.11

RUN apk add --update --no-cache \
    qt5-qtbase-x11 icu-libs tzdata

COPY --from=builder /usr/local/bin/Jamulus /usr/local/bin/Jamulus
ENTRYPOINT ["Jamulus"]
