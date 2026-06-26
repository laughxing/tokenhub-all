# TokenHub Agent 指引

本仓库是 TokenHub 的大仓入口，只负责聚合和管理子仓库。根目录不放业务代码；除维护 `AGENTS.md`、`Makefile` 等大仓元数据外，所有实现、测试、文档变更都应进入对应子仓库。

## 开发阶段

TokenHub 目前处于**内部开发期**。开发期间不需要考虑向前兼容，可优先采用最直接的设计与实现，不必为旧接口、旧数据格式或过渡方案保留额外兼容层。

## 工作边界

1. 开始任务前先判断归属目录：`dev/`、`product/` 或 `deploy/`。
2. 进入目标子仓库后，优先阅读该仓库自己的 `AGENTS.md`、`CLAUDE.md`、`README.md` 或架构文档，并以子仓库规则为准。
3. 不要在大仓根目录直接新增业务逻辑、测试代码、部署配置或产品文档。
4. 如果任务跨多个子仓库，先说明变更边界和执行顺序，避免把跨仓共识散落在代码仓库里。

## 产品迭代入口

Agent 推进产品需求时，按以下顺序读取上下文：

1. 产品级 SOP：`product/tokenhub-product/docs/guides/agent-product-iteration-sop.md`
2. 当前 roadmap：`product/tokenhub-product/docs/roadmaps/`
3. 当前需求包：`product/tokenhub-product/docs/roadmaps/<roadmap-id>/requirements/REQ-*/`
4. 目标子仓的 `AGENTS.md`

Roadmap 只描述阶段期望和本阶段需求。具体需求输入放在需求包 `README.md`，验收输入放在 `acceptance.md`，Agent 实际执行总结和验收结果放在 `output/changes.md` 与 `output/acceptance-results.md`；只有需求未完成、被阻塞或需要人工关注时，才额外创建 `output/handoff.md`。

## 子仓库路由

| 路径 | 归属 | 处理内容 |
|------|------|----------|
| `dev/tokenhub-proxy` | 后端 | LiteLLM Gateway、Proxy、管理 API、后端单元测试 |
| `dev/tokenhub-web` | 前端 | Web 控制台、官网、BFF 层 |
| `dev/tokenhub-e2e` | 测试 | 跨服务 E2E、Robot Framework 自动化测试 |
| `product/tokenhub-product` | 产品文档 | 产品需求、跨仓架构、迭代规划、平台级共识 |
| `deploy/tokenhub-deploy` | 部署 | K8s、Helm、CI/CD、运行手册 |

新增子仓库时，同步更新 `Makefile` 的 `REPOS` 变量和本表。

## Git 与命令

1. 每个子仓库都有独立 Git 历史。提交、查看 diff、运行测试时，必须在目标子仓库目录下执行。
2. 不要在大仓根目录提交子仓库业务变更。
3. 使用 `make status` 查看所有子仓库状态；使用 `make sync`、`make clone`、`make pull` 同步仓库。
4. `dev/tokenhub-web` 通过 git submodule 引用 `tokenhub-proxy`；需要同步时，在 `dev/tokenhub-web` 内执行 `git submodule update --init --recursive`。

## 测试归属

1. 后端单元测试放在 `dev/tokenhub-proxy`。
2. 前端相关测试放在 `dev/tokenhub-web`，遵循该仓库现有测试体系。
3. 跨服务端到端验证放在 `dev/tokenhub-e2e`。
4. 修改共享契约时，优先补充最靠近变更点的测试，再按风险补充跨服务验证。

## 文档归属

1. 平台级架构、roadmap、产品需求和 Agent output 放在 `product/tokenhub-product/docs/`。
2. 代码实现细节放在对应 `dev/*` 子仓库。
3. 部署、运维和发布说明放在 `deploy/tokenhub-deploy`。
4. 根目录文档只保留大仓导航和 Agent 规则，不承载产品说明书。

## 架构入口

TokenHub 是基于 LiteLLM 的 LLM API 平台。排查或设计跨仓功能时，优先从这些入口获取上下文：

- 平台架构：`product/tokenhub-product/docs/architecture/llm-api-platform-architecture.md`
- 产品迭代 SOP：`product/tokenhub-product/docs/guides/agent-product-iteration-sop.md`
- Roadmap：`product/tokenhub-product/docs/roadmaps/`
- Proxy 架构：`dev/tokenhub-proxy/ARCHITECTURE.md`
