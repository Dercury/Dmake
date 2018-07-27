#!/bin/bash
##功能描述：
#   执行编译
##外部依赖：
#   $BUILD_PATH: 构建路径

# 显示编译脚本
echo -------- makefile --------
cat $MAKEFILE
echo

# 执行编译脚本
if [[ "$MAKE_TYPE" == "rebuild" || "$MAKE_TYPE" == "veryclean" ]]; then
    rm -f $BUILD_PATH/MakeLog_*.log
fi

if [ "$MAKE_TYPE" == "rebuild" ]; then
    #直接使用Makefile里面的rebuild不能够使用-j*并行选项
    make veryclean -f $MAKEFILE -j8  2>&1 | tee -a $LOGFILE
    make -f $MAKEFILE -j8  2>&1 | tee -a $LOGFILE
else
    make $MAKE_TYPE -f $MAKEFILE -j8  2>&1 | tee -a $LOGFILE
fi

# 判断是否有编译错误
MAKE_ERROR_NUM=`grep ' error:' ${LOGFILE} | wc -l`
if (($MAKE_ERROR_NUM));then
    echo
    echo "++++++++++++++++++++ [$MAKE_ERROR_NUM] ERROR(S) OCCURED +++++++++++++++++++++++"
    grep ' error:' ${LOGFILE}
    echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
    echo
    exit $MAKE_ERROR_NUM
fi

if [[ $MAKE_TYPE != "clean" && $MAKE_TYPE != "veryclean" && $MAKE_TYPE != "uninstall" ]]; then
    find ./output/depend/ -name '*.d' -exec grep ' *\.h' {} \; | sed 's/ \\//' | sort | uniq > $HEADER_LIST
fi

if ! (($KEEP_MAKE_LOG)); then
    rm -f ${LOGFILE}
fi

# 调用额外配置脚本
if [ -n "$EXT_MAKE_SH" ]; then
    echo "Execute $BUILD_PATH/$EXT_MAKE_SH ...... start"
    source $BUILD_PATH/$EXT_MAKE_SH
    echo "Execute $BUILD_PATH/$EXT_MAKE_SH ...... done"
fi

