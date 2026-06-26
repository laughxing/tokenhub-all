SHELL := /bin/bash
.PHONY: help clone pull sync status

ORG ?= laughxing
GITHUB ?= github.com

# 仓库清单: 本地路径:远程仓库名
REPOS := \
	dev/tokenhub-proxy:tokenhub-proxy \
	dev/tokenhub-web:tokenhub-web \
	dev/tokenhub-e2e:tokenhub-e2e \
	product/tokenhub-product:tokenhub-product \
	deploy/tokenhub-deploy:tokenhub-deploy

help:
	@echo "TokenHub 大仓管理命令:"
	@echo "  make clone   - 首次克隆所有子仓库"
	@echo "  make pull    - 拉取所有子仓库最新代码"
	@echo "  make sync    - clone 或 pull（推荐）"
	@echo "  make status  - 查看各子仓库 git 状态"
	@echo ""
	@echo "环境变量: ORG=$(ORG)  GITHUB=$(GITHUB)"

clone:
	@for entry in $(REPOS); do \
		path=$${entry%%:*}; \
		name=$${entry#*:}; \
		mkdir -p "$$(dirname "$$path")"; \
		if [ -d "$$path/.git" ]; then \
			echo "==> skip $$path (already cloned)"; \
		elif git ls-remote "git@$(GITHUB):$(ORG)/$$name.git" HEAD >/dev/null 2>&1; then \
			echo "==> clone $$name -> $$path"; \
			git clone "git@$(GITHUB):$(ORG)/$$name.git" "$$path"; \
		else \
			echo "==> skip $$name (remote not found, create git@$(GITHUB):$(ORG)/$$name.git first)"; \
		fi; \
	done

pull:
	@for entry in $(REPOS); do \
		path=$${entry%%:*}; \
		if [ -d "$$path/.git" ]; then \
			echo "==> pull $$path"; \
			git -C "$$path" pull --ff-only; \
		else \
			echo "==> skip $$path (not cloned, run 'make clone')"; \
		fi; \
	done

sync: clone pull

status:
	@for entry in $(REPOS); do \
		path=$${entry%%:*}; \
		name=$${entry#*:}; \
		echo "======== $$name ($$path) ========"; \
		if [ -d "$$path/.git" ]; then \
			git -C "$$path" status -sb; \
		else \
			echo "  (not cloned)"; \
		fi; \
		echo; \
	done
