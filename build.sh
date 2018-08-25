#!/usr/bin/env bash

# The platforms to build
PLATFORMS=("windows/amd64" "linux/amd64" "darwin/amd64")
BUILD_DIR=$GOPATH/src/github.com/javabilities/go-aws-utils/build
DIST_DIR=$GOPATH/src/github.com/javabilities/go-aws-utils/dist

# Build the binaries for each command and platform combination
cd $GOPATH/src/github.com/javabilities/go-aws-utils
for CMD in `ls cmd`
do
    for platform in "${PLATFORMS[@]}"
    do
        platform_split=(${platform//\// })
        GOOS=${platform_split[0]}
        GOARCH=${platform_split[1]}
        PLATFORM_BUILD_DIR="build/$GOOS-$GOARCH"
        BINARY_NAME=$CMD
        if [ $GOOS = "windows" ]; then
            BINARY_NAME+='.exe'
        fi

        env GOOS=$GOOS GOARCH=$GOARCH go build -o $PLATFORM_BUILD_DIR/$BINARY_NAME ./cmd/$CMD
        if [ $? -ne 0 ]; then
            echo 'An error has occurred! Aborting the script execution...'
            exit 1
        fi
    done
done

# Build the distribution for each platform
mkdir -p $DIST_DIR
cd $BUILD_DIR
for platform in "${PLATFORMS[@]}"
do
    platform_split=(${platform//\// })
    GOOS=${platform_split[0]}
    GOARCH=${platform_split[1]}
    DIST_FILE="$DIST_DIR/$GOOS-$GOARCH.zip"
    zip -r $DIST_FILE "$GOOS-$GOARCH"
done
