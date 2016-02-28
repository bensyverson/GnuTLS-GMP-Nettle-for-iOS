#!/bin/bash

# Library name, version and location
LIBNAMES=("libgmp" "libnettle" "libtasn1" "libgnutls")
FILENAMEBASES=("gmp" "nettle" "libtasn1" "gnutls" )
REMOTEURLROOTS=("ftp://ftp.gnu.org/gnu/gmp/" "http://www.lysator.liu.se/~nisse/archive/" "http://ftp.gnu.org/gnu/libtasn1/" "ftp://ftp.gnupg.org/gcrypt/gnutls/v3.4/" )
COMPRESSIONTYPES=("bz2" "gz" "gz" "xz" )
LIBVERSIONS=("6.1.0" "3.2" "3.3" "3.4.9" )
LIBFLAGSLIST=("--disable-assembly" "--disable-assembler --disable-arm-neon" "" "--without-p11-kit")
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
	[ -e "${OGLIB}/${LIBNAMES[i]}.a" ] && continue
	echo "🚧  🚧  🚧  🚧  🚧  🚧  🚧  🚧  🚧  🚧  🚧  🚧  "
	echo "🎯  Building target ${LIBNAMES[i]}"
	LIBNAME=${LIBNAMES[i]}
	FILENAMEBASE=${FILENAMEBASES[i]}
	REMOTEURLROOT=${REMOTEURLROOTS[i]}
	COMPRESSIONTYPE=${COMPRESSIONTYPES[i]}
	LIBVERSION=${LIBVERSIONS[i]}
	LIBFLAGS=${LIBFLAGSLIST[i]}
	. ./build-generic.sh
done
