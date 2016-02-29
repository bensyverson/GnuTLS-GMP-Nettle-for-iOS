#!/bin/bash
set -x #echo on


#=================================================================================
#
# You can change values here
#=================================================================================
# Architectures array
ARCHS=("x86_64" "arm64" "i386" "armv7" "armv7s")
# ARCHS=("arm64")

# Platforms array
PLATFORMS=("iPhoneSimulator" "iPhoneOS")
# SDK versions array
SDKVERSION="9.2"

#=================================================================================
#
# You shouldn't need to change values here
#=================================================================================
OGINCLUDE="$ORIGINALPATH/include/"

mkdir -p $OGINCLUDE
mkdir -p $OGLIB
mkdir -p $CURRENTPATH

#mkdir -p "${CURRENTPATH}/build"
mkdir -p "${CURRENTPATH}/include"
mkdir -p "${CURRENTPATH}/lib"
mkdir -p "${CURRENTPATH}/src"
mkdir -p "${CURRENTPATH}/tar"
mkdir -p "${CURRENTPATH}/usr"
cd "${CURRENTPATH}/tar"

FILENAME="${FILENAMEBASE}-${LIBVERSION}.tar.${COMPRESSIONTYPE}"
if [ ! -e $FILENAME ]; then
        echo "  📞  Downloading ${FILENAME}"
        REMOTEFILE="${REMOTEURLROOT}${FILENAME}"
        curl -O $REMOTEFILE
else
        echo "  📦  Using ${FILENAME}"
fi
echo "    📦 Extracting files..."
tar zxf $FILENAME -C ${CURRENTPATH}/src/

PLATFORMREGEX="^arm"
LIPO="lipo -create"
LIPO2="lipo -create"
echo "  🚨  Beginning to build all for ${LIBNAME}"
echo "  🏛  Architectures: ${ARCHS[@]}"
for ARCH in "${ARCHS[@]}"
do
	if [[ $ARCH =~ $PLATFORMREGEX ]]
	then
		PLATFORM=${PLATFORMS[1]}
	else
		PLATFORM=${PLATFORMS[0]}
	fi
	echo "    🚀  COMPILING FOR ${PLATFORM}${SKDVERSION}-${ARCH}.sdk"
	OUTPUTPATH=${CURRENTPATH}/usr/${PLATFORM}${SDKVERSION}-${ARCH}.sdk
	mkdir -p "${OUTPUTPATH}"
	export PREFIX=${OUTPUTPATH}

	export SDKROOT=/Applications/Xcode.app/Contents/Developer/Platforms/${PLATFORM}.platform/Developer/SDKs/${PLATFORM}${SDKVERSION}.sdk
	#common toolchains for all platforms
	export DEVROOT=/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr

	export CC=$DEVROOT/bin/cc
	export LD=$DEVROOT/bin/ld
	export CXX=$DEVROOT/bin/c++
	# alias
	export AS=$DEVROOT/bin/as
	# alt
	# export AS=/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/libexec/as/x86_64/as

	export AR=$DEVROOT/bin/ar
	# alias
	export NM=$DEVROOT/bin/nm
	# alt
	# export NM="$DEVROOT/bin/nm -arch ${ARCH}"

#	export CPP=$DEVROOT/bin/cpp
	export CPP="$DEVROOT/bin/clang -E"
#	export CXXCPP=$DEVROOT/bin/cpp
	export CXXCPP="$DEVROOT/bin/clang -E"
	# alias as libtool
	export RANLIB=$DEVROOT/bin/ranlib

	# export TASN1_CFLAGS="-Ilibtasn1/include"
	# export TASN1_LIBS="-Llibtasn1 -ltasn1"

	export CC_FOR_BUILD="/usr/bin/clang -isysroot / -I/usr/include"

	COMMONFLAGS="-arch ${ARCH} \
-fembed-bitcode \
-pipe \
-O2 \
-isysroot ${SDKROOT} "

	export LDFLAGS="$COMMONFLAGS -L${CURRENTPATH}/lib -L${SDKROOT}/usr/lib"

	export CCASFLAGS="$COMMONFLAGS -I${OUTPUTPATH}/include -I${SDKROOT}/usr/include"
	export CFLAGS="$COMMONFLAGS $C_STD -I${OUTPUTPATH}/include -I${SDKROOT}/usr/include"
	export CXXFLAGS="$COMMONFLAGS $CPP_STD -I${OUTPUTPATH}/include -I${SDKROOT}/usr/include"
	export M4FLAGS="-I${PREFIX}/include -I${SDKROOT}/usr/include"

	export CPPFLAGS="$COMMONFLAGS $CPP_STD -I${OUTPUTPATH}/include -I${SDKROOT}/usr/include"

	cd ${CURRENTPATH}/src/$FILENAMEBASE*
	make clean
	make distclean

	echo "    ⚙  Configure..."
	echo "      📥  OUTPUTPATH: ${OUTPUTPATH}"
	./configure --prefix=${PREFIX} --host=arm-apple-darwin --disable-static --with-included-libtasn1 $LIBFLAGS

	echo "    🛠  Build..."

	LIPO="${LIPO} ${OUTPUTPATH}/lib/${LIBNAME}.dylib"
	if [ $LIBNAME == "libnettle" ]; then
		LIPO2="${LIPO2} ${OUTPUTPATH}/lib/libhogweed.dylib"	
	fi
	make -j16
	make install
	make clean
	cd ${CURRENTPATH}
done

cd ${CURRENTPATH}
echo "  🍔  📚   Creating fat library..."
FATNAME="${CURRENTPATH}/lib/${LIBNAME}.dylib"
LIPO="${LIPO} -output $FATNAME"
echo "  👾  lipo command:  $LIPO"
$LIPO

if [ $LIBNAME == "libnettle" ]; then
	FATNAME2="${CURRENTPATH}/lib/libhogweed.dylib"
	LIPO2="${LIPO2} -output $FATNAME2"
	echo "  👾  hogweed lipo command:  $LIPO2"
	$LIPO2
	cp $FATNAME2 $OGLIB
fi

cp $FATNAME $OGLIB

echo "  🚚  Copying headers..."
COPYHEADERS="cp -r ${OUTPUTPATH}/include/* $OGINCLUDE"
$COPYHEADERS
cd $ORIGINALPATH

echo "🏁  🎁   Done with ${LIBNAME}.  🏁"
echo "🔹🔹🔹🔹🔹🔹🔹🔹🔹🔹🔹🔹🔹🔹🔹🔹🔹🔹🔹🔹🔹🔹🔹🔹🔹🔹🔹🔹🔹🔹"
