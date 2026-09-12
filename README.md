# 夕影的blog

以 Hugo 构建的个人博客。文章、项目和关于页构成主要入口；旧站的故事、角色档案和插画保留在创作归档，五篇旧故事的 `/notes/…/` 地址保持不变。

## 本地使用

安装 Hugo **0.147.7**（本项目已使用该版本验证，无需 extended 版）：

```sh
hugo server -D
```

浏览 `http://localhost:1313`。`-D` 会显示草稿，只用于本地预览。正式构建：

```sh
hugo --minify --gc
```

生成文件位于 `public/`。本次改版已附带构建结果，可直接预览或用于 Pages Direct Upload；Git 仓库只需提交源文件。

当前工作区也有 Hugo 工具，可在 PowerShell 执行：

```powershell
K:/try/tools/hugo/hugo.exe server -D
```

## 写一篇文章

```sh
hugo new content posts/my-first-note.md
```

填写标题、描述、日期、分类与标签，写完后将 `draft: true` 改为 `draft: false`。未来日期的文章默认不会发布。`slug` 可以指定简短英文地址，发布后尽量保持不变。

```yaml
---
title: "文章标题"
slug: "my-first-note"
date: 2026-09-12T00:00:00+08:00
draft: false
description: "用一两句话说明读者能从这篇记录中得到什么。"
categories: ["技术实践"]
tags: ["Linux"]
---
```

经验文章建议写清具体问题、环境、处理过程、验证方式与限制。模板里的小标题可以自由删改，不必让每篇杂谈都变成技术报告。

## 个人信息与项目

- `hugo.toml`：站名、简介、作者；填写 `params.github` 后页脚会显示 GitHub 链接。
- `content/about/index.md`：个人介绍；可补充专业、方向与公开联系方式。
- `content/projects/index.md`：真实项目、结果和仓库链接。
- `content/posts/`：博客 Markdown。
- `content/creative/`：旧站五篇创作，不进入博客首页或博客搜索。
- `content/oc/`、`content/gallery/`：角色档案和画廊。

首页介绍在 `layouts/index.html` 中。本版没有编造身份、工作经历、技能熟练度或项目指标；用于简历展示前，应补充真实资料和至少几篇实际经验文章。

## 功能

移动端布局、系统/手动深色模式、正文搜索、标签和分类、文章目录、代码复制、RSS、canonical 和 Open Graph 元数据、404 页面。没有外部字体、第三方追踪或数据库。

博客订阅地址：`https://yuukage.com/posts/index.xml`。搜索仅检索正式博客文章；草稿默认不进入生产搜索索引。为防止误把未审核 HTML 发布，Markdown 中默认禁用原始 HTML。

Cloudflare 部署见 [DEPLOY.md](DEPLOY.md)。旧服务器的 Caddy、systemd 配置未引入新版。

## 素材

旧站插画和表情按原站声明保留。未经许可请勿用于训练、转载或商业用途。首页的书本图形以 SVG 绘制，不使用旧角色素材。
