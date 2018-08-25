#!/usr/bin/env bash

cd $GOPATH/src/github.com/javabilities/go-aws-utils
for CMD in `ls cmd`; do
  go install ./cmd/$CMD
done
