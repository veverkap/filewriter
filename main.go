package main

import (
	"flag"
	"fmt"
	"os"
	"time"
)

var (
	flagOut = flag.String("output_file", "output.txt", "this is the file in the docker container to write to")
)

func main() {
	os.Exit(realMain(os.Args[1:]))
}

func realMain(args []string) int {
	fmt.Fprintf(os.Stdout, "We got these args: %+v\n\n", args)
	fmt.Fprint(os.Stdout, "GETTING STARTED HERE\n")
	fmt.Fprintf(os.Stdout, "Trying to create a file at %s\n", *flagOut)
	outputFile, err := os.Create(*flagOut)
	if err != nil {
		fmt.Fprintf(os.Stderr, "There was an error creating file (%s): %s", *flagOut, err.Error())
		return 1
	}
	fmt.Fprintf(outputFile, "This is something I wrote at %s\n", time.Now().Format(time.RFC3339))
	fmt.Fprint(os.Stdout, "Wrote the thing\n")
	return 0
}
