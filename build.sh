#!/bin/sh

set -e

# Change the following line to point to the correct location of the cross-
# building toolchain on your system.
SYSROOT=/home/build/Android/android-ndk-r9d/platforms/android-15/arch-arm
# Change the following line to point to the location of the asasm binary.
# See http://www.riscos.info/index.php/Using_GCCSDK for details of how to
# build the toolchain that contains it.
ASASM=$PWD/../asasm

DEBUG=0

OBJDIR=$PWD/o

if [ ! -d $OBJDIR ]; then
    mkdir $OBJDIR
fi

cd s
$ASASM -G -Verbose -From BASIC105 $OBJDIR/basic.elf
$ASASM -G -Verbose -From SWILayer $OBJDIR/layer.elf
cd ..

arm-linux-androideabi-gcc -DDEBUG=$DEBUG -std=c99 -c -o $OBJDIR/main.o c/main.c --sysroot=$SYSROOT
arm-linux-androideabi-gcc -o basic $OBJDIR/main.o $OBJDIR/basic.elf $OBJDIR/layer.elf --sysroot=$SYSROOT
