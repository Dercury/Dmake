/*
 * =====================================================================================
 *
 *       Filename:  share.c
 *
 *    Description:  动态库
 *
 *        Version:  1.0
 *        Created:  2018年06月30日 23时00分14秒
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Dercury (Jim), dercury@qq.com
 *   Organization:  Perfect World
 *
 * =====================================================================================
 */

#include "real.h"

int calc(int a, int b, int flag)
{
    if (flag)
    {
        return add(a, b);
    }
    else
    {
        return sub(a, b);
    }
}


