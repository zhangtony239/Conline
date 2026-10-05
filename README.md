# Conline

English | [简体中文](README_zh.md)

**Conline** = **C**line + **online** — a [Wetty](https://github.com/butlerx/wetty) wrapper around the [Cline](https://cline.bot) CLI. Open any browser, and Cline is right there.

## Why

[Cline](https://cline.bot) is a great AI coding agent, but it lives in the terminal. [Wetty](https://github.com/butlerx/wetty) serves a terminal over HTTP. Conline glues them together: a single container that boots straight into Cline, accessible from any device with a browser.

- 🌐 Use Cline from a tablet, Chromebook, or work machine without installing anything
- 📦 One image, one `docker compose up` — Cline + Wetty preinstalled
- 💾 Workspace persisted in a named Docker volume
- 🔒 Bound to `127.0.0.1` by default — safe for local use out of the box

## Quick Start

```bash
git clone https://github.com/zhangtony239/Conline.git
cd Conline
docker compose up -d
```

Then open <http://127.0.0.1:13000> — you're in Cline.

> The compose file builds from the local [`Dockerfile`](Dockerfile) image tag `cline-cli:latest`. Run `docker build -t cline-cli:latest .` first, or pull the published image (see below) and adjust the `image:` field.

### Use the published image

Images are built by the [GHCR workflow](.github/workflows/build-ghcr.yml):

```yaml
services:
  cline-cli:
    image: ghcr.io/zhangtony239/conline:latest
    container_name: cline-cli
    restart: unless-stopped
    ports:
      - "127.0.0.1:13000:3000"
    volumes:
      - cline:/workspace

volumes:
  cline:
```

### Build it yourself

```bash
docker build -t cline-cli:latest .
docker compose up -d
```

## Configuration

| Item | Default | Notes |
| --- | --- | --- |
| HTTP port | `127.0.0.1:13000` → `3000` | Change the left side of `ports` in [`compose.yaml`](compose.yaml) |
| Workspace | named volume `cline` mounted at `/workspace` | Your project files live here |
| Startup command | `cline` | Set by `CMD` in the [`Dockerfile`](Dockerfile) |

To expose the service beyond localhost (e.g. on a LAN), change the port mapping to `"13000:3000"` — **add your own authentication in front of it first** (reverse proxy with auth, VPN, etc.), since Wetty itself does not require a login.

## License

[MIT](LICENSE)
