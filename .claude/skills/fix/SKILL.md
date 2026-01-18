---
name: fix
description: 定点修复。根据问题描述定位并修复代码问题。当用户报告 Bug、错误、测试失败时使用。触发词：修复、fix、bug、错误、失败。
---

# /fix - 定点修复

## 描述

根据用户提供的详细问题信息，定位并修复代码问题。

**模式**：Auto 模式（快速定位修复）

---

## 前置信息收集

```bash
echo "=== 当前 Git 状态 ==="
git status --short 2>/dev/null

echo ""
echo "=== 最近提交 ==="
git log --oneline -5 2>/dev/null

echo ""
echo "=== 最近修改的文件 ==="
git diff --name-only HEAD~3 2>/dev/null | head -10
```

---

## 参数

- `$ARGUMENTS`：问题描述（越详细越好）

**推荐包含**：
- 错误信息/异常堆栈
- 复现步骤
- 期望行为 vs 实际行为
- 相关日志
- 涉及的文件或接口

**示例**：
```
/fix 用户注册接口返回500错误，日志显示 NullPointerException at UserService.java:42

/fix 登录接口密码校验不生效，任意密码都能登录成功。接口路径 POST /api/users/login

/fix 单元测试 UserServiceTest.testRegister_EmailExists 失败，报错信息：expected EMAIL_EXISTS but was null
```

---

## 执行流程

### Step 1: 解析问题

从用户描述中提取：
- **错误类型**：异常/逻辑错误/测试失败
- **错误位置**：文件名、行号、方法名
- **错误信息**：异常信息、日志内容
- **业务场景**：什么操作触发的问题

### Step 2: 定位代码

```bash
# 如果有文件和行号
cat -n src/main/java/.../UserService.java | sed -n '35,50p'

# 如果只有类名
find src -name "UserService.java" -exec cat -n {} \;

# 如果是接口问题
grep -r "POST /api/users/login" src/
```

### Step 3: 分析根因

常见问题类型：

| 问题类型 | 可能原因 | 检查点 |
|----------|----------|--------|
| NullPointerException | 未做空值检查 | 返回值、参数 |
| 逻辑错误 | 条件判断错误 | if/else 逻辑 |
| 测试失败 | 实现与预期不符 | 断言值、Mock 配置 |
| 编译错误 | 语法/类型错误 | import、类型匹配 |

### Step 4: 修复代码

1. 使用 Edit 工具修复问题代码
2. 保持最小改动原则
3. 不引入新问题

### Step 5: 验证修复

```bash
# 编译验证
mvn compile

# 运行相关测试
mvn test -Dtest=XxxServiceTest#testXxx

# 如果是 API 问题，运行 API 测试
mvn test -Dtest=XxxControllerTest#testXxx
```

### Step 6: 如果验证失败

- 分析新的错误信息
- 调整修复方案
- 重新验证
- 最多重试 3 次

---

## 输出

### 修复成功

```
🔧 修复完成

📋 问题分析：
├── 问题类型: NullPointerException
├── 错误位置: UserService.java:42
├── 根本原因: userMapper.findById() 返回 null 未处理
└── 影响范围: 用户查询功能

🛠 修复内容：
├── 文件: src/main/java/.../UserService.java
├── 修改: 添加 Optional 处理，返回 null 时抛出 UserNotFoundException
└── 行数: 42-45

✅ 验证结果：
├── 编译: 通过
├── 相关测试: UserServiceTest (5/5 通过)
└── 回归测试: 无新增失败

📝 建议：
- 考虑在其他类似场景添加空值检查
- 补充测试用例覆盖此场景
```

### 修复失败

```
❌ 修复失败（已重试 3 次）

📋 问题分析：
├── 问题类型: [类型]
├── 错误位置: [位置]
└── 尝试的修复: [修复内容]

🚫 失败原因：
[详细原因]

💡 建议：
1. 检查 [具体建议]
2. 可能需要 [进一步操作]

📎 相关文件：
- [文件列表]
```

---

## 常见问题修复模式

### NullPointerException

```java
// 问题代码
User user = userMapper.findById(id);
return user.getName(); // NPE

// 修复后
User user = userMapper.findById(id);
if (user == null) {
    throw new UserNotFoundException(id);
}
return user.getName();

// 或使用 Optional
return userMapper.findById(id)
    .map(User::getName)
    .orElseThrow(() -> new UserNotFoundException(id));
```

### 逻辑错误

```java
// 问题代码
if (password.equals(user.getPassword())) { // 明文比较

// 修复后
if (passwordEncoder.matches(password, user.getPassword())) { // 加密比较
```

### 测试失败

```java
// 问题：Mock 未配置
when(userMapper.existsByEmail(anyString())).thenReturn(false); // 添加

// 问题：断言值错误
assertEquals("EMAIL_EXISTS", ex.getMessage()); // 检查实际值
```

---

## 注意事项

1. **信息越详细越好**：错误信息、日志、堆栈都有帮助
2. **最小改动**：只修复问题，不做额外重构
3. **验证必须**：修复后必须运行相关测试
4. **记录问题**：如果是常见错误，考虑记录到 CLAUDE.md
5. **多次失败求助**：超过 3 次失败，建议人工介入
6. **用户通知**：需要人工介入时，发送系统通知

---

## 用户通知

**通知规则**：只要需要用户确认或输入，就发送系统通知。

```bash
# macOS
osascript -e 'display notification "修复需要您的介入" with title "AI Workflow - Fix" sound name "Ping"'

# Linux
notify-send "AI Workflow - Fix" "修复需要您的介入"
```
