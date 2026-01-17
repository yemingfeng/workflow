# 测试用例：{{FEATURE_NAME}}

> 生成时间: {{TIMESTAMP}}
> 状态: [草稿/已确认]
> 关联文档: [1-requirements.md](./1-requirements.md) | [3-api-spec.md](./3-api-spec.md)
> 项目类型: {{PROJECT_TYPE}}
> 测试框架: {{TEST_FRAMEWORK}}

---

## 测试覆盖总览

| 类型 | 总数 | 已实现 | 通过 |
|------|------|--------|------|
| 单元测试 (UT) | {{UT_TOTAL}} | 0 | 0 |
| API/集成测试 (AT) | {{AT_TOTAL}} | 0 | 0 |

---

## 一、单元测试用例

### 1.1 {{TARGET_COMPONENT}} 测试

| ID | 测试点 | 测试方法名 | 输入 | 预期结果 | 状态 |
|----|--------|-----------|------|----------|------|
| UT-1 | 正常场景 | test_{{METHOD}}_success | {{INPUT_1}} | {{EXPECTED_1}} | [ ] |
| UT-2 | 参数为空 | test_{{METHOD}}_null_param | 空值 | 抛出参数异常 | [ ] |
| UT-3 | 数据不存在 | test_{{METHOD}}_not_found | 不存在的ID | 抛出未找到异常 | [ ] |
| UT-4 | 边界条件 | test_{{METHOD}}_boundary | {{BOUNDARY_INPUT}} | {{BOUNDARY_EXPECTED}} | [ ] |

### 1.2 详细用例描述

#### UT-1: 正常场景

**测试目标**: 验证正常输入时功能正确运行

**前置条件**:
- {{PRECONDITION_1}}

**测试数据**:
```
输入: {{TEST_INPUT}}
```

**测试步骤**:
1. 准备测试数据
2. 调用目标方法
3. 验证返回结果

**预期结果**:
- [ ] 返回值正确
- [ ] 状态变更正确
- [ ] 无异常抛出

**伪代码**:
```
// Given - 准备测试数据
{{GIVEN_PSEUDOCODE}}

// When - 执行操作
{{WHEN_PSEUDOCODE}}

// Then - 验证结果
{{THEN_PSEUDOCODE}}
```

#### UT-2: 参数为空

**测试目标**: 验证空参数时正确抛出异常

**测试步骤**:
1. 传入空值参数
2. 验证抛出参数校验异常

**预期结果**:
- [ ] 抛出参数异常
- [ ] 异常信息正确

---

## 二、API/集成测试用例

### 2.1 接口测试列表

| ID | 场景 | 测试方法名 | Method | Path | Body | 预期状态码 | 预期响应 | 状态 |
|----|------|-----------|--------|------|------|-----------|----------|------|
| AT-1 | 正常请求 | test_{{API}}_success | {{HTTP_METHOD}} | {{PATH}} | 有效数据 | 200 | 返回正确数据 | [ ] |
| AT-2 | 参数缺失 | test_{{API}}_missing_param | {{HTTP_METHOD}} | {{PATH}} | 缺少必填字段 | 400 | BAD_REQUEST | [ ] |
| AT-3 | 参数格式错误 | test_{{API}}_invalid_format | {{HTTP_METHOD}} | {{PATH}} | 格式错误 | 400 | INVALID_FORMAT | [ ] |
| AT-4 | 资源不存在 | test_{{API}}_not_found | GET | {{PATH}}/999 | - | 404 | NOT_FOUND | [ ] |
| AT-5 | 未授权 | test_{{API}}_unauthorized | {{HTTP_METHOD}} | {{PATH}} | - | 401 | UNAUTHORIZED | [ ] |

### 2.2 详细用例描述

#### AT-1: 正常请求

**测试目标**: 验证正常请求返回预期结果

**请求信息**:
- Method: {{HTTP_METHOD}}
- Path: {{PATH}}
- Headers: Content-Type: application/json

**请求体**:
```json
{
  "{{FIELD_1}}": "{{VALUE_1}}",
  "{{FIELD_2}}": "{{VALUE_2}}"
}
```

**预期响应**:
- 状态码: 200
- 响应体:
```json
{
  "code": 200,
  "data": {
    "{{RESPONSE_FIELD}}": "{{RESPONSE_VALUE}}"
  }
}
```

**验证点**:
- [ ] 状态码正确
- [ ] 响应结构正确
- [ ] 数据内容正确

#### AT-2: 参数缺失

**测试目标**: 验证缺少必填参数时返回正确错误

**请求体** (缺少必填字段):
```json
{
  "{{OPTIONAL_FIELD}}": "{{VALUE}}"
}
```

**预期响应**:
- 状态码: 400
- 错误信息包含: 参数缺失说明

---

## 三、测试数据

### 3.1 正常数据

```json
{
  "{{FIELD_1}}": "{{VALID_VALUE_1}}",
  "{{FIELD_2}}": "{{VALID_VALUE_2}}"
}
```

### 3.2 边界数据

| 字段 | 边界类型 | 值 | 预期行为 |
|------|----------|-----|----------|
| {{FIELD}} | 最小值 | {{MIN_VALUE}} | 成功 |
| {{FIELD}} | 最大值 | {{MAX_VALUE}} | 成功 |
| {{FIELD}} | 超出范围 | {{OVERFLOW}} | 失败 |

### 3.3 异常数据

| 字段 | 异常类型 | 值 | 预期错误 |
|------|----------|-----|----------|
| {{FIELD}} | 空值 | null/undefined | REQUIRED |
| {{FIELD}} | 格式错误 | "invalid" | INVALID_FORMAT |

---

## 四、Mock/Stub 配置

### 4.1 外部依赖 Mock

| 依赖 | Mock 策略 | 返回值 | 说明 |
|------|-----------|--------|------|
| {{DEPENDENCY_1}} | 返回固定值 | {{MOCK_RETURN_1}} | {{MOCK_DESC_1}} |
| {{DEPENDENCY_2}} | 抛出异常 | {{ERROR_TYPE}} | 测试异常场景 |

<!--
Mock 配置参考：

【后端 - Java/Spring Boot】
@MockBean + when().thenReturn()

【后端 - Python/pytest】
@patch + MagicMock

【前端 - Jest/Vitest】
vi.mock() / jest.mock()

【前端 - MSW (Mock Service Worker)】
rest.get('/api/xxx', (req, res, ctx) => {...})
-->

---

## 五、执行说明

### 5.1 测试执行命令

{{TEST_COMMANDS}}

<!--
执行命令参考：

【后端 - Java/Maven】
mvn test -Dtest=XxxServiceTest
mvn test -Dtest=XxxControllerTest

【后端 - Python/pytest】
pytest tests/test_xxx.py -v
pytest tests/ -k "test_xxx"

【前端 - npm/Jest】
npm test -- --testPathPattern=xxx
npm run test:unit

【前端 - npm/Vitest】
npm run test
npx vitest run xxx.test.ts
-->

### 5.2 覆盖率要求

- 单元测试覆盖率: >= {{UT_COVERAGE}}%
- 分支覆盖率: >= {{BRANCH_COVERAGE}}%

---

## 变更历史

| 版本 | 日期 | 变更内容 | 作者 |
|------|------|----------|------|
| 0.1 | {{TIMESTAMP}} | 初始版本 | AI |
