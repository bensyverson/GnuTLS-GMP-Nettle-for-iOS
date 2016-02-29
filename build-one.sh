#!/bin/bash

# Library name, version and location
LIBNAMES=("libtasn1" )
FILENAMEBASES=("libtasn1" )
REMOTEURLROOTS=("http://ftp.gnu.org/gnu/libtasn1/" )
COMPRESSIONTYPES=( "gz"  )
LIBVERSIONS=( "4.7"  )
LIBFLAGSLIST=("")
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
	[ ! -e $FILENAME ] && continue
	. ./build-generic.sh
done
