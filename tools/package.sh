#!/bin/sh -e

set -e

# shellcheck disable=SC1091

. tools/common.sh

ROOTDIR="$PWD"

copy_build_artifacts() {
	_group "Copying build artifacts"

	make install -C "$DIRECTORY"
	rm -rf out/share out/lib/pkgconfig

	_end
}

# Merge the static dav1d into libavcodec, so the package needs nothing else linked.
merge_dav1d() {
	_group "Merging dav1d into libavcodec"

	dav1d="$(pkg-config --variable=libdir dav1d)/libdav1d.a"
	printf 'OPEN out/lib/libavcodec.a\nADDLIB %s\nSAVE\nEND\n' "$dav1d" | ar -M
	ranlib out/lib/libavcodec.a

	_end
}

copy_build_artifacts
if linux; then
	merge_dav1d
fi
copy_cmake
package

echo "-- Done! Artifacts are in $ROOTDIR/artifacts, raw lib/include data is in out"