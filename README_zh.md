# Conline

[English](README.md) | 简体中文

**Conline** = **C**line + **online** —— [Cline](https://cline.bot) CLI 的 [Wetty](https://github.com/butlerx/wetty) 封装。只要有浏览器，随时随地都能用上 Cline。

## 为什么做这个

[Cline](https://cline.bot) 是很棒的 AI 编程助手，但它跑在终端里；[Wetty](https://github.com/butlerx/wetty) 则能把终端搬进浏览器。Conline 把两者粘在一起：一个容器启动后直接进入 Cline，任何有浏览器的设备都能访问。

- 🌐 平板、Chromebook、公司电脑……打开浏览器就能用 Cline，什么都不用装
- 📦 一个镜像、一条 `docker compose up` —— Cline + Wetty 全部预装
- 💾 工作区保存在命名 Docker 卷中，重启不丢
- 🔒 默认只绑定 `127.0.0.1`，开箱即用也安全

## 快速开始

```bash
git clone https://github.com/zhangtony239/Conline.git
cd Conline
docker compose up -d
```

然后打开 <http://127.0.0.1:13000>，Cline 就在浏览器里了。

> [`compose.yaml`](compose.yaml) 默认使用本地镜像标签 `cline-cli:latest`。请先执行 `docker build -t cline-cli:latest .`，或者拉取下方的已发布镜像并修改 `image:` 字段。

### 使用已发布镜像

镜像由 [GHCR 工作流](.github/workflows/build-ghcr.yml) 构建发布：

```yaml
services:
  cline-cli:
    image: cline-cli:latest
    container_name: cline-cli
    restart: unless-stopped
    ports:
      - "127.0.0.1:13000:3000"
    volumes:
      - ./workspace:/workspace
      - cline-data:/root/.cline/data

volumes:
  cline-data:

```

### 自行构建

```bash
docker build -t cline-cli:latest .
docker compose up -d
```

## 许可证

[MIT](LICENSE)
