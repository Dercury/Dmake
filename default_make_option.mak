######################################## 标准变量 #################################################
# C语言编译程序
CC:=gcc
# C语言编译器参数
CFLAGS:=-Wall -O3 -fPIC -g

# C预处理器
CPP:=$(CC) -E
# C预处理器参数
CPPFLAGS:=

# C++编译程序
CXX:=g++
# C++编译器参数
CXXFLAGS:=

# 汇编语言编译程序
AS:=as
# 汇编编译器参数
ASFLAGS:=

# 函数库打包程序
AR:=ar
# 函数库打包程序参数
ARFLAGS:=crv

# 链接器
LD:=ld
# 链接器参数
LDFLAGS:=-r

#删除文件命令
RM:=rm -f

####################################### 自定义变量 ###################################################
SHAREFLAGS:=-shared -fPIC
