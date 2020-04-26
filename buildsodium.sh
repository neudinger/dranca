# !/usr/bin/env bash
rm -rf libsodium lib;
mkdir -p $PWD/lib/;
git clone https://github.com/jedisct1/libsodium --branch stable;
cd libsodium;
./configure;
make && make check;
make install DESTDIR=$PWD/../lib/