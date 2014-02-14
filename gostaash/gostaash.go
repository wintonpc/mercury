package main

import (
	"fmt"
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
	fmt.Println("Client connected")
	defer func() {
		fmt.Println("Client disconnected:", recover())
	}()
	for {
		msg := wire.ReadMsg(conn)
		fmt.Println("got msg:", msg)
	}
}

func checkError(err error) {
	if err != nil {
		panic(fmt.Sprintf("Fatal error %v", err.Error()))
	}
}
