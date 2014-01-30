mkdir csharp
cd protos
..\protobuf-net\protogen.exe ^
 -i:ib\ascent\messages.proto ^
 -i:ib\common.proto ^
 -o:..\csharp\ProtobufTypes.cs ^
 -p:fixCase
cd ..
