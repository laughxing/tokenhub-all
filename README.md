# TokenHub 大仓

TokenHub 是一个基于 LiteLLM 的 LLM API 平台，提供统一模型接入、API Key 管理、用量计费、限流和 Web 控制台能力。

本仓库是 TokenHub 的大仓入口，用于统一拉取和管理开发、产品文档、部署相关子仓库。根目录只维护大仓元数据和同步脚本，不包含业务代码。

## 目录结构

| 路径 | 说明 |
|------|------|
| `dev/tokenhub-proxy` | 核心后端：LiteLLM Gateway、Proxy、管理 API |
| `dev/tokenhub-web` | Web 控制台、官网、BFF 层 |
| `dev/tokenhub-e2e` | E2E / Robot Framework 自动化测试 |
| `product/tokenhub-product` | 产品需求、跨仓架构、迭代规划 |
| `deploy/tokenhub-deploy` | K8s、Helm、CI/CD、部署与运维配置 |

## 快速开始

```bash
make help    # 查看可用命令
make sync    # 首次 clone 并 pull 所有子仓库（推荐）
make clone   # 仅克隆尚未存在的子仓库
make pull    # 拉取已克隆子仓库的最新代码
make status  # 查看各子仓库 git 状态
```

默认从 `git@github.com:laughxing/*.git` 拉取子仓库。如需调整组织或 GitHub 域名，可通过环境变量覆盖：

```bash
make sync ORG=your-org GITHUB=github.example.com
```

## 工作方式

实际开发请进入对应子仓库进行。每个子仓库维护独立 Git 历史，提交、测试、构建都应在子仓库目录内执行。

Agent 工作规则见 `AGENTS.md`。跨仓架构和迭代规划见 `product/tokenhub-product/docs/`。

## 架构入口

- 平台架构：`product/tokenhub-product/docs/architecture/llm-api-platform-architecture.md`
- V1 迭代规划：`product/tokenhub-product/docs/iterations/llm-api-platform-v1.md`
- Proxy 实现架构：`dev/tokenhub-proxy/ARCHITECTURE.md`
