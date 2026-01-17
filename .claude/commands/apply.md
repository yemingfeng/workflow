# /apply - 执行实现

## 描述

基于已生成的提案文档，执行编码和测试。

**模式**：Auto 模式（默认全自动，支持阶段确认）

**支持技术栈**：根据 context.json 自动选择构建和测试命令

---

## 前置信息收集

```bash
echo "=== 提案列表 ==="
ls -la .proposal/ 2>/dev/null || echo "无提案目录"

echo ""
echo "=== 目标提案内容 ==="
if [ -n "$1" ]; then
    ls -la .proposal/$1/ 2>/dev/null
    echo ""
    echo "=== 项目上下文 ==="
    cat .proposal/$1/context.json 2>/dev/null || echo "无 context.json"
else
    # 获取最新的提案
    LATEST=$(ls -t .proposal/ 2>/dev/null | head -1)
    if [ -n "$LATEST" ]; then
        echo "最新提案: $LATEST"
        ls -la .proposal/$LATEST/
        echo ""
        echo "=== 项目上下文 ==="
        cat .proposal/$LATEST/context.json 2>/dev/null || echo "无 context.json"
    fi
fi

echo ""
echo "=== 当前 Git 状态 ==="
git status --short 2>/dev/null || echo "非 Git 仓库"
```

---

## 参数

- `$ARGUMENTS`：提案名称（可选，默认使用最新提案）

**选项**：
- `--step`：阶段确认模式，每阶段完成后等待确认
- `--skip-test`：跳过测试阶段（仅编码）

**示例**：
```
/apply user-register
/apply user-register --step
/apply --skip-test
```

---

## 执行流程

### Step 0: 确认提案和项目上下文

1. 确定目标提案目录
2. **读取 context.json 获取项目技术栈**：
   - projectType: frontend/backend/fullstack
   - techStack.buildTool: npm/maven/gradle/pip/go
   - techStack.testFramework: Jest/Vitest/JUnit/pytest/go test
3. 检查文档完整性：
   - context.json ✓
   - 1-requirements.md ✓
   - 2-design.md ✓
   - 3-api-spec.md ✓
   - 4-test-cases.md ✓
   - 5-tasks.md ✓
4. 检查是否有 [待确认] 项未处理
5. 显示任务摘要，确认开始

### Step 1: 编码阶段

**调用 coding Agent**

**输入**（最小化）：
- `.proposal/{feature}/context.json`
- `.proposal/{feature}/1-requirements.md`
- `.proposal/{feature}/2-design.md`
- `.proposal/{feature}/3-api-spec.md`

**执行顺序**：
1. Entity 层
2. DTO/VO 层
3. Mapper 层
4. Service 层
5. Controller 层

**每个文件创建后**：
- 验证编译/构建（根据 context.json 选择命令）
- 更新 `5-tasks.md` 进度

**构建命令选择**：
| buildTool | 命令 |
|-----------|------|
| maven | `mvn compile` |
| gradle | `gradle build` |
| npm | `npm run build` 或 `npm run type-check` |
| pip | `python -m py_compile xxx.py` |
| go | `go build ./...` |

**阶段完成输出**：
```
✅ 编码完成
├── 创建文件: X 个
├── 编译状态: 通过
└── 耗时: Xm Xs

[--step 模式] 是否继续单元测试？(y/n)
```

### Step 2: 单元测试阶段

**调用 unit-test Agent**

**输入**（最小化）：
- `.proposal/{feature}/context.json`
- `.proposal/{feature}/1-requirements.md`
- `.proposal/{feature}/4-test-cases.md`（UT-* 部分）
- 已实现的业务层代码

**执行**：
1. 创建测试文件
2. 运行测试（根据 context.json 选择命令）
3. 如果失败，自动分析并修复（最多 3 次）

**单元测试命令选择**：
| testFramework | 命令 |
|---------------|------|
| JUnit | `mvn test -Dtest=*ServiceTest` |
| pytest | `pytest tests/ -v` |
| Jest | `npm test -- --testPathPattern=Service` |
| Vitest | `npx vitest run` |
| go test | `go test ./... -v` |

**阶段完成输出**：
```
✅ 单元测试完成
├── 测试类: X 个
├── 测试方法: X 个
├── 通过: X 个
├── 失败: 0 个
└── 耗时: Xm Xs

[--step 模式] 是否继续 API 测试？(y/n)
```

### Step 3: API/集成测试阶段

**调用 api-test Agent**

**输入**（最小化）：
- `.proposal/{feature}/context.json`
- `.proposal/{feature}/3-api-spec.md`
- `.proposal/{feature}/4-test-cases.md`（AT-* 部分）
- 已实现的接口层代码

**执行**：
1. 创建测试文件
2. 运行测试（根据 context.json 选择命令）
3. 如果失败，自动分析并修复（最多 3 次）

**API 测试命令选择**：
| 项目类型 | 命令 |
|----------|------|
| backend/java | `mvn test -Dtest=*ControllerTest` |
| backend/python | `pytest tests/test_*_router.py -v` |
| backend/go | `go test ./... -v` |
| frontend/* | `npm run test:e2e` 或 `npx cypress run` |

**阶段完成输出**：
```
✅ API 测试完成
├── 测试类: X 个
├── 测试方法: X 个
├── 通过: X 个
├── 失败: 0 个
└── 耗时: Xm Xs
```

### Step 4: 完成

1. 更新 `5-tasks.md` 所有任务状态
2. 运行全量测试验证
3. 输出最终摘要

---

## 输出

完成后显示：

```
✅ 实现完成：{feature-name}

📊 执行摘要：
├── 编码阶段
│   ├── 创建文件: X 个
│   ├── 修改文件: X 个
│   └── 编译: 通过
├── 单元测试
│   ├── 测试数: X 个
│   └── 通过率: 100%
└── API 测试
    ├── 测试数: X 个
    └── 通过率: 100%

📁 新增文件：
├── src/main/java/.../entity/XxxEntity.java
├── src/main/java/.../dto/XxxDTO.java
├── src/main/java/.../service/XxxService.java
├── src/main/java/.../controller/XxxController.java
├── src/test/java/.../XxxServiceTest.java
└── src/test/java/.../XxxControllerTest.java

👉 下一步：
   1. 代码审查
   2. git add && git commit
   3. 创建 Pull Request
```

---

## 失败处理

### 编译失败

```
❌ 编译失败

错误信息：
[具体错误]

🔧 自动修复中...
[修复操作]

重新编译...
✅ 编译通过
```

### 测试失败

```
❌ 测试失败

失败用例：
- testXxx_Scenario: [错误信息]

🔧 自动修复中...
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
2. 手动修复后重新运行 /apply

最后的错误：
[错误详情]
```

---

## 注意事项

1. **文档完整性**：确保所有文档存在且无 [待确认] 项
2. **最小化输入**：每个 Agent 只读取必要的文档
3. **自动修复**：失败时自动分析并尝试修复
4. **进度追踪**：实时更新 tasks.md 中的任务状态
5. **可恢复**：失败后可以重新运行继续执行
