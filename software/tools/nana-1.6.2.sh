#!/bin/sh

source ./0_append_distro_path.sh

untar_file nana-1.6.2.tar

cd /c/temp/gcc
mv nana-1.6.2 src
mkdir build dest dest/lib


cd build

cmake \
"-DBUILD_SHARED_LIBS=OFF" \
"-DNANA_CMAKE_NANA_FILESYSTEM_FORCE=ON" \
"-DNANA_CMAKE_VERBOSE_PREPROCESSOR=OFF" \
-G "Unix Makefiles" /c/temp/gcc/src

# Adding -P avoids problems with linemarkers. Root cause unknown.
make $X_MAKE_JOBS all "CFLAGS=-s -O3" "DFNCPP=gcc -E -P"

make install

mv ../src/include ../dest/
mv libnana.a ../dest/lib/

cd /c/temp/gcc
rm -rf build src
mv dest nana-1.6.2
cd nana-1.6.2

7z -mx0 a ../nana-1.6.2.7z *
