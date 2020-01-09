#!/bin/sh
# Run this to produce config.h.in and configure

rm -f config.cache && \
echo -n aclocal... && aclocal -I $1/macros && \
echo -n autoheader... && autoheader && \
echo -n autoconf... && autoconf && \
echo okay, now run ./configure.
rm -rf autom4te*.cache
