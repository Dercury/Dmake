######################################## 对外依赖 #################################################
# TARGET: 编译目标
# CODE_ROOT: 代码根目录
# SRC_PATH: 源文件路径列表
# SRC_FILE: 源文件列表
# INCLUDE_PATH: 头文件路径，不需要带"-I"    TODO: 考虑带"-I"的保护
# INSTALL_PATH: 安装目录
# BUILD_TYPE: DEBUG或其他

# CC: 编译器
# CFLAGS: C编译器选项
# CPPFLAGS: C预处理器选项
# DEPFLAGS: .d文件编译选项
# MACROS: 编译宏，不需要带"-D"    TODO: 考虑带"-D"的保护

# LD: 链接器
# LDFLAGS: 链接器选项
# AR: 打包器
# ARFLAGS: 打包器选项
# AREN: 静态库既可以使用AR，也可以使用LD，所以增加该标记，为0则使用LD，为1则使用AR

# LIBS: 链接库，需要带库文件路径，不需要带"-l"或"-L"    TODO: 考虑带"-l/L"的保护

# RM: 删除文件命令

######################################## Target ###################################################
OUTPUT_PATH:=$(PWD)/output

TARGET_SUFFIX:=$(suffix $(TARGET))

ifeq ($(TARGET_SUFFIX),.o)
TARGET_PATH=$(OUTPUT_PATH)/lib
TARGET_TYPE:=STATIC_LIB
endif

ifeq ($(TARGET_SUFFIX),.so)
TARGET_PATH=$(OUTPUT_PATH)/lib
TARGET_TYPE:=DYNAMIC_LIB
endif

ifeq ($(TARGET_SUFFIX),.o)
TARGET_PATH=$(OUTPUT_PATH)/lib
TARGET_TYPE:=STATIC_LIB
endif

ifeq ($(TARGET_SUFFIX),.exe)
TARGET_PATH=$(OUTPUT_PATH)/exe
TARGET_TYPE:=EXECUTABLE
endif

TARGET:=$(TARGET_PATH)/$(TARGET)

INSTALL_PATH:=$(RELEASE_PATH)
INSTALL_TARGET:=$(INSTALL_PATH)/$(notdir $(TARGET))

ifeq ($(RELEASE_INCLUDE),)
RELEASE_INCLUDE:=$(RELEASE_PATH)
endif

######################################## Header Files #############################################
# .h files
# useless, because compilation uses "INCLUDES" but not "HEADERS"
#HEADERS:=$(shell find $(INCLUDE_PATH) -maxdepth 1 -name "*.h")

# include path used for compiler
INCLUDES:=$(foreach dir, $(INCLUDE_PATH), $(addprefix -I, $(dir)))

######################################## Source Files #############################################
# .c files

SOURCES:=$(SRC_FILE)

# "SRC_PATH" can only have top directories, or there will be duplicated filenames
#SOURCES:=$(shell find $(SRC_PATH) -name "*.c")  	
#SOURCES:=$(shell find $(SRC_PATH) -maxdepth 1 -name "*.c")
ifneq ($(SRC_PATH),)
SOURCES+=$(foreach dir, $(SRC_PATH), $(shell find $(SRC_PATH) -name "*.c" | sort | uniq))
endif

ifneq ($(SORT_EN),0)
SOURCES:=$(sort $(SOURCES))
endif

########################################## CODE ROOT ##############################################
SOURCE_PATH:=$(sort $(patsubst %/, %, $(dir $(SOURCES))))
SOURCE_PATH_NUM:=$(words $(SOURCE_PATH))
#SOURCE_PATH2:=$(sort $(patsubst %/, %, $(dir $(SOURCE_PATH))))
#COD_ROOT:=$(firstword $(SOURCE_PATH))
COD_ROOT:=$(CODE_ROOT)
SOURCE_PATH2:=$(findstring $(COD_ROOT),$(SOURCE_PATH))
#SOURCE_PATH2=$(words $(findstring $(COD_ROOT),$(SOURCE_PATH)))
#SOURCE_PATH2=$(shell while [ -n "$(filter-out $(COD_ROOT),$(SOURCE_PATH))" ]; do COD_ROOT=$(patsubst %/,%,$(dir $(COD_ROOT))); done; echo $(COD_ROOT))


