cmake_minimum_required(VERSION 3.4.1)

file(GLOB_RECURSE SOURCES "../libs/*.c")
add_library(fezajni SHARED fezajni.c ${SOURCES})

include_directories(../includes)