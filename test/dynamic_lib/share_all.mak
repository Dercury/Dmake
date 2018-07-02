
TARGET:=share.so

SRC_PATH:=$(CODE_ROOT)/dynamic_lib

INCLUDE_PATH:=$(CODE_ROOT)/static_lib

LIBS:=$(BUILD_PATH)/bin/real.o

RELEASE_PATH:=$(BUILD_PATH)/bin

include ../default_make_option.mak

#在makefile里设置动态库的链接路径，可以用参数-Wl,-rpath=$$ORIGIN/xx，$ORIGIN表示可执行文件的运行路径，多加一个$是为了在makefile中转义。
#通过这种方式设置的动态库查找路径的查找优先级最高。其次还有设置LD_LIBRARY_PATH，配置/etc/ld.so.conf等方式指定查找路径。
SHAREFLAGS:=-shared -fPIC -Wl,-rpath=$$ORIGIN

