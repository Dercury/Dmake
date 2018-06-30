#!/bin/bash

pattern=$1
variable=$2

if [[ -z $pattern || -z $variable ]]; then
    echo "input not enough"
    exit 1
fi

if [ ${pattern:0:1} != ${variable:0:1} ]; then
    echo "no common path"
    exit 2
fi

if [ ${#pattern} -gt ${#variable} ]; then
    temp=$pattern; pattern=$variable; variable=$temp;
fi

temp=${variable##$pattern}
while [ "$temp" == "$variable" ]
do
    pattern=${pattern%/*}
    temp=${variable##$pattern}
done

echo $pattern

