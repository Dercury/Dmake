/*
 * =====================================================================================
 *
 *       Filename:  real.c
 *
 *    Description:  计算
 *
 *        Version:  1.0
 *        Created:  2018年06月30日 22时49分21秒
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Dercury (Jim), dercury@qq.com
 *   Organization:  Perfect World
 *
 * =====================================================================================
 */

int add(int a, int b)
{
    printf("\r\n%s(%d, %d)\r\n", __func__, a, b);
    return a + b;
}

int sub(int a, int b)
{
    printf("\r\n%s(%d, %d)\r\n", __func__, a, b);
    return a - b;
}

