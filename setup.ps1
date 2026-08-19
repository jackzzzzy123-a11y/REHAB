# setup.ps1 - 一鍵初始化 RehabMedApp Flutter 開發環境 (Windows)
#
# 用法：
#   1. 將本檔案放在專案根目錄 (C:\Users\23919\Desktop\rehab)
#   2. 在 PowerShell 中執行：  .\setup.ps1
#   3. 若提示「未載入檔案因為禁止執行指令碼」，先執行：
#        Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
#      再重跑 .\setup.ps1
#
# 前置：Windows 10/11 + 網路連線 + 已安裝 Git (會自動檢查)
# 說明：本腳本繞開 FVM，直接安裝 Flutter 3.44.8，與 .fvmrc 版本一致。

$ErrorActionPreference = "Stop"

$FLUTTER_VERSION = "3.44.8"
$FLUTTER_ZIP     = "flutter_windows_$FLUTTER_VERSION-stable.zip"
$FLUTTER_URL     = "https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/$FLUTTER_ZIP"
$INSTALL_DIR     = "C:\src"
$FLUTTER_BIN     = "$INSTALL_DIR\flutter\bin"
$flutterExe      = Join-Path $FLUTTER_BIN "flutter.exe"

Write-Host "=== RehabMedApp Flutter 環境初始化 (v$FLUTTER_VERSION) ===" -ForegroundColor Cyan

# [1] 檢查 Git（Flutter 工具鏈需要）
Write-Host "[1/6] 檢查 Git ..." -ForegroundColor Yellow
try {
  $gitVer = (git --version 2>&1)
  if ($gitVer -match "git version") {
    Write-Host "  OK: $gitVer" -ForegroundColor Green
  } else { throw }
} catch {
  Write-Host "  [錯誤] 未偵測到 Git。" -ForegroundColor Red
  Write-Host "  請先安裝 Git for Windows: https://git-scm.com/download/win" -ForegroundColor Red
  Write-Host "  安裝時務必勾選 'Add Git to PATH'，裝完重開 PowerShell 再執行本腳本。" -ForegroundColor Red
  exit 1
}

# [2] 下載 Flutter (若尚未安裝)
if (Test-Path $flutterExe) {
  Write-Host "[2/6] 已偵測到 Flutter 於 $FLUTTER_BIN，略過下載。" -ForegroundColor Green
} else {
  Write-Host "[2/6] 下載 Flutter $FLUTTER_VERSION (約 1GB，請耐心等候) ..." -ForegroundColor Yellow
  $zipPath = Join-Path $env:TEMP $FLUTTER_ZIP
  if (-not (Test-Path $zipPath)) {
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest -Uri $FLUTTER_URL -OutFile $zipPath -UseBasicParsing
  }
  Write-Host "[3/6] 解壓到 $INSTALL_DIR ..." -ForegroundColor Yellow
  if (-not (Test-Path $INSTALL_DIR)) { New-Item -ItemType Directory -Path $INSTALL_DIR | Out-Null }
  Expand-Archive -Path $zipPath -DestinationPath $INSTALL_DIR -Force
}

# [4] 永久加入使用者 PATH
Write-Host "[4/6] 將 Flutter 加入 PATH ..." -ForegroundColor Yellow
$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($userPath -notlike "*$FLUTTER_BIN*") {
  [Environment]::SetEnvironmentVariable("Path", ($userPath + ";" + $FLUTTER_BIN), "User")
  Write-Host "  已加入 PATH（使用者層級）。後續新開的 PowerShell 視窗即生效。" -ForegroundColor Green
} else {
  Write-Host "  PATH 已含 Flutter，略過。" -ForegroundColor Green
}

# [5] 以完整路徑驗證版本（不依賴 PATH）
Write-Host "[5/6] 驗證 Flutter 版本 ..." -ForegroundColor Yellow
& $flutterExe --version
if ($LASTEXITCODE -ne 0) {
  Write-Host "  [提示] 上方若報錯，請關閉 PowerShell 重開後手動執行 flutter --version 確認。" -ForegroundColor Red
}

# [6] 在專案目錄執行依賴與程式碼生成
Write-Host "[6/6] 於專案目錄執行 pub get / build_runner / analyze ..." -ForegroundColor Yellow
$projectDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $projectDir
& $flutterExe pub get
& $flutterExe pub run build_runner build --delete-conflicting-outputs
& $flutterExe analyze

Write-Host "=== 初始化完成 ===" -ForegroundColor Green
Write-Host "若 analyze 僅報 unused_import / unused_element 等警告 (目前為占位骨架)，屬正常，可忽略。" -ForegroundColor Gray
Write-Host "後續在專案目錄直接用 'flutter' 指令即可 (例如 flutter run)。" -ForegroundColor Gray
