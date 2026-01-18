#!/bin/bash

# AI Workflow 安装脚本
# https://github.com/yemingfeng/workflow
# 用法: curl -fsSL https://raw.githubusercontent.com/yemingfeng/workflow/master/install.sh | bash
# 指定 AI: curl -fsSL ... | bash -s -- --ai cursor

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

# 配置通知 hooks
configure_hooks() {
    local config_dir="$1"
    local settings_file="$config_dir/settings.json"

    # 通知 hooks 配置
    local hooks_config='{
  "hooks": {
    "Notification": [
      {
        "matcher": "permission_prompt",
        "hooks": [
          {
            "type": "command",
            "command": "osascript -e '\''display notification \"需要您的确认\" with title \"AI Workflow\" sound name \"Ping\"'\''"
          }
        ]
      },
      {
        "matcher": "idle_prompt",
        "hooks": [
          {
            "type": "command",
            "command": "osascript -e '\''display notification \"等待您的输入\" with title \"AI Workflow\" sound name \"Ping\"'\''"
          }
        ]
      }
    ]
  }
}'

    # 如果文件不存在，直接创建
    if [ ! -f "$settings_file" ]; then
        echo "$hooks_config" > "$settings_file"
        print_info "已创建 settings.json 并配置通知 hooks"
        return
    fi

    # 文件存在，尝试合并
    if command -v jq &> /dev/null; then
        # 使用 jq 合并
        local temp_file=$(mktemp)
        jq -s '.[0] * .[1]' "$settings_file" <(echo "$hooks_config") > "$temp_file" 2>/dev/null
        if [ $? -eq 0 ]; then
            mv "$temp_file" "$settings_file"
            print_info "已合并通知 hooks 到 settings.json"
        else
            rm -f "$temp_file"
            print_warning "合并失败，请手动添加 hooks 配置"
        fi
    else
        # 没有 jq，提示用户
        print_warning "settings.json 已存在，请手动添加以下 hooks 配置："
        echo ""
        echo "$hooks_config"
        echo ""
    fi
}

# 主函数
main() {
    local target_dir="."
    local ai_type="claude"

    # 解析参数
    while [[ $# -gt 0 ]]; do
        case $1 in
            --ai)
                ai_type="$2"
                shift 2
                ;;
            *)
                target_dir="$1"
                shift
                ;;
        esac
    done

    # 验证 ai_type
    case $ai_type in
        claude|cursor|qoder|windsurf|trae)
            ;;
        *)
            print_error "不支持的 AI 类型: $ai_type"
            print_info "支持的类型: claude, cursor, qoder, windsurf, trae"
            exit 1
            ;;
    esac

    local config_dir=".$ai_type"

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
    print_info "AI 类型: $ai_type"
    print_info "配置目录: $config_dir"

    # 检查 git
    if ! command -v git &> /dev/null; then
        print_error "需要安装 git"
        exit 1
    fi

    # 检查是否已存在配置目录
    if [ -d "$target_dir/$config_dir" ]; then
        print_warning "$config_dir 目录已存在，将被覆盖"
        rm -rf "$target_dir/$config_dir"
    fi

    # 克隆仓库
    local temp_dir=$(mktemp -d)
    print_info "克隆 AI Workflow 仓库..."
    git clone --depth 1 --quiet "https://github.com/yemingfeng/workflow.git" "$temp_dir/workflow"

    # 复制并重命名目录
    if [ -d "$temp_dir/workflow/.claude" ]; then
        cp -r "$temp_dir/workflow/.claude" "$target_dir/$config_dir"
    else
        print_error "仓库中找不到 .claude 目录"
        rm -rf "$temp_dir"
        exit 1
    fi

    # 清理
    rm -rf "$temp_dir"

    # 创建 .proposal 目录
    mkdir -p "$target_dir/.proposal"

    # 配置通知 hooks
    configure_hooks "$target_dir/$config_dir"

    # 验证安装
    if [ -d "$target_dir/$config_dir/skills/proposal" ] && \
       [ -d "$target_dir/$config_dir/skills/apply" ] && \
       [ -d "$target_dir/$config_dir/skills/fix" ]; then
        echo ""
        print_success "安装完成！"
        echo ""
        echo "已安装的文件："
        echo "├── $config_dir/"
        echo "│   ├── settings.json  (通知 hooks 配置)"
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
