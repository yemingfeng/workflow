#!/bin/bash

# AI Workflow 安装脚本
# https://github.com/yemingfeng/workflow
# 用法: curl -fsSL https://raw.githubusercontent.com/yemingfeng/workflow/master/install.sh | bash

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# 主函数
main() {
    local target_dir="${1:-.}"
    target_dir=$(cd "$target_dir" 2>/dev/null && pwd || echo "$target_dir")

    # 检查目标目录是否存在
    if [ ! -d "$target_dir" ]; then
        print_error "目标目录不存在: $target_dir"
        exit 1
    fi

    echo ""
    echo "╔════════════════════════════════════════════╗"
    echo "║          AI Workflow 安装程序              ║"
    echo "╚════════════════════════════════════════════╝"
    echo ""

    print_info "目标目录: $target_dir"

    # 检查 git
    if ! command -v git &> /dev/null; then
        print_error "需要安装 git"
        exit 1
    fi

    # 检查是否已存在 .claude 目录
    if [ -d "$target_dir/.claude" ]; then
        print_warning ".claude 目录已存在，将被覆盖"
        rm -rf "$target_dir/.claude"
    fi

    # 克隆仓库
    local temp_dir=$(mktemp -d)
    print_info "克隆 AI Workflow 仓库..."
    git clone --depth 1 --quiet "https://github.com/yemingfeng/workflow.git" "$temp_dir/workflow"

    # 复制 .claude 目录
    if [ -d "$temp_dir/workflow/.claude" ]; then
        cp -r "$temp_dir/workflow/.claude" "$target_dir/"
    else
        print_error "仓库中找不到 .claude 目录"
        rm -rf "$temp_dir"
        exit 1
    fi

    # 清理
    rm -rf "$temp_dir"

    # 创建 .proposal 目录
    mkdir -p "$target_dir/.proposal"

    # 验证安装
    if [ -d "$target_dir/.claude/skills/proposal" ] && \
       [ -d "$target_dir/.claude/skills/apply" ] && \
       [ -d "$target_dir/.claude/skills/fix" ]; then
        echo ""
        print_success "安装完成！"
        echo ""
        echo "已安装的文件："
        echo "├── .claude/"
        echo "│   └── skills/"
        echo "│       ├── proposal/  (提案生成 + 5个模板)"
        echo "│       ├── apply/     (实现执行 + 3个规范)"
        echo "│       └── fix/       (定点修复)"
        echo "└── .proposal/         (提案输出目录)"
        echo ""
        echo "开始使用："
        echo "  1. /proposal 实现用户注册功能"
        echo "  2. /apply user-register"
        echo "  3. /fix 修复某个Bug"
        echo ""
        echo "更多信息请访问: https://github.com/yemingfeng/workflow"
        echo ""
    else
        print_error "安装验证失败，请检查文件完整性"
        exit 1
    fi
}

main "$@"
