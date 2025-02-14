#!/bin/bash
set -e

MONGO_VERSION='7.0.16'
SRC="r$MONGO_VERSION"
TARGET="mongodb-linux-x86_64-${MONGO_VERSION}"
BIN="$TARGET/bin"
mongoSrcUrl="https://github.com/mongodb/mongo/archive/refs/tags/$SRC.tar.gz"

mongoSrcFolder="mongo-$SRC"
[ ! -f "${SRC}.tar.gz" ] && curl -L -C - -O "$mongoSrcUrl"
[ ! -d $SRC ] && tar -xzf "${SRC}.tar.gz"
echo "{\"version\": \"${MONGO_VERSION}\"}" > $mongoSrcFolder/version.json

docker run --memory=58g --rm -it -v $(pwd)/$mongoSrcFolder:/mongodb mongodb-builder -e MONGO_VERSION="${MONGO_VERSION}"

mkdir -p $BIN
sudo mv "$mongoSrcFolder/build/install/bin/mongos" "$mongoSrcFolder/build/install/bin/mongod" $BIN
sudo tar -czf "$TARGET.tgz" $TARGET
