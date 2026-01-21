#!/usr/bin/env pwsh
# Enso Docker 快速构建脚本（简化版）
# 使用 Docker Compose 构建 Enso

$ErrorActionPreference = "Stop"

Write-Host "玉皇大帝·数据分析平台 - 快速 Docker 构建" -ForegroundColor Cyan
Write-Host ""

# 检查 Docker Compose
Write-Host "检查 Docker Compose..." -ForegroundColor Yellow
docker-compose version > $null 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Error "Docker Compose 未安装或未运行"
    exit 1
}
Write-Host "✓ Docker Compose 可用" -ForegroundColor Green
Write-Host ""

# 运行构建
Write-Host "开始构建..." -ForegroundColor Yellow
Write-Host ""

docker-compose -f docker-compose.build.yml run --rm build bash -c "
    echo '=== 安装依赖 ===' &&
    corepack pnpm install &&
    echo '=== 构建后端 ===' &&
    ./run backend get &&
    echo '=== 构建完成 ===' &&
    ls -la dist/backend/
"

Write-Host ""
Write-Host "构建完成！查看 dist/backend/ 目录" -ForegroundColor Green
