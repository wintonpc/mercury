package wire

import (
	"code.google.com/p/goprotobuf/proto"
	"encoding/binary"
	"fmt"
	"gostaash/ib"
	"gostaash/ib/mutex/v1"
	"net"
	"reflect"
	"regexp"
	"strconv"
)

var typeFor map[string]reflect.Type = make(map[string]reflect.Type)
var fqnFor map[reflect.Type]string = make(map[reflect.Type]string)

func typeOf(x interface{}) reflect.Type {
	return reflect.TypeOf(x).Elem()
}

func Initialize() {
	createProtoTypeMap()
}

func createProtoTypeMap() {
	typeFor["mutex.v1.Request"] = typeOf((*ib_mutex_v1.Request)(nil))
	typeFor["mutex.v1.Response"] = typeOf((*ib_mutex_v1.Response)(nil))
	for k, v := range typeFor {
		fqnFor[v] = k
	}
}

func ReadMsg(conn net.Conn) interface{} {
	return Deserialize(ReadChunk(conn))
}

func WriteMsg(msg proto.Message, conn net.Conn) {
	iface, ver, msgType := parseFqn(fqnFor[reflect.TypeOf(msg).Elem()])
	wireMsg := &ib.WireMessage{
		WireVersion:      proto.Int32(1),
		InterfaceName:    &iface,
		InterfaceVersion: &ver,
		MessageType:      &msgType,
		MessageData:      marshal(msg),
	}
	wireMsgBuf := marshal(wireMsg)
	lenBytes := make([]byte, 4)
	binary.BigEndian.PutUint32(lenBytes, uint32(len(wireMsgBuf)))
	conn.Write(lenBytes)
	conn.Write(wireMsgBuf)
}

func parseFqn(fqn string) (iface string, ver int32, msgType string) {
	re := regexp.MustCompile("^(?P<interface>[A-Za-z0-9_]+).v(?P<version>[0-9]+).(?P<name>[A-Za-z0-9_]+)$")
	submatches := re.FindStringSubmatch(fqn)
	ver64, err := strconv.ParseUint(submatches[2], 0, 32)
	checkError(err)
	return submatches[1], int32(ver64), submatches[3]
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

func marshal(msg proto.Message) []byte {
	buf, err := proto.Marshal(msg)
	checkError(err)
	return buf
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
