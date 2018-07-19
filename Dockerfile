FROM dorowu/ubuntu-desktop-lxde-vnc:trusty


ENV PKG_CONFIG_PATH=/usr/local/lib/pkgconfig \
    SRC=/usr/local

RUN buildDeps="autoconf \
                automake \
                build-essential \
                libass-dev \
                libsdl1.2-dev \
                libtheora-dev \
                libtool \
                libva-dev \
                libvdpau-dev \
                libvorbis-dev \
                libxcb1-dev \
                libxcb-shm0-dev \
                libxcb-xfixes0-dev \
                libvpx-dev \
                libopus-dev \
                libgsm1-dev \
                libfaac-dev \
                libgstreamer-plugins-bad1.0-dev \
                libspeexdsp-dev \
                libssl-dev \
                texinfo \
                zlib1g-dev \
                yasm \
                nasm \
                tar \
                curl \
                wget \
                git \
                pkg-config \
                zlib1g-dev" && \
    export MAKEFLAGS="-j$(($(nproc) + 1))" && \
    apt-get -yqq update && \
    apt-get install -yq --no-install-recommends ${buildDeps} ca-certificates

RUN DIR=$(mktemp -d) && cd ${DIR} && \
    curl -sL http://download.savannah.gnu.org/releases/freetype/freetype-2.4.12.tar.bz2 | \
    tar -jx --strip-components=1 && \
    ./configure --prefix="${SRC}" --bindir="${SRC}/bin" && \
    make && \
    make install && \
    rm -rf ${DIR}

RUN DIR=$(mktemp -d) && cd ${DIR} && \
    curl -sL https://download.videolan.org/x264/snapshots/x264-snapshot-20161127-2245.tar.bz2 | \
    tar -jx --strip-components=1 && \
    ./configure --prefix="${SRC}" --bindir="${SRC}/bin" --enable-shared --enable-pic && \
    make && \
    make install && \
    rm -rf ${DIR}

RUN DIR=$(mktemp -d) && cd ${DIR} && \
    curl -sL https://github.com/cisco/openh264/archive/v1.6.0.tar.gz | \
    tar -zx --strip-components=1 && \
    make ENABLE64BIT=Yes && \
    make install && \
    rm -rf ${DIR}

RUN DIR=$(mktemp -d) && cd ${DIR} && \
    curl -sL http://ffmpeg.org/releases/ffmpeg-1.2.12.tar.gz | \
    tar -zx --strip-components=1 && \
    ./configure --prefix="${SRC}" \
    --extra-cflags="-I${SRC}/include -fPIC" \
    --extra-ldflags="-L${SRC}/lib -lpthread" \
    --bindir="${SRC}/bin" \
    --disable-doc \
    --enable-pic \
    --enable-memalign-hack \
    --enable-pthreads \
    --enable-shared \
    --disable-static \
    --enable-pthreads \
    --disable-ffmpeg \
    --disable-ffplay \
    --disable-ffserver \
    --disable-ffprobe \
    --enable-gpl \
    --disable-debug \
    --enable-libfreetype \
    --enable-libfaac \
    --enable-nonfree && \
    make && \
    make install && \
    rm -rf ${DIR}

RUN apt-get purge -y ${buildDeps} && \
    apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists