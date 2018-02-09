#!/bin/bash

setup() {
	sudo apt install \
		flawfinder \
		valgrind \
		-y
}
setup
