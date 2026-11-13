#!/bin/sh -e

# Generate build matrix

target() {
    printf '{"runs-on": "%s", "arch": "%s", "platform": "%s", "container": "%s"}' "$1" "$2" "$3" "$4"
}

first=1
add() {
    [ "$first" -eq 1 ] && first=0 || printf ','
    target "$1" "$2" "$3" "$4"
}

printf '['

# Linux only: Ubuntu 24.04, so the packages need nothing newer than it ships (libva 2.20).
# Other platforms keep using crueter-ci/FFmpeg.
add ubuntu-latest amd64 linux "ubuntu:24.04"
add ubuntu-24.04-arm aarch64 linux "ubuntu:24.04"

echo ']'
