#!/bin/bash
# GitHub Actions 自动构建设置脚本
# 玉皇大帝·数据分析平台

set -e

echo "========================================="
echo "  玉皇大帝·数据分析平台 - 自动构建设置"
echo "========================================="
echo ""

# 颜色定义
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# 步骤 1：检查 GitHub 用户名
echo -e "${YELLOW}步骤 1/5：检查 GitHub 配置${NC}"
if ! git config user.githubusername > /dev/null 2>&1; then
    echo "请输入你的 GitHub 用户名："
    read GITHUB_USERNAME
    git config --global user.githubusername "$GITHUB_USERNAME"
else
    GITHUB_USERNAME=$(git config user.githubusername)
    echo "✓ GitHub 用户名: $GITHUB_USERNAME"
fi
echo ""

# 步骤 2：打开 Fork 页面
echo -e "${YELLOW}步骤 2/5：准备 Fork 项目${NC}"
echo "正在打开 GitHub 项目页面..."
if command -v start > /dev/null 2>&1; then
    start https://github.com/enso-org/enso
elif command -v xdg-open > /dev/null 2>&1; then
    xdg-open https://github.com/enso-org/enso
else
    echo "请手动访问: https://github.com/enso-org/enso"
fi
echo ""
echo "请按以下步骤操作："
echo "  1. 点击页面右上角的 \"Fork\" 按钮"
echo "  2. 选择 Fork 到你的账号"
echo "  3. 等待 Fork 完成（约 10-30 秒）"
echo ""
echo "完成后按 Enter 继续..."
read
echo ""

# 步骤 3：添加 Fork 远程仓库
echo -e "${YELLOW}步骤 3/5：添加 Fork 远程仓库${NC}"
FORK_URL="https://github.com/$GITHUB_USERNAME/enso.git"

if git remote get-url myfork > /dev/null 2>&1; then
    echo "✓ 远程仓库 'myfork' 已存在"
    git remote set-url myfork "$FORK_URL"
else
    git remote add myfork "$FORK_URL"
    echo "✓ 添加远程仓库: myfork -> $FORK_URL"
fi
echo ""

# 步骤 4：推送汉化代码到 Fork
echo -e "${YELLOW}步骤 4/5：推送代码到你的 Fork${NC}"
echo "正在推送当前分支的汉化修改..."
git push myfork develop || {
    echo -e "${RED}推送失败！${NC}"
    echo "请确保你已经 Fork 了项目"
    echo "Fork 地址: https://github.com/$GITHUB_USERNAME/enso"
    exit 1
}
echo "✓ 代码推送成功"
echo ""

# 步骤 5：打开创建 Release 页面
echo -e "${YELLOW}步骤 5/5：创建 Release 触发构建${NC}"
RELEASE_URL="https://github.com/$GITHUB_USERNAME/enso/releases/new"

echo "正在打开 Release 创建页面..."
if command -v start > /dev/null 2>&1; then
    start "$RELEASE_URL"
elif command -v xdg-open > /dev/null 2>&1; then
    xdg-open "$RELEASE_URL"
else
    echo "请手动访问: $RELEASE_URL"
fi
echo ""
echo "请按以下步骤填写："
echo "  Tag: v0.2.1-custom"
echo "  Title: 玉皇大帝·数据分析平台 v0.2.1"
echo "  Description: 自定义汉化版本"
echo ""
echo "勾选 \"Set as the latest release\""
echo "点击 \"Publish release\" 按钮"
echo ""

# 完成
echo -e "${GREEN}=========================================${NC}"
echo -e "${GREEN}  设置完成！${NC}"
echo -e "${GREEN}=========================================${NC}"
echo ""
echo "接下来的步骤："
echo "  1. 构建将在 30-60 分钟内自动完成"
echo "  2. 访问 Actions 页面查看进度:"
echo "     https://github.com/$GITHUB_USERNAME/enso/actions"
echo ""
echo "  3. 构建完成后，在 Artifacts 部分下载:"
echo "     - ide-desktop (推荐)"
echo "     - backend-windows"
echo ""
echo -e "${GREEN}祝构建顺利！🎉${NC}"
