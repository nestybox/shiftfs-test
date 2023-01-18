package main

import (
	"log"
	"os"
)

func main() {
	_, err := os.Create("test.txt")
	if err != nil {
		log.Fatal(err)
	}
	if err := os.Rename("test.txt", "test2.txt"); err != nil {
		os.Remove("test.txt")
		log.Fatal(err)
	}
	os.Remove("test2.txt")
}