######################################## Object Files #############################################
# object file path
OBJECT_PATH:=$(OUTPUT_PATH)/object
#$(shell if ! [ -d $(OBJECT_PATH) ]; then mkdir -p $(OBJECT_PATH); fi)

# .o files
OBJECTS:=
ifneq ($(SOURCES),)
#OBJECTS:=$(patsubst %.c,%.o,$(SOURCES))
#OBJECTS:=$(patsubst %.c,%.o,$(patsubst %.cpp,%.o,$(SOURCES)))
OBJECTS:=$(patsubst $(CODE_ROOT)%,$(OBJECT_PATH)%,$(patsubst %.c,%.o,$(SOURCES)))
endif

######################################## Depend Files #############################################
# depend file path
DEPEND_PATH:=$(OUTPUT_PATH)/depend

# .d files
DEPENDS:=
ifneq ($(SOURCES),)
#DEPENDS:=$(patsubst %.o,%.d,$(OBJECTS))
#DEPENDS:=$(OBJECTS:.o=.d)
DEPENDS:=$(patsubst $(CODE_ROOT)%,$(DEPEND_PATH)%,$(patsubst %.c,%.d,$(SOURCES)))
endif

######################################## OPTIONS ##################################################
ifeq ($(BUILD_TYPE),DEBUG)
CFLAGS+=-g
endif

ifeq ($(AREN),)
AREN:=0
endif

ifeq ($(DEPFLAGS),)
DEPFLAGS:=-MM
endif

D_MACRO:=$(foreach macro, $(MACROS), $(addprefix -D, $(macro)))
L_LIB:=$(foreach lib, $(dir $(LIBS)), $(addprefix -L, $(lib)))
L_LIB+=$(foreach lib, $(LIBS), $(addprefix -l, $(lib)))

######################################## TARGETS ##################################################
.PHONY: all deps objs clean veryclean rebuild install uninstall run test

all : $(TARGET)
	@echo '        SUCCESS!'
	@echo

deps : $(DEPENDS)

objs : $(OBJECTS)

clean :
	@$(RM) -fr $(OBJECT_PATH)
	@$(RM) -fr $(DEPEND_PATH)
	@$(RM) -fr $(TARGET_PATH)
	@echo
	@echo clean finished!
	@echo

veryclean : clean
	@$(RM) -fr $(OUTPUT_PATH)
	@echo
	@echo veryclean finished!
	@echo

rebuild : veryclean all

######################################## DEPEND RULES #############################################
define install_target
if ! [ -d $(INSTALL_PATH) ]; then mkdir -p $(INSTALL_PATH); fi; \
cp $(TARGET) $(INSTALL_TARGET)
endef

define install_include
if ! [ -d $(RELEASE_INCLUDE) ]; then mkdir -p $(RELEASE_INCLUDE); fi; \
if [ -n "$(RELEASE_HFILE)" ]; then cp $(RELEASE_HFILE) $(RELEASE_INCLUDE); fi; \
if [ -n "$(RELEASE_HPATH)" ]; then cp -r $(RELEASE_HPATH) $(RELEASE_INCLUDE); fi
endef

install:$(TARGET)
	@if [ -n "$(INSTALL_PATH)" ]; then \
		$(install_target); \
		$(install_include); \
		echo "Install target ...... success."; \
	else \
		echo "No need to install target because of NULL install path."; \
	fi;
	@echo
	@echo Install finished!
	@echo

uninstall: veryclean
	$(RM) -f $(INSTALL_TARGET)
	$(RM) -f $(RELEASE_INCLUDE)
	@echo
	@echo Uninstall finished!
	@echo
	
run : all
	@ if [ $(TARGET_TYPE) == "EXECUTABLE" ]; then \
		if [ -n "$(INSTALL_PATH)" ]; \
			then $(install_target); \
			$(INSTALL_TARGET); \
		else \
			$(TARGET); \
		fi \
	fi

