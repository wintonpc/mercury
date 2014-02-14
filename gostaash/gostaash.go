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
		go OnClientConnect(conn)
	}
}

func OnClientConnect(conn net.Conn) {
	fmt.Println("Client connected")
	for {
		chunk, err := readChunk(conn)
		if err != nil {
			fmt.Println("Client disconnected")
			return
		}
		wireRead(chunk)
		checkError(err)

	}
}

type Msg interface{}

func wireRead(buf []byte) Msg {
	wireMsg := &ib.WireMessage{}
	err := proto.Unmarshal(buf, wireMsg)
	checkError(err)
	fqn := fmt.Sprintf("%v.v%v.%v", wireMsg.GetInterfaceName(), wireMsg.GetInterfaceVersion(), wireMsg.GetMessageType())
	msgType := typeFor[fqn]
	fmt.Printf("wireRead %v\n", msgType)
	return nil
}

func checkError(err error) {
	if err != nil {
		panic(fmt.Sprintf("Fatal error %v", err.Error()))
	}
}

func readChunk(conn net.Conn) ([]byte, error) {
	length, err := readUint32(conn)
	if err != nil {
		return nil, err
	}
	bytes, err := readN(length, conn)
	if err != nil {
		return nil, err
	}
	return bytes, nil
}

func readUint32(conn net.Conn) (uint32, error) {
	buf, err := readN(4, conn)
	if err != nil {
		return 0, err
	}
	return binary.BigEndian.Uint32(buf), nil
}

func readN(length uint32, conn net.Conn) ([]byte, error) {
	buf := make([]byte, length)
	nRead := uint32(0)
	for nRead < length {
		n, err := conn.Read(buf[nRead:])
		if err != nil {
			return nil, err
		}
		nRead = nRead + uint32(n)
	}
	return buf, nil
}
