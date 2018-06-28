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

echo
echo
echo

