/*
 * =====================================================================================
 *
 *       Filename:  main.c
 *
 *    Description:  可执行文件
 *
 *        Version:  1.0
 *        Created:  2018年06月30日 23时34分06秒
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Dercury (Jim), dercury@qq.com
 *   Organization:  Perfect World
 *
 * =====================================================================================
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "handle.h"

int main(int argc, char **argv)
{
    int a = 5;
    int b = 7;
    int flag = 2;
    int result = 0;

    if (argc > 1)
    {
        a = atoi(argv[1]);
    }

    if (argc > 2)
    {
        b = atoi(argv[2]);
    }

    if (argc > 3)
    {
        flag = atoi(argv[3]);
    }

    printf("\r\n a=%d, b=%d, flag=%d\r\n", a, b, flag);
    result = handle(a, b, flag);
    printf("\r\n result = %d \r\n", result);

    return 0;
}

