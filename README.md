# 夕影的blog

你说得对，但是yuukage-blog是夕影使用Hugo构建的个人博客。这里很有用，比如说，blog会教你怎么安装Arch Linux。

## 如何本地使用Hugo搭建自己的blog

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

## 如何发布你的文章

```sh
hugo new content posts/my-first-note.md
```

填写标题、描述、日期、分类与标签，写完后将 `draft: true` 改为 `draft: false`。未来日期的文章默认不会发布。`slug` 可以指定简短英文地址，发布后尽量保持不变。

```yaml
---
title: "文章标题"
slug: "请输入文本"
date: 2026-09-12T11:45:14+08:00
draft: false
description: "可以用一两句话说明读者能从这篇记录中得到什么。"
categories: ["输入分类"]
tags: ["添加tag"]
---
```

正文写在tags底下就可以了

## 本站的结构

- `hugo.toml`：站名、简介、作者；填写 `params.github` 后页脚会显示 GitHub 链接。
- `content/about/index.md`：个人介绍；可补充专业、方向与公开联系方式。
- `content/projects/index.md`：真实项目、结果和仓库链接。
- `content/posts/`：博客 Markdown。
- `content/creative/`：旧站五篇创作，不进入博客首页或博客搜索。（可以在“关于”里找到“旧站”，从那里进去）
- `content/oc/`、`content/gallery/`：角色档案和画廊。

首页介绍在 `layouts/index.html` 中。现阶段还是一个半成品捏

## 功能

移动端布局、系统/手动深色模式、正文搜索、标签和分类、文章目录、代码复制、RSS、canonical 和 Open Graph 元数据、404 页面。没有外部字体、第三方追踪或数据库。

博客订阅地址：`https://yuukage.com/posts/index.xml`。搜索仅检索正式博客文章；草稿默认不进入生产搜索索引。为防止误把未审核 HTML 发布，Markdown 中默认禁用原始 HTML。

Cloudflare 部署见 [DEPLOY.md](DEPLOY.md)。旧服务器的 Caddy、systemd 配置未引入新版。

## 素材

旧站插画，背景和和表情是我的个人认识图，来源于米画师约稿。未经许可请勿用于训练、转载或商业用途。
