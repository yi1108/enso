# 使用 Docker 构建 Enso 安装包指南

本指南介绍如何使用 Docker 环境构建玉皇大帝·数据分析平台（Enso）的安装包，避免在本地配置复杂的开发环境。

## 前提条件

1. **安装 Docker Desktop**
   - Windows: 下载 [Docker Desktop for Windows](https://www.docker.com/products/docker-desktop/)
   - 安装后确保 Docker 正在运行
   - 确保有足够的磁盘空间（至少 20GB）

2. **启用 Docker 的 WSL 2 后端**（Windows）
   - 打开 Docker Desktop
   - 进入 Settings > General
   - 启用 "Use the WSL 2 based engine"
   - 重启 Docker Desktop

## 快速开始

### 方式 1：交互式构建（推荐）

```powershell
cd C:\Users\L1822\IdeaProjects\enso

# 构建镜像
docker build -t enso-builder -f Dockerfile.build .

# 运行容器并进入命令行
docker run -it --rm -v ${PWD}:/enso -w /enso enso-builder /bin/bash

# 在容器内执行构建命令
./run backend get

# 退出容器
exit
```

### 方式 2：使用 Docker Compose（更方便）

```powershell
cd C:\Users\L1822\IdeaProjects\enso

# 启动构建容器
docker-compose -f docker-compose.build.yml run --rm build bash

# 在容器内执行构建
./run backend get

# 或者直接执行命令
docker-compose -f docker-compose.build.yml run --rm build ./run backend get
```

### 方式 3：一键构建脚本

创建 `build-docker.ps1` 脚本：

```powershell
# build-docker.ps1
$ErrorActionPreference = "Stop"

Write-Host "正在构建 Enso Builder 镜像..." -ForegroundColor Green
docker build -t enso-builder -f Dockerfile.build .

Write-Host "正在运行构建..." -ForegroundColor Green
docker run -it --rm `
    -v ${PWD}:/enso `
    -w /enso `
    enso-builder `
    ./run backend get

Write-Host "构建完成！输出目录: dist/" -ForegroundColor Green
```

运行：
```powershell
.\build-docker.ps1
```

## 详细步骤

### 1. 构建后端

```powershell
docker run -it --rm `
    -v ${PWD}:/enso `
    -w /enso `
    enso-builder `
    ./run backend get
```

这将：
- 下载并安装所有依赖
- 编译 Scala/Rust 代码
- 生成 Engine 发行版
- 输出到 `dist/backend/` 目录

### 2. 构建 GUI

```powershell
docker run -it --rm `
    -v ${PWD}:/enso `
    -w /enso `
    enso-builder `
    bash -c "corepack pnpm install && corepack pnpm run build:gui"
```

### 3. 打包 IDE

```powershell
docker run -it --rm `
    -v ${PWD}:/enso `
    -w /enso `
    enso-builder `
    bash -c "corepack pnpm install && corepack pnpm run dist:ide"
```

这将生成 Windows 安装包到 `distribution/ide-desktop/` 目录。

## 提取构建产物

### 从容器复制文件

```powershell
# 列出容器中的文件
docker run --rm -v ${PWD}:/enso -w /enso enso-builder ls -la dist/

# 从容器复制文件到主机
docker cp <container_id>:/enso/dist/backend ./dist/
```

### 使用卷挂载

在 `docker-compose.build.yml` 中已配置卷挂载，构建产物会自动同步到主机。

## 常见问题

### 1. Docker 构建失败 - 磁盘空间不足

**错误**: `no space left on device`

**解决**:
```powershell
# 清理 Docker 缓存
docker system prune -a --volumes

# 或仅清理未使用的镜像
docker image prune -a
```

### 2. 容器内网络问题

**错误**: 无法下载依赖

**解决**:
```powershell
# 使用代理（如果有）
docker run -e HTTP_PROXY=http://proxy:port ...
```

### 3. 权限问题

**错误**: `Permission denied`

**解决**:
```powershell
# 确保以管理员身份运行 PowerShell
# 或在 Docker Desktop 中启用文件共享
```

### 4. 构建超时

**错误**: 构建过程时间过长

**解决**:
```powershell
# 增加 Docker 资源限制
# Docker Desktop > Settings > Resources > Memory: 8GB+
# Docker Desktop > Settings > Resources > CPU: 4+
```

## 性能优化

### 使用 BuildKit 加速构建

```powershell
# 启用 BuildKit
$env:DOCKER_BUILDKIT=1
docker build -t enso-builder -f Dockerfile.build .
```

### 缓存依赖层

```powershell
# 先复制依赖文件
COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
RUN corepack pnpm install

# 再复制源码
COPY . .
```

### 使用多阶段构建

分离构建和运行环境，减小镜像大小。

## 验证构建

### 检查构建产物

```powershell
# 检查后端构建
docker run --rm -v ${PWD}:/enso -w /enso enso-builder ls -la dist/backend/

# 检查 IDE 构建
docker run --rm -v ${PWD}:/enso -w /enso enso-builder ls -la distribution/ide-desktop/
```

### 测试运行

```powershell
# 运行 Engine 服务（需要在容器内）
docker run -it --rm `
    -v ${PWD}:/enso `
    -w /enso `
    -p 30001:30001 -p 30002:30002 `
    enso-builder `
    ./run --server --daemon
```

## 完整示例

### 完整构建脚本

```powershell
# complete-build.ps1
$ErrorActionPreference = "Stop"

Write-Host "=== Enso Docker 构建脚本 ===" -ForegroundColor Cyan
Write-Host ""

# 1. 检查 Docker
Write-Host "检查 Docker..." -ForegroundColor Yellow
docker version > $null 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Error "Docker 未运行，请启动 Docker Desktop"
    exit 1
}
Write-Host "✓ Docker 正在运行" -ForegroundColor Green
Write-Host ""

