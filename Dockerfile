# First stage
FROM alpine:latest

ENV PSPDEV /usr/local/pspdev
ENV PATH $PATH:${PSPDEV}/bin
COPY . /src


RUN apk add autoconf automake bzip2 gzip libtool ncurses-dev readline-dev xz zlib-dev \
    build-base bash gcc git make flex bison texinfo gmp-dev mpfr-dev mpc1-dev
RUN mkdir $PSPDEV
RUN cd /src && ./toolchain.sh 1 2

# Second stage
FROM alpine:latest

ENV PSPDEV /usr/local/pspdev
ENV PATH $PATH:${PSPDEV}/bin

COPY --from=0 ${PSPDEV} ${PSPDEV}
