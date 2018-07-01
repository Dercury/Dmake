#!/bin/bash

export CODE_ROOT=$(cd $(dirname $BASH_SOURCE); pwd)
echo CODE_ROOT=$CODE_ROOT
echo

export BUILD_PATH=$CODE_ROOT

MAKE_TYPE=install
if [ -n "$1" ]; then
    MAKE_TYPE=$1
fi

../build_frame.sh --target real.o --make-type clean --src-file ./static_lib/real_src.mak --release-option ./static_lib/real_release.mak 
../build_frame.sh --target real.o --make-type $MAKE_TYPE --src-file ./static_lib/real_src.mak --release-option ./static_lib/real_release.mak 

../build_frame.sh --make-type clean --all-config ./dynamic_lib/share_all.mak 
../build_frame.sh --make-type $MAKE_TYPE --all-config ./dynamic_lib/share_all.mak 

../build_frame.sh --make-type clean --all-config ./static_lib/handle_all.mak 
../build_frame.sh --make-type $MAKE_TYPE --all-config ./static_lib/handle_all.mak 

../build_frame.sh --target main.exe --make-type clean --src-file ./executable/main_src.mak --include-path ./executable/main_include.mak --release-option ./executable/main_release.mak 
../build_frame.sh --target main.exe --make-type $MAKE_TYPE --src-file ./executable/main_src.mak --include-path ./executable/main_include.mak --release-option ./executable/main_release.mak 

