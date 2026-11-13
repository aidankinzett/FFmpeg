#!/bin/sh -ex

# Built on Ubuntu 24.04 so the packages only need what it ships at runtime: in particular libva
# 2.20, which keeps FFmpeg from using vaMapBuffer2 (libva 2.21+).

NV_CODEC_HEADERS=n13.0.19.0
VULKAN_HEADERS=v1.4.350
DAV1D=1.5.4

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    curl \
    git \
    libdrm-dev \
    libva-dev \
    meson \
    nasm \
    ninja-build \
    patch \
    pkg-config \
    unzip \
    zstd

SRC="$(mktemp -d)"

# Ubuntu's headers are too old for FFmpeg's Vulkan hwaccels; these are header-only.
git clone --depth 1 --branch "$NV_CODEC_HEADERS" \
    https://github.com/FFmpeg/nv-codec-headers "$SRC/nv-codec-headers"
make -C "$SRC/nv-codec-headers" install PREFIX=/usr/local

git clone --depth 1 --branch "$VULKAN_HEADERS" \
    https://github.com/KhronosGroup/Vulkan-Headers "$SRC/Vulkan-Headers"
cp -r "$SRC/Vulkan-Headers/include/." /usr/local/include/

# Static dav1d for the AV1 decoder; package.sh merges it into libavcodec.
git clone --depth 1 --branch "$DAV1D" https://code.videolan.org/videolan/dav1d.git "$SRC/dav1d"
meson setup "$SRC/dav1d/build" "$SRC/dav1d" \
    --buildtype=release \
    --default-library=static \
    --prefix=/usr/local \
    --libdir=lib \
    -Denable_tools=false \
    -Denable_tests=false
ninja -C "$SRC/dav1d/build" install

rm -rf "$SRC"
