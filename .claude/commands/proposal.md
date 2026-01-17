# /proposal - 生成提案文档

## 描述

分析用户需求，生成完整的提案文档，包括需求、设计、API、测试用例和任务清单。

**模式**：Plan 模式（需要人机交互确认）

**支持技术栈**：前端 (React/Vue)、后端 (Java/Python/Go)、全栈

---

## 前置信息收集

```bash
echo "=== 项目类型探测 ==="
[ -f "package.json" ] && echo "FOUND: package.json (Node/Frontend)" && cat package.json | grep -E '"(react|vue|angular|next|nuxt)"' | head -5
[ -f "pom.xml" ] && echo "FOUND: pom.xml (Java/Maven)"
[ -f "build.gradle" ] && echo "FOUND: build.gradle (Java/Gradle)"
[ -f "go.mod" ] && echo "FOUND: go.mod (Go)"
[ -f "requirements.txt" ] && echo "FOUND: requirements.txt (Python)"
[ -f "pyproject.toml" ] && echo "FOUND: pyproject.toml (Python)"

echo ""
echo "=== 项目结构 ==="
ls -la

echo ""
echo "=== 源码目录 ==="
[ -d "src" ] && ls -la src/ | head -15
[ -d "app" ] && ls -la app/ | head -15

echo ""
echo "=== 现有提案 ==="
ls -la .proposal/ 2>/dev/null || echo "无现有提案"

echo ""
echo "=== CLAUDE.md ==="
[ -f "CLAUDE.md" ] && head -50 CLAUDE.md || echo "CLAUDE.md 不存在"
```

---

## 执行流程

### Step 0: 项目探测

1. 检测项目配置文件确定技术栈
2. 分析目录结构确定代码风格
3. **探测现有架构**（如果有代码）
4. 生成 `context.json` 保存到提案目录

**context.json 结构**：
```json
{
  "projectType": "frontend|backend|fullstack",
  "techStack": {
    "language": "TypeScript|Java|Python|Go",
    "framework": "React|Vue|Spring Boot|FastAPI|Gin",
    "buildTool": "npm|maven|gradle|pip|go",
    "testFramework": "Jest|Vitest|JUnit|pytest|go test"
  },
  "structure": {
    "sourceDir": "src|app|lib",
    "testDir": "__tests__|test|tests"
  },
  "architecture": {
    "detected": true,
    "layers": [
      {
        "name": "controller",
        "path": "src/main/java/**/controller",
        "pattern": "*Controller.java",
        "examples": ["UserController.java"]
      }
    ],
    "conventions": {
      "naming": "camelCase|PascalCase|snake_case",
      "suffixes": {"controller": "Controller", "service": "Service"}
    }
  }
}
```

**architecture 字段说明**：

| 字段 | 说明 |
|------|------|
| detected | 是否探测到现有架构（false = 空项目） |
| layers | 探测到的分层信息，包含路径和命名模式 |
| conventions | 命名规范和后缀约定 |

**探测逻辑**：
- 有现有代码 → 分析分层结构 → `architecture.detected = true`
- 空项目 → `architecture.detected = false` → coding 时可使用推荐架构

### Step 1: 需求澄清

1. 分析用户输入的需求描述
2. 识别以下信息：
   - 核心功能点
   - 业务场景
   - 可能的约束条件
3. 提出澄清问题（如果需求不明确）
4. 等待用户确认后继续

### Step 2: 创建提案目录

```bash
# 创建目录（feature-name 从需求中提取，使用英文短横线连接）
mkdir -p .proposal/{feature-name}

# 将 context.json 保存到提案目录
# context.json 包含项目探测结果
```

### Step 3: 调用 spec-writer Agent

**任务**：探测项目类型，生成需求文档和设计文档

**输入**：
- 用户需求描述
- `.claude/templates/requirements.template.md`
- `.claude/templates/design.template.md`
- 项目代码库

**输出**：
- `.proposal/{feature}/context.json` (项目上下文)
- `.proposal/{feature}/1-requirements.md`
- `.proposal/{feature}/2-design.md`

**执行后**：展示文档摘要，确认是否继续

### Step 4: 调用 api-writer Agent

**任务**：生成 API 接口文档

**输入**：
- `.proposal/{feature}/1-requirements.md`
- `.proposal/{feature}/2-design.md`
- `.claude/templates/api-spec.template.md`

**输出**：
- `.proposal/{feature}/3-api-spec.md`

### Step 5: 调用 testcase-writer Agent

**任务**：生成测试用例文档

**输入**：
- `.proposal/{feature}/1-requirements.md`
- `.proposal/{feature}/3-api-spec.md`
- `.claude/templates/test-cases.template.md`

**输出**：
- `.proposal/{feature}/4-test-cases.md`

### Step 6: 生成任务清单

基于所有文档，生成 `5-tasks.md`：
- 从设计文档提取编码任务
- 从测试用例文档提取测试任务
- 添加验证任务

---

## 输出

完成后显示：

```
✅ 提案生成完成：{feature-name}

🔍 项目类型：{projectType}/{framework}
   语言: {language}
   构建工具: {buildTool}
   测试框架: {testFramework}
   架构: {architecture.detected ? "已探测到现有架构" : "空项目（使用推荐架构）"}

📁 文档位置：.proposal/{feature-name}/
├── context.json        (项目上下文)
├── 1-requirements.md   (需求文档)
├── 2-design.md         (设计文档)
├── 3-api-spec.md       (API文档)
├── 4-test-cases.md     (测试用例)
└── 5-tasks.md          (任务清单)

📋 摘要：
- 功能要求: X 项
- API 接口: X 个
- 测试用例: UT-X 个, AT-X 个
- 开发任务: X 个

⚠️ 待确认项: X 个

👉 下一步:
   1. 检查文档，确认待确认项
   2. 执行 /apply {feature-name} 开始实现
```

---

## 参数

- `$ARGUMENTS`：用户需求描述

**示例**：
```
/proposal 实现用户注册功能，支持邮箱和密码注册
/proposal 添加订单查询接口，支持按时间范围和状态筛选
```

---

## 注意事项

1. **不要猜测**：不确定的内容标记 [待确认]
2. **参考现有代码**：保持与项目风格一致
3. **渐进式生成**：每个文档生成后可以与用户确认
4. **质量优先**：宁可多问，不要假设