# 2. 构建镜像
Write-Host "构建 Docker 镜像..." -ForegroundColor Yellow
docker build -t enso-builder -f Dockerfile.build . --progress=plain
if ($LASTEXITCODE -ne 0) {
    Write-Error "镜像构建失败"
    exit 1
}
Write-Host "✓ 镜像构建成功" -ForegroundColor Green
Write-Host ""

# 3. 构建后端
Write-Host "构建后端..." -ForegroundColor Yellow
docker run -it --rm `
    -v ${PWD}:/enso `
    -w /enso `
    enso-builder `
    ./run backend get
if ($LASTEXITCODE -ne 0) {
    Write-Error "后端构建失败"
    exit 1
}
Write-Host "✓ 后端构建成功" -ForegroundColor Green
Write-Host ""

# 4. 构建并打包 IDE
Write-Host "构建并打包 IDE..." -ForegroundColor Yellow
docker run -it --rm `
    -v ${PWD}:/enso `
    -w /enso `
    enso-builder `
    bash -c "corepack pnpm run dist:ide"
if ($LASTEXITCODE -ne 0) {
    Write-Error "IDE 构建失败"
    exit 1
}
Write-Host "✓ IDE 构建成功" -ForegroundColor Green
Write-Host ""

# 5. 列出构建产物
Write-Host "构建产物:" -ForegroundColor Cyan
Get-ChildItem -Path "dist", "distribution" -Recurse -File | Select-Object FullName, Length

Write-Host ""
Write-Host "=== 构建完成 ===" -ForegroundColor Green
Write-Host "安装包位置: distribution/ide-desktop/dist/" -ForegroundColor Cyan
```

运行：
```powershell
.\complete-build.ps1
```

## 下一步

构建完成后：

1. **查找安装包**
   ```powershell
   dir distribution\ide-desktop\dist\
   ```

2. **运行安装包**
   ```powershell
   # Windows
   .\distribution\ide-desktop\dist\玉皇大帝·数据分析平台-Setup-<version>.exe
   ```

3. **或使用 Engine**
   ```powershell
   .\dist\backend\bin\enso.bat --help
   ```

## 注意事项

1. **首次构建**可能需要很长时间（1-2小时），因为要下载所有依赖
2. **磁盘空间**：确保有足够空间（至少 20GB）
3. **内存**：Docker Desktop 至少分配 4GB 内存
4. **网络**：构建过程需要稳定的网络连接

## 获取帮助

如果遇到问题：
1. 检查 Docker 日志：`docker logs <container_id>`
2. 查看构建错误：`docker build --no-cache ...`
3. 参考主安装指南：`安装指南.md`
