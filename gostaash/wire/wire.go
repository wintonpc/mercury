package wire

import (
	"code.google.com/p/goprotobuf/proto"
	"encoding/binary"
	"fmt"
	"gostaash/ib"
	"gostaash/ib/mutex/v1"
	"net"
	"reflect"
)

var typeFor map[string]reflect.Type = make(map[string]reflect.Type)

func typeOf(x interface{}) reflect.Type {
	return reflect.TypeOf(x).Elem()
}

func Initialize() {
	createProtoTypeMap()
}

func createProtoTypeMap() {
	typeFor["mutex.v1.Request"] = typeOf((*ib_mutex_v1.Request)(nil))
	typeFor["mutex.v1.Response"] = typeOf((*ib_mutex_v1.Response)(nil))
}

func ReadMsg(conn net.Conn) proto.Message {
	return Deserialize(ReadChunk(conn))
}

func Deserialize(buf []byte) proto.Message {
	wireMsg := unmarshal(buf, typeOf((*ib.WireMessage)(nil))).(*ib.WireMessage)
	fqn := fmt.Sprintf("%v.v%v.%v",
		wireMsg.GetInterfaceName(),
		wireMsg.GetInterfaceVersion(),
		wireMsg.GetMessageType())
	msg := unmarshal(wireMsg.GetMessageData(), typeFor[fqn])
	return msg
}

func unmarshal(buf []byte, t reflect.Type) proto.Message {
	msg := reflect.New(t).Interface().(proto.Message)
	err := proto.Unmarshal(buf, msg)
	checkError(err)
	return msg
}

func checkError(err error) {
	if err != nil {
		panic(fmt.Sprintf("Fatal error %v", err.Error()))
	}
}

func ReadChunk(conn net.Conn) []byte {
	length := readUint32(conn)
	bytes := readN(length, conn)
	return bytes
}

func readUint32(conn net.Conn) uint32 {
	buf := readN(4, conn)
	return binary.BigEndian.Uint32(buf)
}

func readN(length uint32, conn net.Conn) []byte {
	buf := make([]byte, length)
	nRead := uint32(0)
	for nRead < length {
		n, err := conn.Read(buf[nRead:])
		if err != nil {
			panic("Connection broke")
		}
		nRead = nRead + uint32(n)
	}
	return buf
}
