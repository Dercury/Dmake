#!/bin/bash
##功能描述：
#   构建框架
##外部依赖：
#   $BUILD_PATH: 构建路径

# dirname返回的是非标准化路径，故需要通过cd+pwd的方式来进一步获取标准路径
# 在调用脚本中直接使用时，$0与$BASH_SOURCE没有区别；但在被调用脚本souce时，$0给出的是调用脚本路径，而$BASH_SOUCE给出的被souce脚本路径。
export DO_MAKE_PATH=$(cd $(dirname $BASH_SOURCE); pwd)
echo DO_MAKE_PATH=$DO_MAKE_PATH
echo

# 检查外部依赖的构建路径
if [ -z "$BUILD_PATH" ]; then
    echo "Error: BUILD_PATH is NOT specified."
    exit 1
else
    echo "Using BUILD_PATH=$BUILD_PATH"
fi

# 构建配置
source $DO_MAKE_PATH/configure.sh
if (( $? )); then
    echo "Configure ...... Failed."
    exit $?
else
    echo "Configure ...... Successed."
fi

# 执行编译
# 这里必须用source，否则configure.sh中定义的变量传递不出来
source $DO_MAKE_PATH/do_make.sh
if (( $? )); then
    echo "Make ...... Failed."
    exit $?
else
    echo "Make ...... Successed."
fi

# 发布版本
# 这里必须用source，否则configure.sh中定义的变量传递不出来
source $DO_MAKE_PATH/release.sh
if (( $? )); then
    echo "Release ...... Failed."
    exit $?
else
    echo "Release ...... Successed."
fi









#!/bin/bash
##功能描述：
#   构建配置
##外部依赖：
#   $BUILD_PATH: 构建路径

function PrintHelp
{
    echo  "Please refer to README."
    echo Errcode: $1
    exit $1
}

# 解析输入参数
while [ -n "$1" ]
do
    case "$1" in
    --target) 
        TARGET="$2"
        shift;;
    --make-type)
        export MAKE_TYPE="$2"
        shift;;
    --src-file) 
        SRC_FILE_MAK="$2"
        shift;;
    --include-path) 
        INCLUDE_PATH_MAK="$2"
        shift;;
    --make-option) 
        MAKE_OPTION_MAK="$2"
        shift;;
    --release-option) 
        RELEASE_OPTION_MAK="$2"
        shift;;
    --all-config) 
        ALL_CONFIG_MAK="$2"
        shift;;
    --ext-config) 
        EXT_CONFIG_SH="$2"
        shift;;
    --ext-make) 
        export EXT_MAKE_SH="$2"
        shift;;
    --ext-release) 
        export EXT_RELEASE_SH="$2"
        shift;;
    --help) 
        PrintHelp 0;;
    *) 
        echo "Warning: $1 is not support.";;
    esac
    shift
done

echo
echo "-------------------- input config -----------------------"
echo TARGET=$TARGET
echo MAKE_TYPE=$MAKE_TYPE
echo SRC_FILE_MAK=$SRC_FILE_MAK
echo INCLUDE_PATH_MAK=$INCLUDE_PATH_MAK
echo MAKE_OPTION_MAK=$MAKE_OPTION_MAK
echo RELEASE_OPTION_MAK=$RELEASE_OPTION_MAK
echo ALL_CONFIG_MAK=$ALL_CONFIG_MAK
echo EXT_CONFIG_SH=$EXT_CONFIG_SH
echo EXT_MAKE_SH=$EXT_MAKE_SH
echo EXT_RELEASE_SH=$EXT_RELEASE_SH
echo

# 检查是否缺少必须输入项
# 补齐缺少的可选输入项
# 生成Makefile
export DATE_STR=`date +%F_%H-%M-%S`

export LOGFILE="$BUILD_PATH/MakeLog_$DATE_STR.log"
echo LOGFILE=$LOGFILE

export MAKEFILE="$BUILD_PATH/Makefile_$DATE_STR"
echo MAKEFILE=$MAKEFILE

if [ -n "$ALL_CONFIG_MAK" ]; then
    # 使用统一mak脚本
    echo "include $ALL_CONFIG_MAK" >> $MAKEFILE
    echo "include $DO_MAKE_PATH/do_make.mak" >> $MAKEFILE
elif [[ -n "$TARGET" && -n "$SRC_FILE_MAK" ]]; then
    # 使用分散mak脚本
    echo "TARGET:=$TARGET" >> $MAKEFILE
    echo "include $SRC_FILE_MAK" >> $MAKEFILE

    if [ -z "$INCLUDE_PATH_MAK" ]; then
        echo "Info: INCLUDE_PATH_MAK is NOT specified, so SRC_PATH will be used."
    else
        echo "include $INCLUDE_PATH_MAK" >> $MAKEFILE
    fi

    if [ -z "$MAKE_OPTION_MAK" ]; then
        echo "include $DO_MAKE_PATH/default_make_option.mak" >> $MAKEFILE
    else
        echo "include $MAKE_OPTION_MAK" >> $MAKEFILE
    fi

    if [ -n "$RELEASE_OPTION_MAK" ]; then
        echo "include $RELEASE_OPTION_MAK" >> $MAKEFILE
    fi

    echo "include $DO_MAKE_PATH/do_make.mak" >> $MAKEFILE
else
    # 缺少必须输入项
    echo "Not all needed items are specified."
    PrintHelp 2
fi

# 调用额外配置脚本
if [ -n "$EXT_CONFIG_SH" ]; then
    echo
    echo "Execute $BUILD_PATH/$EXT_CONFIG_SH ...... start"
    source $BUILD_PATH/$EXT_CONFIG_SH
    echo "Execute $BUILD_PATH/$EXT_CONFIG_SH ...... done"
    echo
fi

