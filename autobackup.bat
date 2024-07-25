@echo off
setlocal enabledelayedexpansion

:: Bandizip的安装路径
set "BZ_PATH=C:\Program Files\Bandizip"
:: Bandizip的命令行工具名称，根据实际情况调整
set "BZ_EXE=bz"

:: 设置要压缩的文件夹列表和备份目录
set "FOLDERS=world world_nether world_the_end plugins"
set "BACKUP_DIR=backup"
:start
:: 检查并创建备份目录
if not exist "%BACKUP_DIR%" (
    mkdir "%BACKUP_DIR%"
)

:: 获取当前日期和时间
for /f "tokens=2 delims==" %%a in ('wmic os get localdatetime /value') do set datetime=%%a
:: 格式化日期时间字符串
set "ZIP_NAME=backup_!datetime:~6,4!!datetime:~0,2!!datetime:~2,2!!datetime:~4,2!!datetime:~6,2!!datetime:~8,2!.zip"

:: 完整的zip文件路径
set "ZIP_PATH=%BACKUP_DIR%\!ZIP_NAME!"

:: 显示当前操作
echo Creating backup of the following folders: %FOLDERS%
echo Backup will be saved to: !ZIP_PATH!

:: 使用Bandizip创建zip文件，确保每个文件夹路径都被正确引用
for %%f in (%FOLDERS%) do (
    set "folder_path=%%f"
    if exist "!folder_path!" (
        echo Adding !folder_path! to the archive...
        "%BZ_PATH%\!BZ_EXE!" a -r -o:"!BACKUP_DIR!" "!ZIP_PATH!" "!folder_path!"
        if !errorlevel! neq 0 (
            echo Error adding !folder_path! to the archive.
        ) else (
            echo !folder_path! added successfully.
        )
    ) else (
        echo Folder !folder_path! does not exist, skipping...
    )
)

echo Backup created successfully: !ZIP_PATH!
echo Waiting for 30 minutes before the next backup...
timeout /t 1800 /nobreak

:: 跳转回脚本开始处继续执行
goto start