#!/bin/bash

pushd protobuf

ruby gen-ruby.rb
mkdir ../lib/messages 2> /dev/null
cp -rv ruby/* ../lib/messages

ruby gen-go.rb
cp -rv go/ib ../gostaash

popd
