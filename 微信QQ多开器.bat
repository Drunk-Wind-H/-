@echo off
setlocal enabledelayedexpansion

:: 设置路径变量(用户需要进行修改,右键桌面快捷方式->属性->目标,复制地址);
set wechat_path=D:\Tencent\WeChat\WeChat.exe
set qq_path=D:\Tencent\QQNT\QQ.exe

:MENU
cls
echo =====================================
echo  QQ/微信多开启动器
echo =====================================
echo.
echo  1. 打开 QQ
echo  2. 打开 微信
echo  3. 打开 QQ 和 微信
echo  4. 退出
echo.

:: 提示用户选择操作
set choice=
set /p "choice=请选择操作 [1-4]: "

:: 根据用户选择跳转到相应的标签
if "%choice%"=="4" goto :EXIT_SCRIPT
if "%choice%"=="3" goto :OPEN_BOTH
if "%choice%"=="2" goto :OPEN_WECHAT
if "%choice%"=="1" goto :OPEN_QQ

:: 如果输入无效，显示错误信息并返回菜单
echo 错误: 无效的选择。请重新选择。
pause

goto MENU
:OPEN_QQ
    :: 初始化QQ数量变量
    set "num_qq="
    :: 调用函数获取QQ的数量
    call :GET_COUNT "QQ" num_qq
    :: 检查获取的数量是否大于0
    if !num_qq! gtr 0 (
        echo 准备打开 !num_qq! 个QQ...
        :: 调用函数启动指定数量的QQ
        call :LAUNCH_APP "!qq_path!" !num_qq! "QQ"
    ) else (
        echo 已取消打开QQ或数量为0。
    )
    pause
    goto MENU

:OPEN_WECHAT
    :: 初始化微信数量变量
    set "num_wechat="
    :: 调用函数获取微信的数量
    call :GET_COUNT "微信" num_wechat
    :: 检查获取的数量是否大于0
    if !num_wechat! gtr 0 (
        echo 准备打开 !num_wechat! 个微信...
        :: 调用函数启动指定数量的微信
        call :LAUNCH_APP "!wechat_path!" !num_wechat! "微信"
    ) else (
        echo 已取消打开微信或数量为0。
    )
    pause
    goto MENU

:OPEN_BOTH
    :: 初始化QQ和微信的数量变量
    set "num_qq_both=0"
    set "num_wechat_both=0"

    echo --- 设置QQ数量 ---
    :: 调用函数获取QQ的数量
    call :GET_COUNT "QQ" num_qq_both

    echo.
    echo --- 设置微信数量 ---
    :: 调用函数获取微信的数量
    call :GET_COUNT "微信" num_wechat_both

    :: 检查QQ数量是否大于0
    if !num_qq_both! gtr 0 (
        echo 准备打开 !num_qq_both! 个QQ...
        :: 调用函数启动指定数量的QQ
        call :LAUNCH_APP "!qq_path!" !num_qq_both! "QQ"
    ) else (
        echo QQ数量为0，跳过打开QQ。
    )

    :: 检查微信数量是否大于0
    if !num_wechat_both! gtr 0 (
        echo 准备打开 !num_wechat_both! 个微信...
        :: 调用函数启动指定数量的微信
        call :LAUNCH_APP "!wechat_path!" !num_wechat_both! "微信"
    ) else (
        echo 微信数量为0，跳过打开微信。
    )
    pause
    goto MENU

:GET_COUNT
    :: %1 = App Name (e.g., "QQ")
    :: %2 = Variable name to store count (e.g., "num_qq")
    set "count_input="
    :: 提示用户输入要打开的应用程序数量
    set /p "count_input=请输入要打开的 %~1 数量 (输入0则不打开, 直接回车返回主菜单): "

    :: 如果用户直接回车，设置数量为0并返回
    if "!count_input!"=="" (
        set %~2=0
        echo 已取消 %~1 的数量设置。
        goto :EOF
    )

    :: 检查输入是否为非负整数
    set "is_num=1"
    for /f "delims=0123456789" %%i in ("%count_input%") do set is_num=0
    if "!is_num!"=="0" (
        echo 无效输入 "!count_input!"，请输入一个非负整数。
        goto :GET_COUNT ' 让用户重新输入
    )

    :: 将输入转换为数字并存储在变量中
    set /a %~2=%count_input%
    goto :EOF

:LAUNCH_APP
    :: %1 = App Path
    :: %2 = Count
    :: %3 = App Nickname
    for /L %%i in (1,1,%~2) do (
        echo 正在启动第 %%i 个 %~3...
        :: 启动应用程序
        start "" "%~1"
        :: 稍微延迟一下，避免同时启动过多导致系统卡顿
        timeout /t 1 /nobreak >nul
    )
    echo %~2 个 %~3 已全部尝试启动。
    goto :EOF

:EXIT_SCRIPT
cls
echo 脚本已退出。
timeout /t 1 >nul
exit /b



