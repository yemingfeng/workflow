#!/bin/bash

# AI Workflow 安装脚本
# https://github.com/yemingfeng/workflow

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 打印带颜色的消息
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

# 显示帮助信息
show_help() {
    echo "AI Workflow 安装脚本"
    echo ""
    echo "用法: ./install.sh [目标目录]"
    echo ""
    echo "参数:"
    echo "  目标目录    要安装到的项目目录（默认为当前目录）"
    echo ""
    echo "示例:"
    echo "  ./install.sh                    # 安装到当前目录"
    echo "  ./install.sh /path/to/project   # 安装到指定目录"
    echo "  ./install.sh --help             # 显示帮助"
    echo ""
    echo "在线安装:"
    echo "  curl -fsSL https://raw.githubusercontent.com/yemingfeng/workflow/master/install.sh | bash"
    echo ""
}

# 获取脚本所在目录
get_script_dir() {
    local source="${BASH_SOURCE[0]}"
    while [ -h "$source" ]; do
        local dir="$(cd -P "$(dirname "$source")" && pwd)"
        source="$(readlink "$source")"
        [[ $source != /* ]] && source="$dir/$source"
    done
    echo "$(cd -P "$(dirname "$source")" && pwd)"
}

# 从 GitHub 下载
download_from_github() {
    local target_dir="$1"
    local temp_dir=$(mktemp -d)
    local repo_url="https://github.com/yemingfeng/workflow/archive/refs/heads/master.zip"

    print_info "从 GitHub 下载 AI Workflow..."

    if command -v curl &> /dev/null; then
        curl -fsSL "$repo_url" -o "$temp_dir/workflow.zip"
    elif command -v wget &> /dev/null; then
        wget -q "$repo_url" -O "$temp_dir/workflow.zip"
    else
        print_error "需要 curl 或 wget 来下载文件"
        exit 1
    fi

    print_info "解压文件..."
    unzip -q "$temp_dir/workflow.zip" -d "$temp_dir"

    # 复制 .claude 目录
    if [ -d "$temp_dir/workflow-master/.claude" ]; then
        cp -r "$temp_dir/workflow-master/.claude" "$target_dir/"
    else
        print_error "下载的文件中找不到 .claude 目录"
        rm -rf "$temp_dir"
        exit 1
    fi

    # 清理临时文件
    rm -rf "$temp_dir"
}

# 从本地复制
copy_from_local() {
    local source_dir="$1"
    local target_dir="$2"

    if [ ! -d "$source_dir/.claude" ]; then
        print_error "源目录中找不到 .claude 文件夹: $source_dir"
        exit 1
    fi

    print_info "从本地复制 .claude 目录..."
    cp -r "$source_dir/.claude" "$target_dir/"
}

# 主函数
main() {
    # 检查帮助参数
    if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
        show_help
        exit 0
    fi

    # 确定目标目录
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

    # 检查是否已存在 .claude 目录
    if [ -d "$target_dir/.claude" ]; then
        print_warning ".claude 目录已存在"
        read -p "是否覆盖？(y/N): " confirm
        if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
            print_info "安装已取消"
            exit 0
        fi
        rm -rf "$target_dir/.claude"
    fi

    # 判断是本地安装还是远程下载
    local script_dir=$(get_script_dir)

    if [ -d "$script_dir/.claude" ]; then
        # 本地安装
        copy_from_local "$script_dir" "$target_dir"
    else
        # 从 GitHub 下载
        download_from_github "$target_dir"
    fi

    # 创建 .proposal 目录（如果不存在）
    mkdir -p "$target_dir/.proposal"

    # 验证安装
    if [ -d "$target_dir/.claude/commands" ] && \
       [ -d "$target_dir/.claude/agents" ] && \
       [ -d "$target_dir/.claude/templates" ]; then
        echo ""
        print_success "安装完成！"
        echo ""
        echo "已安装的文件："
        echo "├── .claude/"
        echo "│   ├── commands/     (3 个命令)"
        echo "│   ├── agents/       (6 个 Agent)"
        echo "│   └── templates/    (5 个模板)"
        echo "└── .proposal/        (提案输出目录)"
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

# 执行主函数
main "$@"
