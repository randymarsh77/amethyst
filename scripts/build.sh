#! /bin/bash

BASEDIR="$(dirname "$0")"
echo "Basing from $BASEDIR"

set -e

pushd $BASEDIR/../servers/content >> /dev/null
echo "Building content-server from $(pwd)..."
swift build
popd >> /dev/null

pushd $BASEDIR/../servers/meta >> /dev/null
echo "Building meta-server from $(pwd)..."
swift build
popd >> /dev/null

pushd $BASEDIR/../cli >> /dev/null
echo "Building CLI from $(pwd)..."
swift build
popd >> /dev/null

pushd $BASEDIR >> /dev/null
echo "Installing into $(pwd)..."
cd ..
rm -rf bin
mkdir bin
cd bin
ln -s ../cli/.build/debug/amethyst amethyst
ln -s ../servers/content/.build/debug/content-server content-server
ln -s ../servers/meta/.build/debug/meta-server meta-server
popd >> /dev/null

echo "Success!"
