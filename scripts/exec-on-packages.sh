#! /bin/bash

BASEDIR="$(dirname "$0")"
echo "Basing from $BASEDIR"

pushd $BASEDIR/../lib >> /dev/null
echo "Executing `$@` from $(pwd)..."
$@
popd >> /dev/null

pushd $BASEDIR/../servers/content >> /dev/null
echo "Executing `$@` from $(pwd)..."
$@
popd >> /dev/null

pushd $BASEDIR/../servers/meta >> /dev/null
echo "Executing `$@` from $(pwd)..."
$@
popd >> /dev/null

pushd $BASEDIR/../cli >> /dev/null
echo "Executing `$@` from $(pwd)..."
$@
popd >> /dev/null

echo "Success!"
