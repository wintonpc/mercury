package main

import (
	"encoding/binary"
	"fmt"
	"net"
)

func main() {
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
		//chunk, err := readChunk(conn)
		theInt, err := readUint(conn)
		if err != nil {
			fmt.Println("Client disconnected")
			return
		}
		checkError(err)
		fmt.Print(theInt)
	}
}

func checkError(err error) {
	if err != nil {
		panic(fmt.Sprintf("Fatal error %v", err.Error()))
	}
}

func readChunk(conn net.Conn) ([]byte, error) {
	length, err := readUint(conn)
	if err != nil {
		return nil, err
	}
	bytes, err := readN(length, conn)
	if err != nil {
		return nil, err
	}
	return bytes, nil
}

func readUint(conn net.Conn) (uint, error) {
	buf, err := readN(4, conn)
	if err != nil {
		return 0, err
	}
	return binary.LittleEndian.Uint32(buf), nil
}

func readN(length uint, conn net.Conn) ([]byte, error) {
	buf := make([]byte, length)
	nRead := uint(0)
	for nRead < length {
		n, err := conn.Read(buf[nRead:])
		if err != nil {
			return nil, err
		}
		nRead = nRead + uint(n)
	}
	return buf, nil
}
