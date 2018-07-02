#

TARGET:=handle.so

SRC_FILE:=$(CODE_ROOT)/static_lib/handle.c

RELEASE_PATH:=$(BUILD_PATH)/bin

#LIBS:=/usr/lib64/libdl
LIBS:=-ldl

include ../default_make_option.mak

