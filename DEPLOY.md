# Cloudflare Pages 部署

本项目是 Hugo 静态博客，使用 Cloudflare Pages 即可，不需要租 VPS 或运行 Caddy。此文档准备部署流程；当前尚未创建远程仓库、修改 DNS 或发布到生产域名。

## 推荐：通过 GitHub 自动构建

1. 创建一个 GitHub 仓库，将本目录的源代码上传。`public/`、缓存和本地工具无需上传，已在 `.gitignore` 排除。
2. 在 Cloudflare 的 **Workers & Pages** 创建 **Pages** 项目，导入该 GitHub 仓库。
3. 配置构建：

| 项目 | 值 |
| --- | --- |
| 生产分支 | `main` |
| 项目根目录 | 当前仓库根目录（如果上传到子目录，需要填写对应路径） |
| 构建命令 | `sh scripts/cloudflare-build.sh` |
| 输出目录 | `public` |
| 环境变量 | `HUGO_VERSION=0.147.7` |

生产和 Preview 环境均填写 Hugo 版本。脚本使生产 canonical 和 RSS 使用 `https://yuukage.com/`，其他分支使用 `CF_PAGES_URL`。如果生产分支不是 `main`，同时修改构建脚本。

4. 完成首次部署，在 `*.pages.dev` 检查首页、文章、搜索、RSS、旧故事与手机显示。
5. 在该 Pages 项目中进入 **Custom domains**，添加 `yuukage.com`。根域名需要该域名所在 zone 已接入同一 Cloudflare 账户，并使用 Cloudflare nameservers。由 Pages 流程创建相应 DNS 记录；如果旧根域名记录冲突，确认新站预览通过后再替换。
6. 如需 `www.yuukage.com`，在 Pages 中另行添加，再按 Cloudflare 官方文档配置到根域名的跳转。
7. 等待域名和证书状态生效，检查 `https://yuukage.com`。保留旧服务器以便回退，迁移不涉及邮件记录。

此后，每次推送 Markdown 修改，Pages 都会重新构建。正式构建默认排除草稿和未来日期文章。

## 备选：先上传构建文件

执行 `hugo --minify --gc`，将 **public 目录里的内容** 通过 Pages **Direct Upload** 上传，或压缩后上传。不要上传 Hugo 源目录作为网页。

Git 集成与 Direct Upload 的项目模式不可随意互换；想以后自动更新，优先选择 Git 集成。两种方式都要在 Pages 项目中绑定域名。

## 上线前检查

- 补充 `content/about/index.md` 的真实个人信息，以及 `hugo.toml` 的 GitHub 链接。
- 确认准备公开旧创作；它们仍可直接访问，并会出现在站点地图与相关标签页。
- 添加几篇真实经验文章和项目说明，避免把改版说明当成全部作品。
- 检查 `public/index.json` 不包含草稿，RSS 地址正确。
- 检查五个旧 `/notes/…/` 地址仍能访问。

## 官方资料

- [Hugo on Cloudflare Pages](https://developers.cloudflare.com/pages/framework-guides/deploy-a-hugo-site/)
- [Pages 自定义域名](https://developers.cloudflare.com/pages/configuration/custom-domains/)
- [Pages Direct Upload](https://developers.cloudflare.com/pages/get-started/direct-upload/)
- [Hugo Windows 安装](https://gohugo.io/installation/windows/)
