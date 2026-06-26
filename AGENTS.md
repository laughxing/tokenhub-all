# TokenHub 大仓 (tokenhub-all)

## 概述

本仓库是 **TokenHub 大仓（Monorepo Meta-Repository）**，用于统一拉取和管理工作区内所有相关子仓库，按 **开发（dev）、产品文档（product）、部署（deploy）** 分类组织。

TokenHub 是一个 LLM API 平台，基于 LiteLLM 构建 AI Gateway，提供统一的模型接入、API Key 管理、用量计费、限流等能力。

> 本仓库根目录**不包含业务代码**，只维护大仓元数据（`AGENTS.md`、`Makefile` 等）。实际开发请在对应子仓库目录下进行。

## 目录分类

| 分类 | 用途 |
|------|------|
| `dev/` | 开发相关：核心服务、Web 控制台、E2E / Robot 自动化测试 |
| `product/` | 产品文档系统（面向产品、运营、跨仓架构与迭代规划，非代码仓库） |
| `deploy/` | 部署与运维配置 |

## 子仓库清单

| 本地路径 | 远程仓库 | 分类 | 说明 |
|----------|----------|------|------|
| `dev/tokenhub-proxy` | [tokenhub-proxy](https://github.com/laughxing/tokenhub-proxy) | 开发 | 核心后端：LiteLLM Gateway、Proxy、管理 API |
| `dev/tokenhub-web` | [tokenhub-web](https://github.com/laughxing/tokenhub-web) | 开发 | Web 控制台、官网、BFF 层 |
| `dev/tokenhub-e2e` | [tokenhub-e2e](https://github.com/laughxing/tokenhub-e2e) | 开发 | E2E / Robot Framework 自动化测试 |
| `product/tokenhub-product` | [tokenhub-product](https://github.com/laughxing/tokenhub-product) | 产品文档 | 产品文档、跨仓架构、需求与迭代规划 |
| `deploy/tokenhub-deploy` | [tokenhub-deploy](https://github.com/laughxing/tokenhub-deploy) | 部署 | 部署配置、K8s/Helm、CI/CD |

新增子仓库时，同步更新 `Makefile` 中的 `REPOS` 变量和本表。

## 快速开始

```bash
make help    # 查看可用命令
make sync    # 首次 clone 并 pull 所有子仓库（推荐）
make clone   # 仅克隆尚未存在的子仓库
make pull    # 拉取已克隆子仓库的最新代码
make status  # 查看各子仓库 git 状态
```

## Agent 工作指引

1. **先确认目标子仓库** — 改代码前明确属于 dev / product / deploy 哪一类，进入对应目录工作。
2. **子仓库独立 Git 历史** — 每个子目录有自己的 `.git`，`git commit` 需在子仓库目录下执行，而非大仓根目录。
3. **架构与规范** — 平台级架构和阶段规划见 `product/tokenhub-product/docs/`；Proxy 实现架构见 `dev/tokenhub-proxy/ARCHITECTURE.md`；开发规范见各子仓库的 `AGENTS.md` / `CLAUDE.md`。
4. **Submodule 注意** — `dev/tokenhub-web` 通过 git submodule 引用 `tokenhub-proxy`；同步 submodule 时在 `tokenhub-web` 目录执行 `git submodule update --init --recursive`。
5. **测试代码归属** — 单元测试保留在 `dev/tokenhub-proxy` 内；跨服务 E2E / Robot 自动化测试放在 `dev/tokenhub-e2e`。
6. **文档归属** — 跨仓共识放 `product/tokenhub-product`，代码实现细节放对应 `dev/*` 子仓库，部署运行手册放 `deploy/tokenhub-deploy`，大仓根目录只放导航和规则。
7. **大仓根目录职责** — 仅维护仓库清单、拉取脚本和 Agent 指引，不在此直接修改业务逻辑。

## 架构概览

```text
User / SDK
  -> APISIX（边缘网关）
  -> LiteLLM Proxy（dev/tokenhub-proxy）
  -> upstream model providers

Browser
  -> APISIX
  -> Web Console / BFF（dev/tokenhub-web）
  -> LiteLLM management APIs
```

- **APISIX**：TLS、路由、CORS、WAF、限流等边缘能力
- **LiteLLM（tokenhub-proxy）**：虚拟 API Key、组织/团队、预算、用量、模型路由
- **Web Console（tokenhub-web）**：产品层 UI，封装 LiteLLM 管理 API
- **E2E 测试（tokenhub-e2e）**：端到端与 Robot 自动化测试，验证 Proxy + Web 集成行为

详细平台架构决策见 `product/tokenhub-product/docs/architecture/llm-api-platform-architecture.md`。
