#!/bin/bash
echo "ANDROID_NDK_HOME is $ANDROID_NDK_HOME"
PLATFORM=$ANDROID_NDK_HOME/platforms/android-21/arch-arm64/
PREBUILT=$ANDROID_NDK_HOME/toolchains/aarch64-linux-android-4.9/prebuilt/linux-x86_64

GENERAL="\
--enable-small \
--enable-cross-compile \
--extra-libs="-lgcc" \
--arch=aarch64 \
--cc=$PREBUILT/bin/aarch64-linux-android-gcc \
--cross-prefix=$PREBUILT/bin/aarch64-linux-android- \
--nm=$PREBUILT/bin/aarch64-linux-android-nm \
--extra-cflags="-I../x264/android/arm64/include" \
--extra-ldflags="-L../x264/android/arm64/lib" "

MODULES="\
--enable-gpl \
--enable-libx264"



function build_arm64
{
  ./configure \
  --logfile=conflog.txt \
  --target-os=linux \
  --prefix=./android/arm64-v8a \
  ${GENERAL} \
  --sysroot=$PLATFORM \
  --extra-cflags="" \
  --extra-ldflags="-lx264 -Wl,-rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib -nostdlib -lc -lm -ldl -llog" \
  --enable-shared \
  --disable-static \
  --disable-doc \
  --enable-zlib \
  ${MODULES}

  make clean
  find ./compat -name 'strtod.[d|o]' -exec rm {} \;
  make
  make install
}

build_arm64


echo Android ARM64 builds finished
