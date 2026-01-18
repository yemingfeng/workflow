# AI Workflow

> AI 驱动的文档驱动开发工作流 | 轻量级、多技术栈、自动化

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

---

## 为什么选择 AI Workflow？

### 核心优势

| 优势 | 说明 |
|------|------|
| **文档驱动** | 需求、设计、API、测试用例一体化，文档即代码的唯一依据 |
| **三命令搞定** | `/proposal` → `/apply` → `/fix`，极简工作流 |
| **多技术栈** | 自动识别项目技术栈，无需手动配置 |
| **架构自适应** | 自动探测现有项目架构，遵循已有代码风格 |
| **自动修复** | 编译/测试失败时自动分析并修复，最多重试 3 次 |
| **系统通知** | 需要用户介入时自动发送系统通知，不错过任何交互 |

### 适用场景

- 个人开发者快速开发新功能
- 小团队需要轻量级的文档规范
- 希望 AI 辅助完成从需求到测试的完整流程
- 需要保持代码风格一致性的项目

---

## 快速开始

### 安装

```bash
curl -fsSL https://raw.githubusercontent.com/yemingfeng/workflow/master/install.sh | bash
```

### 使用方式

```bash
# 1. 生成提案文档
/proposal 实现用户注册功能，支持邮箱和密码注册

# 2. 执行实现（编码 + 测试）
/apply user-register

# 3. 定点修复 Bug
/fix 登录接口返回500错误，日志显示 NullPointerException
```

---

## 工作流程

```
┌─────────────────────────────────────────────────────────┐
│                                                         │
│   /proposal      →      /apply       →      /fix       │
│   (Plan模式)            (Auto模式)          (修复模式)  │
│                                                         │
│   生成全套文档           执行实现            定点修复    │
│   人机交互确认           编码+测试                      │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

---

## 核心原理

### 1. 文档驱动开发

```
需求 → 文档 → 代码 → 测试
        ↑
     单一事实来源
```

所有开发活动基于文档进行，文档是代码和测试的唯一依据。

### 2. 架构自适应

```
项目探测
    │
    ├─ 有现有代码 → 分析现有架构 → 遵循已有模式
    │
    └─ 空项目 → 引导用户设计技术栈
```

根据项目自动识别技术栈，如果无法识别（或者空项目），则引导用户一起设计技术栈。

---

## 架构设计

### Skills 架构

基于 Claude Code 官方 Skills 机制，采用统一的 Skills 架构：

```
┌─────────────────────────────────────────────────────────┐
│                      Skills 层                          │
│                                                         │
│   proposal/          apply/              fix/          │
│   ├─ SKILL.md       ├─ SKILL.md         └─ SKILL.md   │
│   └─ templates      ├─ CODING.md                       │
│                     ├─ UNIT-TEST.md                    │
│                     └─ API-TEST.md                     │
│                                                         │
│   (生成文档)         (实现代码)          (修复问题)     │
└─────────────────────────────────────────────────────────┘
```

**设计原则**：
- **Skills 统一入口**：所有能力通过 `SKILL.md` 定义，支持显式调用和自动触发
- **多文件支持**：复杂 Skill 可包含支持文件（如模板、规范文档）
- **渐进式披露**：主文件保持精简，详细内容放在支持文件中

### 文件结构

```
.claude/
└── skills/
    ├── proposal/                    # 提案生成 Skill
    │   ├── SKILL.md                # 入口：/proposal
    │   ├── requirements.template.md # 需求文档模板
    │   ├── design.template.md       # 设计文档模板
    │   ├── api-spec.template.md     # API 文档模板
    │   ├── test-cases.template.md   # 测试用例模板
    │   └── tasks.template.md        # 任务清单模板
    │
    ├── apply/                       # 实现执行 Skill
    │   ├── SKILL.md                # 入口：/apply
    │   ├── CODING.md               # 编码规范
    │   ├── UNIT-TEST.md            # 单元测试规范
    │   └── API-TEST.md             # API 测试规范
    │
    └── fix/                         # 定点修复 Skill
        └── SKILL.md                # 入口：/fix

.proposal/                           # 提案输出
└── {feature-name}/
    ├── 1-requirements.md           # 需求文档
    ├── 2-design.md                 # 设计文档
    ├── 3-api-spec.md               # API文档
    ├── 4-test-cases.md             # 测试用例
    └── 5-tasks.md                  # 任务清单
```

---

## 命令详解

### /proposal - 生成提案

**用途**：分析需求，生成完整的提案文档

**模式**：Plan 模式（需要人机交互确认）

```bash
/proposal 实现用户注册功能，支持邮箱和密码注册
```

**输出**：
```
✅ 提案生成完成：user-register

📁 文档位置：.proposal/user-register/
├── 1-requirements.md
├── 2-design.md
├── 3-api-spec.md
├── 4-test-cases.md
└── 5-tasks.md
```

### /apply - 执行实现

**用途**：基于提案文档执行编码和测试

**模式**：Auto 模式（默认全自动）

```bash
/apply user-register          # 指定提案
/apply                        # 使用最新提案
/apply user-register --step   # 阶段确认模式
/apply --skip-test            # 跳过测试
```

**输出**：
```
✅ 实现完成：user-register

📊 执行摘要：
├── 编码阶段: 5 个文件
├── 单元测试: 4 个通过
└── API 测试: 3 个通过
```

### /fix - 定点修复

**用途**：根据问题描述定位并修复 Bug

```bash
/fix 登录接口返回500错误，日志显示 NullPointerException 在 UserService 第42行
```

**输出**：
```
🔧 修复完成

📍 问题: NullPointerException
📁 文件: UserService.java:42
🛠️ 方案: 添加 Optional 处理
✅ 验证: 测试通过
```

---

## Skill 支持文件

`/apply` Skill 包含以下支持文件，定义各阶段的规范：

| 支持文件 | 职责 | 输入文档 | 输出 |
|----------|------|----------|------|
| CODING.md | 编码规范 | 需求、设计、API | 代码文件 |
| UNIT-TEST.md | 单元测试规范 | 需求、测试用例 | 测试文件 |
| API-TEST.md | API 测试规范 | API、测试用例 | 测试文件 |

---

## 失败处理

### 自动修复机制

```
❌ 测试失败
失败用例: testXxx

🔧 自动修复中（第 1/3 次）...
[分析原因]
[修复操作]

重新运行测试...
✅ 测试通过
```

### 多次失败

```
❌ 修复失败（已重试 3 次）

需要人工介入：
1. 检查错误信息
2. 手动修复后重新运行
```

---

## 最佳实践

1. **先 /proposal 后 /apply**：确保文档完整再实现
2. **检查待确认项**：执行 /apply 前确认所有 `[待确认]` 已处理
3. **使用 --step 模式**：首次使用建议阶段确认
4. **保持文档更新**：代码变更后同步更新文档
5. **利用 /fix 快速修复**：提供详细的错误信息加速定位

---

## License

MIT License - 详见 [LICENSE](LICENSE)

---

## Contributing

欢迎提交 Issue 和 Pull Request！

1. Fork 本项目
2. 创建特性分支 (`git checkout -b feature/amazing-feature`)
3. 提交更改 (`git commit -m 'Add amazing feature'`)
4. 推送到分支 (`git push origin feature/amazing-feature`)
5. 创建 Pull Request
