# Dmake
通用C语言编译脚本

通常的编译流程包括三个步骤或阶段：配置编译环境、执行编译、发布编译结果。

1.配置编译环境：包括编译目标、待编译的源文件、需包含的头文件、编译工具链、编译选项等等。在此，编译环境配置是由configure.sh完成的。

(1)编译目标：必须输入项，编译将要生成的结果文件，支持静态库（以.a或.o为后缀）、动态库（以.so为后缀）和可执行文件（以.exe为后缀或无后缀）三种格式。在此，通过参数--target指定。
如果没有输入该选项，则报错退出。

(2)源文件：必须输入项，待编译的源文件列表，支持源文件列表（以SRC_FILES变量指定）和源文件路径列表（以SRC_PATHS变量指定）两种方式。在此，通过参数--src-files指定，要求参数为.mak文件，其内以SRC_FILES变量指定待编译的源文件列表，以SRC_PATHS变量指定待编译的源文件所在的路径列表。
如果没有输入该选项，则报错退出。

(3)头文件：可选输入项，编译时包含的头文件路径列表（以INCLUDE_PATHS变量指定）。在此，通过参数--include-paths指定，要求参数为.mak文件，其内以INCLUDE_PATHS变量指定编译包含的头文件所在的路径列表。
如果没有输入该选项，则以源文件所在路径列表为头文件路径列表。

(4)编译工具选项：可选输入项，编译时使用的编译器、链接器等工具及其选项。在此，通过参数--make-options指定，要求参数为.mak文件，其内以GCC,LD,AR等变量指定编译使用的工具，以CFLAGS等变量指定编译选项。
如果没有输入该选项，则使用linux默认编译工具链及相关选项。

(5)发布选项：可选输入项，需要发布的编译结果及发布使用的路径。在此，通过参数--release-options指定，要求参数为.mak文件，其内以RELEASE_PATH变量指定库文件或可执行文件的安装路径，以RELEASE_HFILES变量指定需发布的头文件列表，以RELEASE_HPATHS变量指定需发布的头文件路径列表，以RELEASE_INCLUDE变量指定头文件的安装路径。
如果没有输入该选项，则不发布。

(6)汇总输入：由于以上输入都是以.mak文件为输入参数，所以增加参数--all-mak支持输入一个汇总的.mak文件。

除了以上编译配置项之外，为了使用户能够更方便灵活的执行一些额外处理动作，增加了以下可选的输入参数：

(7)额外配置：可选输入项，通过参数--ext-cfg指定一个.sh脚本，在配置编译环境阶段最后执行，即configure.sh脚本最后调用输入的.sh脚本；
如果没有输入该选项，则不执行。

(8)额外编译：可选输入项，通过参数--ext-make指定一个.sh脚本，在执行编译阶段最后执行，即do_make.sh脚本最后调用输入的.sh脚本；
如果没有输入该选项，则不执行。

(9)额外发布：可选输入项，通过参数--ext-release指定一个.sh脚本，在发布编译结果阶段最后执行，即release.sh脚本最后调用输入的.sh脚本。
如果没有输入该选项，则不执行。

configure.sh需要完成的工作包括：
(a).解析输入参数；
(b).检查是否缺少必须输入项；
(c).补齐缺少的可选输入项；
(d).判断编译目标的类型；
(e).调用额外配置脚本；


2.执行编译：根据输入参数执行编译。在此，由do_make.sh完成，其需要完成的工作包括：

(a).根据编译目标类型进行编译；

(b).调用额外编译脚本；


3.发布编译结果：完成搜集发布件（库文件及其头文件）、安装发布件等工作。在此，由release.sh完成，其需要完成的工作包括：

(a).根据编译目标类型进行发布；

(b).调用额外发布脚本；


test目录：测试dmake脚本的demo工程


