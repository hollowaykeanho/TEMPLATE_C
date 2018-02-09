#!/bin/bash

setup() {
	sudo apt install \
		gcc \
		flawfinder \
		valgrind \
		-y
}
setup
