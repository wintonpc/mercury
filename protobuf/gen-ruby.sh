#!/bin/sh

# requires beefcake gem

function md () {
  mkdir -p $1 2> /dev/null
}

md ruby
BEEFCAKE_NAMESPACE=Ib protoc --beefcake_out ./ruby --proto_path=protos protos/ib/common.proto
md ruby/echo/v1
BEEFCAKE_NAMESPACE=Ib::Echo::V1 protoc --beefcake_out ./ruby/echo/v1 --proto_path=protos protos/ib/echo/v1/messages.proto
