# 玉皇大帝·数据分析平台

玉皇大帝·数据分析平台是一个现代化的数据准备和分析平台，专为数据团队设计。它提供了低代码/无代码的可视化编程环境，支持数据清洗、转换、混合和自动化工作流程。该项目包含桌面 IDE（基于 Electron）和后端引擎（基于 Scala/Rust），支持 Windows、Mac 和 Linux 多平台部署。

## 核心功能

- **数据准备**: 清洗、转换和混合来自各种来源的数据，轻松处理结构化和非结构化数据
- **数据分析**: 执行强大的分析以获得洞察，无需广泛的编程知识
- **可视化编程**: 直观的图形化界面，通过拖放组件构建数据处理流程
- **自动化工作流**: 支持工作流的自动化执行和调度
- **本地与云端**: 支持本地开发和云端部署的无缝切换

## 技术栈

### 编程语言
- **Scala 3**: 后端引擎的主要语言
- **Rust**: 性能关键组件
- **TypeScript/JavaScript**: 前端开发
- **Vue.js 3**: GUI 框架

### 后端技术
- **Enso Engine**: 自研语言和编译器
- **GraalVM JDK 25.0.1**: 高性能运行时
- **构建工具**: sbt, Bazel

### 前端技术
- **Vue.js 3**: 响应式 GUI 框架
- **Electron**: 跨平台桌面应用
- **Monaco Editor**: 代码编辑器组件
- **Tailwind CSS**: 样式框架

### 架构
- **桌面应用**: Electron IDE
- **后端服务**: Enso Engine（独立进程）
- **通信**: gRPC/RPC

## 项目目录概览

```
enso/
├── app/                          # 前端应用
│   ├── electron-client/           # Electron 主进程
│   ├── gui/                      # Vue.js GUI 应用
│   └── common/                   # 共享组件
├── engine/                       # 后端引擎
│   ├── language-server/          # 语言服务器
│   ├── runtime/                  # 运行时和编译器
│   └── polyglot-api/             # 多语言 API
├── lib/                          # 共享库
│   ├── scala/                    # Scala 库
│   └── rust/                     # Rust 库
├── distribution/                 # 发布相关
└── docs/                         # 文档
```

## 使用场景

- **财务分析**: 自动化预算与实际对比报告，在整个组织内协调数据
- **会计处理**: 简化对账流程，更快结账，提供可重复的结果
- **税务处理**: 自动混合来自多个实体和系统的数据
- **销售运营**: 处理销售佣金报告，集成 CRM 和营销自动化数据

## 快速开始

### 环境要求

- **Node.js**: 版本见 `.node-version` 文件
- **pnpm**: 10.2.1+
- **Java**: GraalVM JDK 25.0.1（Engine 需要）
- **Rust**: 最新稳定版（Rust 组件需要）
- **操作系统**: Windows, macOS, Linux

### 安装步骤

```bash
# 1. 克隆项目
git clone https://www.gitpp.com/liyihui/enso
cd enso

# 2. 安装依赖
corepack pnpm install
```

### 运行步骤

```bash
# 开发模式运行 GUI
corepack pnpm run dev:gui

# 构建 IDE
corepack pnpm run build:ide

# 构建并打包 IDE
corepack pnpm run dist:ide
```

### Engine 服务运行

```bash
# 使用 run 脚本启动 Engine 服务
./run --server --daemon

# 或使用 Docker（如果已构建镜像）
docker run -p 30001:30001 -p 30002:30002 -p 5976:5976 enso-engine:latest
```

## 架构说明

### 业务服务

- **Enso Engine**: 端口 30001 (RPC), 30002 (DATA), 5976 (YDOC)
  - 描述：后端引擎服务，提供语言解释器、编译器和运行时
- **Enso IDE**: 桌面应用（不暴露端口）
  - 描述：Electron 桌面应用，提供图形化编程界面

### 服务依赖关系

1. Enso IDE 连接到 Enso Engine（通过 RPC 端口 30001）
2. Engine 可以作为独立服务运行（`--server --daemon` 模式）
3. 前端 GUI 应用通过 gRPC 与 Engine 通信

## 常见问题

### 构建失败怎么办？

- 确保已安装所有必需的依赖（Node.js, pnpm, GraalVM, Rust）
- 检查 Node.js 版本是否与 `.node-version` 文件一致
- 尝试清理缓存：`corepack pnpm run bazel-clean`

### 如何获取帮助？

- 查看项目文档和示例
- 查看源码中的注释和类型定义
- 检查 `docs/` 目录获取更多技术文档

## 贡献

欢迎贡献代码！请确保：

- 遵循项目的代码规范
- 添加必要的测试
- 更新相关文档

## 许可证

本项目采用开源许可证。详见 [LICENSE](LICENSE) 文件。
