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
#if 0
    if (argc > 0)
    {
        a = atoi(argv[0]);
    }

    if (argc > 1)
    {
        b = atoi(argv[1]);
    }

    if (argc > 2)
    {
        flag = atoi(argv[2]);
    }
#endif
    printf("\r\n result = %d \r\n", handle(a, b, flag));

    return 0;
}


