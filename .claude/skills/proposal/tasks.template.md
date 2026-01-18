# 任务清单：{{FEATURE_NAME}}

> 生成时间: {{TIMESTAMP}}
> 状态: [待开始/进行中/已完成]
> 项目类型: {{PROJECT_TYPE}}
> 关联文档:
> - [需求](./1-requirements.md)
> - [设计](./2-design.md)
> - [API](./3-api-spec.md)
> - [测试用例](./4-test-cases.md)

---

## 进度总览

| 阶段 | 总任务 | 已完成 | 进度 |
|------|--------|--------|------|
| 编码 | {{CODE_TOTAL}} | 0 | 0% |
| 单元测试 | {{UT_TOTAL}} | 0 | 0% |
| 集成/API测试 | {{AT_TOTAL}} | 0 | 0% |
| 验证 | {{VERIFY_TOTAL}} | 0 | 0% |

---

## 一、编码任务

### 1.1 数据层

| ID | 任务 | 文件路径 | 状态 | 备注 |
|----|------|----------|------|------|
| C-1 | {{DATA_TASK_1}} | `{{DATA_FILE_1}}` | [ ] | {{DATA_NOTE_1}} |
| C-2 | {{DATA_TASK_2}} | `{{DATA_FILE_2}}` | [ ] | {{DATA_NOTE_2}} |

<!--
数据层参考：

【后端】Entity、Model、Schema、DTO/VO
【前端】Interface/Type、State定义、Store
-->

### 1.2 业务层

| ID | 任务 | 文件路径 | 状态 | 备注 |
|----|------|----------|------|------|
| C-3 | {{BIZ_TASK_1}} | `{{BIZ_FILE_1}}` | [ ] | {{BIZ_NOTE_1}} |
| C-4 | {{BIZ_TASK_2}} | `{{BIZ_FILE_2}}` | [ ] | {{BIZ_NOTE_2}} |

<!--
业务层参考：

【后端】Service、Repository/Mapper、Middleware
【前端】Hook (React)、Composable (Vue)、Utils
-->

### 1.3 接口层

| ID | 任务 | 文件路径 | 状态 | 备注 |
|----|------|----------|------|------|
| C-5 | {{API_TASK_1}} | `{{API_FILE_1}}` | [ ] | {{API_NOTE_1}} |
| C-6 | {{API_TASK_2}} | `{{API_FILE_2}}` | [ ] | {{API_NOTE_2}} |

<!--
接口层参考：

【后端】Controller、Router、Handler、API Endpoint
【前端】Page、View、Component、API Client
-->

---

## 二、测试任务

### 2.1 单元测试

| ID | 任务 | 文件路径 | 依赖 | 状态 | 备注 |
|----|------|----------|------|------|------|
| T-1 | {{UT_TASK_1}} | `{{UT_FILE_1}}` | {{UT_DEP_1}} | [ ] | |
| T-2 | {{UT_TASK_2}} | `{{UT_FILE_2}}` | {{UT_DEP_2}} | [ ] | |

### 2.2 集成/API 测试

| ID | 任务 | 文件路径 | 依赖 | 状态 | 备注 |
|----|------|----------|------|------|------|
| T-3 | {{AT_TASK_1}} | `{{AT_FILE_1}}` | {{AT_DEP_1}} | [ ] | |
| T-4 | {{AT_TASK_2}} | `{{AT_FILE_2}}` | {{AT_DEP_2}} | [ ] | |

---

## 三、验证任务

| ID | 任务 | 命令 | 依赖 | 状态 | 结果 |
|----|------|------|------|------|------|
| V-1 | 构建检查 | `{{BUILD_COMMAND}}` | C-* | [ ] | |
| V-2 | 单元测试 | `{{UT_COMMAND}}` | T-1,T-2 | [ ] | |
| V-3 | 集成测试 | `{{AT_COMMAND}}` | T-3,T-4 | [ ] | |
| V-4 | 全量测试 | `{{FULL_TEST_COMMAND}}` | T-* | [ ] | |

<!--
验证命令参考：

【Java/Maven】
- 构建: mvn compile
- 单元测试: mvn test -Dtest=*ServiceTest
- API测试: mvn test -Dtest=*ControllerTest
- 全量: mvn test

【Python/pip】
- 构建: python -m py_compile xxx.py
- 测试: pytest tests/ -v

【Node/npm】
- 构建: npm run build
- 单元测试: npm run test:unit
- E2E测试: npm run test:e2e
- 全量: npm test

【Go】
- 构建: go build ./...
- 测试: go test ./...
-->

---

## 四、任务依赖图

```
数据层 (C-1, C-2)
    │
    ▼
业务层 (C-3, C-4)
    │
    ├──→ 单元测试 (T-1, T-2)
    │
    ▼
接口层 (C-5, C-6)
    │
    ├──→ 集成测试 (T-3, T-4)
    │
    ▼
验证阶段 (V-1 → V-2 → V-3 → V-4)
```

---

## 五、执行日志

### {{DATE}}

| 时间 | 任务 | 操作 | 结果 |
|------|------|------|------|
| {{TIME}} | {{TASK_ID}} | {{ACTION}} | {{RESULT}} |

---

## 六、问题记录

| ID | 问题描述 | 发现时间 | 状态 | 解决方案 |
|----|----------|----------|------|----------|
| P-1 | {{ISSUE_DESC}} | {{TIME}} | [待解决/已解决] | {{SOLUTION}} |

---

## 变更历史

| 版本 | 日期 | 变更内容 | 作者 |
|------|------|----------|------|
| 0.1 | {{TIMESTAMP}} | 初始版本 | AI |
