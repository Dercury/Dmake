/*
 * =====================================================================================
 *
 *       Filename:  handle.c
 *
 *    Description:  静态库，内部动态加载动态库
 *
 *        Version:  1.0
 *        Created:  2018年06月30日 23时19分24秒
 *       Revision:  none
 *       Compiler:  gcc
 *
 *         Author:  Dercury (Jim), dercury@qq.com
 *   Organization:  Perfect World
 *
 * =====================================================================================
 */

#include <dlfcn.h>
#include <stdio.h>

int handle(int a, int b, int flag)
{
    int ret;
    char *error;
    int (*hfn)(int, int, int);
    void* hso = dlopen("./share.so", RTLD_LAZY);
    if (!hso)
    {
        fprintf(stderr, "%s\n", dlerror());
        exit(1);
    }

    hfn = dlsym(hso, "calc");
    if ((error = dlerror()) != NULL)
    {
        fprintf(stderr, "%s\n", error);
        exit(2);
    }

    ret = hfn(a, b, flag);

    if (dlclose(hso) < 0)
    {
        fprintf(stderr, "%s\n", dlerror());
        exit(3);
    }

    return ret;
}


