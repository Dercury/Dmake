#!/bin/bash
##功能描述：
#   构建配置
##外部依赖：
#   ${BUILD_PATH}: 构建路径

function PrintHelp
{
    echo  "Please refer to README."
    exit $1
}

echo
echo "-------------------- input config -----------------------"

while [ -n "$1" ]
do
    case "$1" in
    --target) 
        TARGET="$2"
        echo TARGET=$TARGET
        shift;;
    --src-file) 
        SRC_FILE="$2"
        echo SRC_FILE=$SRC_FILE
        shift;;
    --include-path) 
        INCLUDE_PATH="$2"
        echo INCLUDE_PATH=$INCLUDE_PATH
        shift;;
    --make-option) 
        MAKE_OPTION="$2"
        echo MAKE_OPTION=$MAKE_OPTION
        shift;;
    --release-option) 
        RELEASE_OPTION="$2"
        echo RELEASE_OPTION=$RELEASE_OPTION
        shift;;
    --all-config) 
        ALL_CONFIG="$2"
        echo ALL_CONFIG=$ALL_CONFIG
        shift;;
    --ext-config) 
        EXT_CONFIG="$2"
        echo EXT_CONFIG=$EXT_CONFIG
        shift;;
    --ext-make) 
        EXT_MAKE="$2"
        echo EXT_MAKE=$EXT_MAKE
        shift;;
    --ext-release) 
        EXT_RELEASE="$2"
        echo EXT_RELEASE=$EXT_RELEASE
        shift;;
    --help) 
        PrintHelp 0;;
    *) 
        echo "Warning: $1 is not support.";;
    esac
    shift
done

echo

if [ $ALL_CONFIG ]; then
    # 使用统一mak脚本
    echo 1
elif [[ $TARGET && $SRC_FILE ]]; then
    # 使用分散mak脚本
    echo 2
else
    PrintHelp 1
fi
