# FFmpeg CI

Scripts and CI for debloated FFmpeg, containing only h264, vp8, vp9, and hwaccel support.

This fork of [crueter-ci/FFmpeg](https://github.com/crueter-ci/FFmpeg) builds the Linux packages
(amd64 and aarch64) for Eglantine:

- Built on Ubuntu 24.04 rather than Arch, so they link against libva 2.20 and run on any system with
  libva 2.20 or newer (upstream's need 2.21+ for `vaMapBuffer2`).
- Include AV1 decoding: a static dav1d is merged into `libavcodec`, so nothing else needs linking.

Other platforms keep using crueter-ci/FFmpeg.

- [**Releases**](https://github.com/aidankinzett/FFmpeg/releases)
- Shared libraries (`BUILD_SHARED_LIBS=ON`) are not supported.
- CMake target: `FFmpeg::FFmpeg`

## Building and Usage

See the [spec](https://github.com/crueter-ci/spec).

## Dependencies

All: GNU make, pkg-config, curl, zstd, unzip, bash, working compiler

- `amd64` only: nasm
- Linux, MinGW: ffnvcodec-headers, vulkan-headers
