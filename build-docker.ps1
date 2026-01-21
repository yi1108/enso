#!/usr/bin/env pwsh
# Enso Docker 一键构建脚本
# 使用 Docker 容器构建 Enso，避免本地环境配置

$ErrorActionPreference = "Stop"

Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║     玉皇大帝·数据分析平台 - Docker 构建脚本              ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# 检查 Docker
Write-Host "[1/4] 检查 Docker 环境..." -ForegroundColor Yellow
try {
    $dockerVersion = docker version --format "{{.Server.Version}}" 2>$null
    if (-not $dockerVersion) {
        throw "Docker 未运行"
    }
    Write-Host "      ✓ Docker 版本: $dockerVersion" -ForegroundColor Green
} catch {
    Write-Error "错误: Docker 未运行，请启动 Docker Desktop"
    Write-Host "  提示: 安装 Docker Desktop for Windows 并启动" -ForegroundColor Cyan
    exit 1
}

# 检查项目目录
Write-Host "[2/4] 检查项目目录..." -ForegroundColor Yellow
if (-not (Test-Path "package.json")) {
    Write-Error "错误: 请在项目根目录运行此脚本"
    exit 1
}
Write-Host "      ✓ 项目目录: $PWD" -ForegroundColor Green

# 构建 Docker 镜像
Write-Host "[3/4] 构建 Docker 镜像..." -ForegroundColor Yellow
Write-Host "      (首次构建可能需要 10-20 分钟)" -ForegroundColor Cyan
Write-Host ""

$imageTag = "enso-builder"
$dockerBuildCmd = "docker build -t $imageTag -f Dockerfile.build . --progress=plain"

Write-Host "执行: $dockerBuildCmd" -ForegroundColor DarkGray
$buildResult = Invoke-Expression $dockerBuildCmd
if ($LASTEXITCODE -ne 0) {
    Write-Error "Docker 镜像构建失败"
    Write-Host "请检查:" -ForegroundColor Yellow
    Write-Host "  1. Docker Desktop 是否正在运行" -ForegroundColor Cyan
    Write-Host "  2. 磁盘空间是否充足（至少 20GB）" -ForegroundColor Cyan
    Write-Host "  3. 网络连接是否正常" -ForegroundColor Cyan
    exit 1
}

Write-Host ""
Write-Host "      ✓ 镜像构建成功" -ForegroundColor Green

# 运行构建
Write-Host "[4/4] 在容器中构建项目..." -ForegroundColor Yellow
Write-Host "      (这可能需要 30-60 分钟)" -ForegroundColor Cyan
Write-Host ""

$buildCmd = "./run backend get"
Write-Host "执行: $buildCmd" -ForegroundColor DarkGray
Write-Host ""

docker run -it --rm `
    -v "${PWD}:/enso" `
    -w /enso `
    $imageTag `
    bash -c "$buildCmd"

Write-Host ""
if ($LASTEXITCODE -eq 0) {
    Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Green
    Write-Host "║                    构建成功！                            ║" -ForegroundColor Green
    Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Green
    Write-Host ""
    Write-Host "构建产物位置:" -ForegroundColor Cyan
    Write-Host "  - 后端: dist/backend/" -ForegroundColor White
    Write-Host "  - Engine: dist/backend/bin/" -ForegroundColor White
    Write-Host ""
    Write-Host "下一步操作:" -ForegroundColor Cyan
    Write-Host "  1. 查看 Engine: " -NoNewline -ForegroundColor White
    Write-Host ".\dist\backend\bin\enso.bat --version" -ForegroundColor Yellow
    Write-Host "  2. 运行 Engine: " -NoNewline -ForegroundColor White
    Write-Host ".\dist\backend\bin\enso.bat --server --daemon" -ForegroundColor Yellow
    Write-Host "  3. 查看 Docker 构建指南: " -NoNewline -ForegroundColor White
    Write-Host "Docker构建指南.md" -ForegroundColor Yellow
    Write-Host ""
} else {
    Write-Error "构建失败"
    Write-Host "请查看上方错误信息" -ForegroundColor Yellow
    exit 1
}
