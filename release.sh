#!/bin/bash
##功能描述：
#   发布版本
##外部依赖：
#   $BUILD_PATH: 构建路径

#if [[ $MAKE_TYPE == "install" || $MAKE_TYPE == "uninstall" || $MAKE_TYPE == "run" ]]; then
#    make $MAKE_TYPE -f $MAKEFILE -j8  2>&1 | tee -a $LOGFILE
#fi

echo
rm -f $MAKEFILE
echo

# 调用额外配置脚本
if [ -n "$EXT_RELEASE_SH" ]; then
    echo "Execute $BUILD_PATH/$EXT_RELEASE_SH ...... start"
    source $BUILD_PATH/$EXT_RELEASE_SH
    echo "Execute $BUILD_PATH/$EXT_RELEASE_SH ...... done"
fi

