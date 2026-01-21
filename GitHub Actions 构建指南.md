# GitHub Actions 自动构建指南

本文档指导你如何使用 GitHub Actions 自动构建包含汉化修改的玉皇大帝·数据分析平台。

## 前提条件

- [x] GitHub 账号（如果没有，请先注册 https://github.com/signup）
- [x] 能访问 GitHub 网站
- [x] 项目已汉化完成（✅ 已完成）

---

## 步骤 1：Fork 项目到你的 GitHub 账号

### 方法 1：通过网页 Fork（推荐）

1. **访问原始项目**
   ```
   https://github.com/enso-org/enso
   ```

2. **Fork 项目**
   - 点击页面右上角的 **"Fork"** 按钮
   - 选择 Fork 到你的账号（如果提示）
   - 等待 Fork 完成（约 10-30 秒）

3. **确认 Fork 成功**
   - 你会被重定向到：
     ```
     https://github.com/你的用户名/enso
     ```

### 方法 2：通过 API Fork（自动化）

如果你提供 GitHub 用户名和 token，我可以帮你自动 Fork。

---

## 步骤 2：启用 GitHub Actions

1. **进入你 Fork 的项目**
   ```
   https://github.com/你的用户名/enso
   ```

2. **进入 Actions 标签**
   - 点击顶部的 **"Actions"** 标签

3. **启用 Actions（如果提示）**
   - 如果看到 "I understand my workflows, go ahead and enable them" 按钮
   - 点击启用

4. **确认启用成功**
   - 应该看到工作流列表
   - 至少包含："Nightly", "Engine CI", "IDE Packaging" 等

---

## 步骤 3：触发自动构建

### 方法 1：创建 Release（推荐）

1. **进入 Releases 页面**
   ```
   https://github.com/你的用户名/enso/releases
   ```

2. **创建新 Release**
   - 点击 **"Draft a new release"**
   - 填写信息：
     - **Tag**: `v0.2.1-custom` （或 v0.2.2）
     - **Title**: `玉皇大帝·数据分析平台 v0.2.1`
     - **Description**:
       ```
       自定义汉化版本

       主要修改：
       - 应用名称汉化
       - 产品名称和公司名称汉化
       - 中文 README 文档
       ```

3. **发布 Release**
   - 勾选 **"Set as the latest release"**（可选）
   - 点击 **"Publish release"**

4. **自动构建触发**
   - 发布后会自动触发 CI/CD 构建流程
   - 在 "Actions" 页面可以看到构建进度
   - 构建时间：30-60 分钟

### 方法 2：直接推送触发

如果你已经克隆了项目，可以推送你的修改：

```bash
cd C:\Users\L1822\IdeaProjects\enso

# 添加远程仓库（你的 Fork）
git remote add myfork https://github.com/你的用户名/enso.git

# 推送代码
git push myfork develop
```

---

## 步骤 4：监控构建进度

1. **查看 Actions 页面**
   ```
   https://github.com/你的用户名/enso/actions
   ```

2. **查看构建工作流**
   - 应该看到最近的 workflow run
   - 状态显示为 "⚙️ Running" 或 "✅ Success"

3. **查看构建日志**
   - 点击对应的 workflow run
   - 可以看到各个步骤的执行情况

---

## 步骤 5：下载构建产物

### 1. 等待构建完成

构建通常需要 **30-60 分钟**，请耐心等待。

### 2. 进入构建成功的 run 页面

- 在 Actions 页面点击成功的 workflow run

### 3. 下载 Artifacts

在页面底部找到 **"Artifacts"** 部分：

- **backend-linux** - Linux 版本
- **backend-windows** - Windows 版本
- **backend-macos** - macOS 版本
- **ide-desktop** - 完整 IDE（推荐）

点击下载按钮，会下载 `.zip` 文件。

---

## 步骤 6：安装和运行

### Windows 版本

1. **解压下载的 `.zip` 文件**

2. **运行安装包**
   - 找到 `enso-setup-<version>.exe`
   - 双击运行安装

3. **启动应用**
   - 安装完成后从开始菜单启动
   - 或从桌面快捷方式启动

---

## 验证汉化效果

安装后你应该能看到：

- ✅ 应用标题显示 "玉皇大帝·数据分析平台"
- ✅ 关于对话框显示汉化名称
- ✅ README 是中文文档

---

## 常见问题

### Q1: Actions 显示 "Workflow disabled"

**A**: 需要先启用 Actions。点击页面上的按钮启用。

### Q2: 构建失败

**A**: 检查构建日志，通常是以下原因：
- 网络问题
- 依赖下载失败
- 代码错误

### Q3: 如何重新构建？

**A**: 创建新的 Release 或删除旧的 Release 后重新创建。

### Q4: 可以修改代码后重新构建吗？

**A**: 可以！
1. 在本地修改代码
2. 推送到你的 Fork
3. 创建新 Release 触发构建

---

## 下一步

构建完成后，你将获得：

1. **Windows 安装包** - `.exe` 文件
2. **Linux 版本** - AppImage 或 tar.gz
3. **macOS 版本** - .dmg 文件
4. **完整 IDE** - 包含所有功能

---

## 需要帮助？

如果在任何步骤遇到问题：

1. **检查 Actions 日志** - 查看具体错误信息
2. **查看本文档** - 确认步骤正确
3. **联系支持** - 提供具体的错误截图

---

祝构建顺利！🎉
