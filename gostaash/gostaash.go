package main

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

func createProtoTypeMap() {
	typeFor["mutex.v1.Request"] = typeOf((*ib_mutex_v1.Request)(nil))
	typeFor["mutex.v1.Response"] = typeOf((*ib_mutex_v1.Response)(nil))
}

func main() {
	createProtoTypeMap()
	addr, err := net.ResolveTCPAddr("tcp", "0.0.0.0:7890")
	checkError(err)
	listener, err := net.ListenTCP("tcp", addr)
	checkError(err)
	fmt.Println("Listening...")
	for {
		conn, err := listener.Accept()
		checkError(err)
		go onClientConnect(conn)
	}
}

func onClientConnect(conn net.Conn) {
	fmt.Println("Client connected")
	defer func() {
		fmt.Println("Client disconnected:", recover())
	}()
	for {
		msg := wireRead(readChunk(conn))
		fmt.Println("got msg:", msg)
	}
}

func wireRead(buf []byte) proto.Message {
	wireMsg := &ib.WireMessage{}
	err := proto.Unmarshal(buf, wireMsg)
	checkError(err)
	fqn := fmt.Sprintf("%v.v%v.%v", wireMsg.GetInterfaceName(), wireMsg.GetInterfaceVersion(), wireMsg.GetMessageType())
	msgType := typeFor[fqn]
	msg := reflect.New(msgType).Interface().(proto.Message)
	err = proto.Unmarshal(wireMsg.GetMessageData(), msg)
	checkError(err)
	return msg
}

func checkError(err error) {
	if err != nil {
		panic(fmt.Sprintf("Fatal error %v", err.Error()))
	}
}

func readChunk(conn net.Conn) []byte {
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
