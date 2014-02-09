#!/bin/bash

pushd protobuf
ruby gen-ruby.rb
mkdir ../lib/messages 2> /dev/null
cp -r ruby/* ../lib/messages
popd
