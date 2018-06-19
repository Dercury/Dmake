#!/bin/bash
 
#!/bin/bash
##功能描述：
#   构建配置
##外部依赖：
#   ${BUILD_PATH}: 构建路径

HELP=0

while [ -n "$1" ]
do
	case "$1" in
	--target) 
		TARGET="$2"
	    shift;;
	--src-file) 
		SRC_FILE="$2"
	    shift;;
	--include-path) 
		INCLUDE_PATH="$2"
	    shift;;
	--make-option) 
		MAKE_OPTION="$2"
	    shift;;
	--release-option) 
		RELEASE_OPTION="$2"
	    shift;;
	--all-config) 
		ALL_CONFIG="$2"
	    shift;;
	--ext-config) 
		EXT_CONFIG="$2"
	    shift;;
	--ext-make) 
		EXT_MAKE="$2"
	    shift;;
	--ext-release) 
		EXT_RELEASE="$2"
	    shift;;
	--help) 
		HELP=1;;
	*) 
		echo "Warning: $1 is not support.";;
	esac
	shift
done

echo
echo "-------------------- input config -----------------------"
echo TARGET=$TARGET
echo SRC_FILE=$SRC_FILE
echo INCLUDE_PATH=$INCLUDE_PATH
echo MAKE_OPTION=$MAKE_OPTION
echo RELEASE_OPTION=$RELEASE_OPTION
echo ALL_CONFIG=$ALL_CONFIG
echo EXT_CONFIG=$EXT_CONFIG
echo EXT_MAKE=$EXT_MAKE
echo EXT_RELEASE=$EXT_RELEASE
echo HELP=$HELP
echo


