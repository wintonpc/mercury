package main

import (
	"code.google.com/p/goprotobuf/proto"
	"fmt"
	"gostaash/ib/mutex/v1"
	"gostaash/wire"
	"net"
)

func main() {
	wire.Initialize()
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
	//fmt.Println("Client connected")
	defer func() {
		recover()
		//fmt.Println("Client disconnected:", recover())
	}()
	for {
		msg := wire.ReadMsg(conn)
		switch msg.(type) {
		case *ib_mutex_v1.Request:
			response := &ib_mutex_v1.Response{
				Request:           msg.(*ib_mutex_v1.Request),
				ReleaseToken:      proto.String("foo"),
				WasObtained:       proto.Bool(false),
				ObtainedAbandoned: proto.Bool(false),
			}
			wire.WriteMsg(response, conn)
		}
	}
}

func checkError(err error) {
	if err != nil {
		panic(fmt.Sprintf("Fatal error %v", err.Error()))
	}
}