######################################## PRINT VARIABLES ##########################################
test :
#	@echo "OUTPUT_PATH=$(OUTPUT_PATH)"
#	@echo
#	@echo "TARGET_SUFFIX=$(TARGET_SUFFIX)"
#	@echo
#	@echo "TARGET=$(TARGET)"
#	@echo
#	@echo "TARGET_TYPE=$(TARGET_TYPE)"
#	@echo
#	@echo "CODE_ROOT=$(CODE_ROOT)"
#	@echo
#	@echo "INCLUDE_PATH=$(INCLUDE_PATH)"
#	@echo
#	@echo "SRC_PATH=$(SRC_PATH)"
#	@echo
#	@echo "SRC_FILE=$(SRC_FILE)"
#	@echo
#	@echo "OBJECT_PATH=$(OBJECT_PATH)"
#	@echo
#	@echo "DEPEND_PATH=$(DEPEND_PATH)"
##	@echo
##	@echo "HEADERS=$(HEADERS)"
#	@echo
#	@echo "INCLUDES=$(INCLUDES)"
	@echo
	@echo "SOURCES=$(SOURCES)"
	@echo
	@echo "SOURCE_PATH=$(SOURCE_PATH)"
	@echo
	@echo "SOURCE_PATH_NUM=$(SOURCE_PATH_NUM)"
	@echo
	@echo "SOURCE_PATH2=$(SOURCE_PATH2)"
	@echo
#	@echo "OBJECTS=$(OBJECTS)"
#	@echo
#	@echo "DEPENDS=$(DEPENDS)"
#	@echo
#	@echo "CFLAGS=$(CFLAGS)"
#	@echo
#	@echo "DEPFLAGS=$(DEPFLAGS)"
#	@echo
#	@echo "MACROS=$(MACROS)"
#	@echo
#	@echo "D_MACRO=$(D_MACRO)"
#	@echo
#	@echo "LIBS=$(LIBS)"
#	@echo
#	@echo "L_LIB=$(L_LIB)"

######################################## DEPEND RULES #############################################
# -: omit result
#-include $(DEPENDS)

ifneq ($(MAKE_TYPE),clean)
ifneq ($(MAKE_TYPE),veryclean)
ifneq ($(MAKE_TYPE),uninstall)
ifneq ($(MAKE_TYPE),test)
-include $(DEPENDS)
endif
endif
endif
endif

define create_depend
echo "depend_filename $@"; \
echo "input_filename $<"; \
set -e; $(RM) -fv $@; \
$(CC) $(DEPFLAGS) $(CPPFLAGS) $(CFLAGS) $(D_MACRO) $(INCLUDES)   $<   > $@.$$$$; \
sed 's,\($(*F)\)\.o[ :]*,\1.o $@ : ,g'   < $@.$$$$   > $@; \
$(RM) -f $@.$$$$;
endef

$(DEPENDS) : $(DEPEND_PATH)/%.d : $(CODE_ROOT)/%.c
	@echo ---- $(@F) ----
	@ if ! [ -d $(DEPEND_PATH)/$(*D) ]; then mkdir -p $(DEPEND_PATH)/$(*D); fi
	@ $(create_depend)
#	@cat $(DEPEND_PATH)/$(*D)/$(@F)
	@echo 

######################################## OBJECT RULES #############################################
$(OBJECTS) : $(OBJECT_PATH)/%.o : $(CODE_ROOT)/%.c
	@echo ---- $(@F) ----
	@ if ! [ -d $(OBJECT_PATH)/$(*D) ]; then mkdir -p $(OBJECT_PATH)/$(*D); fi
	$(CC) $(CPPFLAGS) $(CFLAGS) $(D_MACRO) $(INCLUDES)   -c $<   -o $@ 
	@echo 

######################################## TARGET RULES #############################################
$(TARGET) : $(OBJECTS)
	@echo
	@echo ---- $(@F) ----
	@ if ! [ -d $(@D) ]; then mkdir -p $(@D); fi
	@ if [ $(TARGET_TYPE) == STATIC_LIB ]; \
		then \
			if [ $(AREN) -ne 0 ]; \
				then $(AR) $(ARFLAGS) $@ $^; \
			else \
				$(LD) $(LDFLAGS) $^ -o $@; \
			fi \
	elif [ $(TARGET_TYPE) == DYNAMIC_LIB ]; \
		then $(CC) $(CPPFLAGS) -shared -fPIC $(CFLAGS) $(D_MACRO) $(INCLUDES)    $^    $(LIBS)   -o $@; \
		echo build Executable success!; \
	elif [ $(TARGET_TYPE) == EXECUTABLE ]; \
		then $(CC) $(CPPFLAGS) $(CFLAGS) $(D_MACRO) $(INCLUDES)    $^    $(LIBS)   -o $@; \
		echo build Executable success!; \
	else \
		echo ERROR: unkown target type!; \
	fi
	@echo 

####################################### THE END ###################################################

