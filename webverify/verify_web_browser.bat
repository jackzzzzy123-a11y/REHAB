@echo off
REM ============================================================
REM  RehabMed Web 离线重开手工验证脚本（Windows）
REM  用途：本地启动 build/web 静态服务并自动打开浏览器
REM  使用：双击本文件即可
REM ============================================================
chcp 65001 >nul
setlocal

REM 进入 build/web 所在目录（脚本同级）
cd /d "%~dp0build\web" 2>nul
if errorlevel 1 (
  echo [ERROR] 找不到 build\web 目录。请先在项目根目录跑：
  echo         flutter build web --release
  pause
  exit /b 1
)

REM 检查端口 8080 占用
set PORT=8080
netstat -ano | findstr ":%PORT% " >nul
if not errorlevel 1 (
  echo [WARN] 端口 %PORT% 已被占用，尝试 8081...
  set PORT=8081
  netstat -ano | findstr ":%PORT% " >nul
  if not errorlevel 1 (
    echo [ERROR] 8080/8081 都被占用，请关闭占用进程后重试。
    pause
    exit /b 1
  )
)

echo.
echo ============================================================
echo  RehabMed Web 离线重开验证
echo  静态服务端口：http://localhost:%PORT%/
echo  验证流程（按屏幕提示操作）：
echo    1. 医生登录（帳号 doc / 密碼 123456 / 勾选同意 / 登录）
echo    2. 顶栏右侧点「載入範例」（烧瓶图标）
echo    3. 确认 2 位患者出现在列表
echo    4. 完全关闭浏览器（整个 Edge/Chrome）
echo    5. 重新打开 http://localhost:%PORT%/
echo    6. 再次医生登录（同意 / 登录）
echo    7. 确认 2 位患者仍在 = 离线重开通过
echo ============================================================
echo.

REM 后台启动 python http.server
where python >nul 2>&1
if not errorlevel 1 (
  start "RehabMed Web Server" /min cmd /c "python -m http.server %PORT%"
) else (
  where py >nul 2>&1
  if not errorlevel 1 (
    start "RehabMed Web Server" /min cmd /c "py -m http.server %PORT%"
  ) else (
    echo [ERROR] 未检测到 python，请安装 Python 3 或改用其他静态服务器：
    echo         npx serve build\web -l %PORT%
    pause
    exit /b 1
  )
)

REM 等待服务器就绪
echo 等待服务就绪...
timeout /t 2 >nul

REM 自动打开默认浏览器
start http://localhost:%PORT%/

echo.
echo 服务已在后台运行（窗口已最小化）。完成后可关闭该窗口。
echo 关闭服务：在任务栏右键「RehabMed Web Server」窗口 → 关闭。
echo.
pause
