# Conline

[English](README.md) | 简体中文

**Conline** = **C**line + **online** —— [Cline](https://cline.bot) CLI 的 [Wetty](https://github.com/butlerx/wetty) 封装。只要有浏览器，随时随地都能用上 Cline。

## 为什么做这个

[Cline](https://cline.bot) 是很棒的 AI 编程助手，但它跑在终端里；[Wetty](https://github.com/butlerx/wetty) 则能把终端搬进浏览器。Conline 把两者粘在一起：一个容器启动后直接进入 Cline，任何有浏览器的设备都能访问。

- 🌐 平板、Chromebook、公司电脑……打开浏览器就能用 Cline，什么都不用装
- 📦 一个镜像、一条 `docker compose up` —— Cline + Wetty 全部预装
- 💾 工作区保存在命名 Docker 卷中，重启不丢
- 🖥️ Cline 跑在 tmux 会话里：关掉浏览器任务照常继续，回来自动接回现场
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

## 任务不中断（tmux 持久化）

Cline 不是直接跑在 Wetty 的伪终端里，而是跑在一个持久化的 [tmux](https://github.com/tmux/tmux) 会话（默认名为 `conline`）中：

- **关掉浏览器 ≠ 任务中断** —— 浏览器断开只会断开 tmux *客户端*，Cline 在容器里继续跑
- **回来自动恢复** —— 重新打开 <http://127.0.0.1:13000> 会自动接回原来的会话，任务现场和完整输出历史都在
- **多端同看** —— 多个浏览器标签页/设备可以同时接进同一会话（镜像视图）
- **接管现场** —— 也可以不走浏览器，直接进容器看：

  ```bash
  docker exec -it cline-cli tmux attach -t conline
  ```

  （在 tmux 里按 `Ctrl-b` 然后 `d` 只是脱离，任务继续运行。）

会话名和会话内运行的命令都可以用环境变量覆盖：

```yaml
    environment:
      - CONLINE_TMUX_SESSION=conline   # tmux 会话名
      - CONLINE_TMUX_COMMAND=cline     # 会话内运行的命令
```

> ⚠️ 边界说明：持久化覆盖的是**浏览器断开/刷新**以及 Wetty 进程重启的场景。如果执行 `docker compose down` 或重启容器，容器内的进程（包括正在跑的任务）会被终止——工作区和 Cline 数据仍保存在卷中，不会丢失。

## 许可证

[MIT](LICENSE)
