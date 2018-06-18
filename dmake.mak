
######################################## Target ###################################################
OUTPUT_PATH:=$(PWD)/output

TARGET_SUFFIX:=$(suffix $(TARGET))
ifeq ($(TARGET_SUFFIX),.a)
TARGET_PATH=$(OUTPUT_PATH)/lib
TARGET_TYPE:=STATIC_LIB
else
ifeq ($(TARGET_SUFFIX),.so)
TARGET_PATH=$(OUTPUT_PATH)/lib
TARGET_TYPE:=DYNAMIC_LIB
else
ifeq ($(TARGET_SUFFIX),)
TARGET_PATH=$(OUTPUT_PATH)/exe
TARGET_TYPE:=EXECUTABLE
endif
endif
endif
TARGET:=$(TARGET_PATH)/$(TARGET)

INSTALL_TARGET:=$(INSTALL_PATH)/$(notdir $(TARGET))

######################################## Header Files #############################################
# .h files
# useless, because compilation uses "INCLUDES" but not "HEADERS"
#HEADERS:=$(shell find $(HEADER_PATH) -maxdepth 1 -name "*.h")

# include path used for compiler
INCLUDES:=$(foreach dir, $(HEADER_PATH), $(addprefix -I, $(dir)))

######################################## Source Files #############################################
# .c files
# "SOURCE_PATH" can only have top directories, or there will be duplicated filenames
#SOURCES:=$(shell find $(SOURCE_PATH) -name "*.c")  	
#SOURCES:=$(shell find $(SOURCE_PATH) -maxdepth 1 -name "*.c")
SOURCES:=$(shell find $(SOURCE_PATH) -name "*.c" | sort | uniq)

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
	@$(RM-F) -r $(OBJECT_PATH)
	@$(RM-F) -r $(DEPEND_PATH)
	@echo
	@echo clean finished!
	@echo

veryclean : clean
	@$(RM-F) -r $(TARGET_PATH)
	@$(RM-F) -r $(OUTPUT_PATH)
	@echo
	@echo veryclean finished!
	@echo

rebuild : veryclean all

######################################## DEPEND RULES #############################################
define install_target
if ! [ -d $(INSTALL_PATH) ]; then mkdir -p $(INSTALL_PATH); fi; \
@cp $(TARGET) $(INSTALL_TARGET)
endef

install:$(TARGET)
	$(install_target)
	@echo
	@echo Install finished!
	@echo

uninstall:
	$(RM-F) $(INSTALL_TARGET)
	@echo
	@echo Uninstall finished!
	@echo
	
run : all
	@ if [ $(TARGET_TYPE) == "EXECUTABLE" ]; then \
		if [ $(INSTALL_PATH) ]; \
			then $(install_target); $(INSTALL_TARGET); \
		else \
			$(TARGET); \
		fi \
	fi

######################################## PRINT VARIABLES ##########################################
test :
	@echo "TARGET_SUFFIX=$(TARGET_SUFFIX)"
	@echo
	@echo "TARGET=$(TARGET)"
	@echo
	@echo "CODE_ROOT=$(CODE_ROOT)"
	@echo
	@echo "HEADER_PATH=$(HEADER_PATH)"
	@echo
	@echo "SOURCE_PATH=$(SOURCE_PATH)"
	@echo
	@echo "OBJECT_PATH=$(OBJECT_PATH)"
	@echo
	@echo "DEPEND_PATH=$(DEPEND_PATH)"
#	@echo
#	@echo "HEADERS=$(HEADERS)"
	@echo
	@echo "INCLUDES=$(INCLUDES)"
	@echo
	@echo "SOURCES=$(SOURCES)"
	@echo
	@echo "OBJECTS=$(OBJECTS)"
	@echo
	@echo "DEPENDS=$(DEPENDS)"
	@echo
	@echo "CFLAGS=$(CFLAGS)"
	@echo
	@echo "MACROS=$(MACROS)"
	@echo
	@echo "D_MACRO=$(D_MACRO)"
	@echo
	@echo "LIBS=$(LIBS)"
	@echo
	@echo "L_LIB=$(L_LIB)"

######################################## DEPEND RULES #############################################
-include $(DEPENDS)   # -: omit result
#sed 's,\($(*F)\)\.o[ :]*,\1.o $(@F) : ,g'   < $@.$$$$   > $@; \

define create_depend
set -e; rm -fv $@; \
$(CC) -MM $(CPPFLAGS) $(CFLAGS) $(D_MACRO) $(INCLUDES)   $<   > $@.$$$$; \
sed 's,\($(*F)\)\.o[ :]*,\1.o $@ : ,g'   < $@.$$$$   > $@; \
rm -f $@.$$$$
endef

$(DEPENDS) : $(DEPEND_PATH)/%.d : $(CODE_ROOT)/%.c
	@echo ---- $(@F) ----
	@ if ! [ -d $(DEPEND_PATH)/$(*D) ]; then mkdir -p $(DEPEND_PATH)/$(*D); fi
	@ $(create_depend)
	@cat $(DEPEND_PATH)/$(*D)/$(@F)
	@echo 

######################################## OBJECT RULES #############################################
$(OBJECTS) : $(OBJECT_PATH)/%.o : $(CODE_ROOT)/%.c
	@echo ---- $(@F) ----
	@ if ! [ -d $(OBJECT_PATH)/$(*D) ]; then mkdir -p $(OBJECT_PATH)/$(*D); fi
	$(CC) $(CPPFLAGS) $(CFLAGS) $(D_MACRO) $(INCLUDES)   -c $<   -o $@ 
	@echo 

######################################## TARGET RULES #############################################
$(TARGET) : $(OBJECTS)
	@echo ---- $(@F) ----
	@ if ! [ -d $(@D) ]; then mkdir -p $(@D); fi
	@ if [ $(TARGET_TYPE) == STATIC_LIB ]; \
		then $(AR) $@ $^; \
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

