#!/bin/sh

# requires beefcake gem

mkdir cpp &2> /dev/null
protoc --cpp_out ./cpp --proto_path=protos protos/ib/common.proto 
protoc --cpp_out ./cpp --proto_path=protos protos/ib/ascent/messages.proto 
