#!/bin/bash

# Library name, version and location
LIBNAMES=("libgmp" "libnettle" "libtasn1" "libgnutls" "libmsgpackc")
FILENAMEBASES=("gmp" "nettle" "libtasn1" "gnutls" "msgpack-c-master")
REMOTEURLROOTS=("ftp://ftp.gnu.org/gnu/gmp/" "http://www.lysator.liu.se/~nisse/archive/" "http://ftp.gnu.org/gnu/libtasn1/" "ftp://ftp.gnupg.org/gcrypt/gnutls/v3.4/" "https://github.com/msgpack/msgpack-c/archive/master.zip")
COMPRESSIONTYPES=("bz2" "gz" "gz" "xz" "github")
LIBVERSIONS=("6.1.0" "3.2" "4.7" "3.4.9" "current")
LIBFLAGSLIST=("--disable-assembly" "--disable-assembler --disable-arm-neon" "" "--without-p11-kit" "")
SECONDARYLIBS=("" "libhogweed" "" "libgnutlsxx")
C_STD=""
CPP_STD=""

ORIGINALPATH=${PWD}
CURRENTPATH="${PWD}/staging"
OGINCLUDE="$ORIGINALPATH/include/"
OGLIB="$ORIGINALPATH/lib/"
mkdir -p $OGINCLUDE
mkdir -p $OGLIB
mkdir -p $CURRENTPATH


for (( i = 0 ; i < ${#LIBNAMES[@]} ; i++ ))
do
	[ -e "${OGLIB}/${LIBNAMES[i]}.dylib" ] && continue
	echo "🚧  🚧  🚧  🚧  🚧  🚧  🚧  🚧  🚧  🚧  🚧  🚧  "
	echo "🎯  Building target ${LIBNAMES[i]}"
	SECONDARYLIB=${SECONDARYLIBS[i]}
	LIBNAME=${LIBNAMES[i]}
	FILENAMEBASE=${FILENAMEBASES[i]}
	REMOTEURLROOT=${REMOTEURLROOTS[i]}
	COMPRESSIONTYPE=${COMPRESSIONTYPES[i]}
	LIBVERSION=${LIBVERSIONS[i]}
	LIBFLAGS=${LIBFLAGSLIST[i]}
	. ./build-generic.sh
done
