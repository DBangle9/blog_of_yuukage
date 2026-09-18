<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:atom="http://www.w3.org/2005/Atom">
  <xsl:output method="html" encoding="UTF-8" doctype-system="about:legacy-compat" />
  <xsl:template match="/">
    <html lang="zh-CN">
      <head>
        <meta name="viewport" content="width=device-width,initial-scale=1" />
        <title><xsl:value-of select="rss/channel/title" /> · RSS</title>
        <link rel="icon" href="/favicon.png" type="image/png" />
        <style>
          :root{color-scheme:light dark;--bg:#f6f4ee;--paper:#faf8f3;--ink:#292b26;--muted:#73766d;--line:#dadcd1;--accent:#b64f32;--soft:#efeee6}
          *{box-sizing:border-box}
          html{background:var(--bg)}
          body{margin:0;background:var(--bg);color:var(--ink);font-family:-apple-system,BlinkMacSystemFont,"Segoe UI","Microsoft YaHei",sans-serif;line-height:1.75}
          a{color:inherit;text-decoration:none}
          a:hover{color:var(--accent)}
          a:focus-visible{outline:2px solid var(--accent);outline-offset:5px}
          ::selection{background:var(--accent);color:var(--bg)}
          .wrap{width:min(920px,calc(100% - 48px));margin-inline:auto}
          header{display:flex;align-items:center;justify-content:space-between;padding:32px 0 24px;border-bottom:1px solid var(--line)}
          .brand{display:flex;align-items:center;gap:12px;font-size:18px;font-weight:650;line-height:1.2}
          .brand img{width:42px;height:45px;object-fit:contain}
          .brand small{display:block;margin-top:6px;color:var(--muted);font:9px/1 Consolas,monospace;letter-spacing:2px}
          .back{font-size:12px;color:var(--muted)}
          .hero{display:grid;grid-template-columns:1fr 220px;gap:48px;align-items:center;padding:70px 0 62px}
          .eyebrow{margin:0 0 14px;color:var(--accent);font:10px/1.5 Consolas,monospace;letter-spacing:2px}
          h1{margin:0 0 20px;font-family:Georgia,"Songti SC",SimSun,serif;font-size:clamp(34px,6vw,54px);font-weight:500;line-height:1.35;letter-spacing:-1px}
          .lead{max-width:610px;margin:0;color:var(--muted);font-size:14px}
          .rss-art{position:relative;display:grid;place-items:center;width:190px;height:190px;margin:auto;border:1px solid var(--line);border-radius:50%;background:radial-gradient(circle at center,var(--paper) 0 38%,transparent 39%),repeating-radial-gradient(circle at center,transparent 0 22px,var(--line) 23px 24px)}
          .rss-art:before{content:"";width:82px;height:82px;border-radius:18px;background:var(--accent);transform:rotate(-8deg);box-shadow:9px 10px 0 var(--soft)}
          .rss-art span{position:absolute;color:var(--bg);font:700 24px/1 Consolas,monospace;transform:rotate(-8deg)}
          .subscribe{display:grid;grid-template-columns:1fr auto;gap:14px;align-items:center;padding:19px 22px;margin-bottom:55px;border:1px solid var(--line);background:var(--soft)}
          .subscribe p{margin:0;color:var(--muted);font-size:12px;overflow-wrap:anywhere}
          .subscribe code{color:var(--ink);font:12px/1.7 Consolas,monospace}
          .subscribe strong{color:var(--accent);font:28px/1 Georgia,serif;font-weight:500}
          .section-head{display:flex;align-items:end;justify-content:space-between;padding-bottom:13px;border-bottom:1px solid var(--line)}
          .section-head h2{margin:0;font:500 25px/1.3 Georgia,"Songti SC",SimSun,serif}
          .section-head span{color:var(--muted);font:10px/1.5 Consolas,monospace;letter-spacing:1px}
          .item{display:grid;grid-template-columns:105px 1fr 24px;gap:24px;padding:30px 0;border-bottom:1px solid var(--line)}
          .date{color:var(--muted);font:10px/1.7 Consolas,monospace}
          .item h3{margin:0 0 8px;font-size:20px;font-weight:550;line-height:1.5}
          .description{max-width:670px;color:var(--muted);font-size:13px;display:-webkit-box;-webkit-line-clamp:3;-webkit-box-orient:vertical;overflow:hidden}
          .description p{margin:0}
          .arrow{padding-top:7px;color:var(--muted);font-size:19px}
          .tags{display:flex;flex-wrap:wrap;gap:7px;margin-top:13px}
          .tags span{padding:2px 8px;border:1px solid var(--line);border-radius:3px;color:var(--muted);font-size:10px}
          footer{display:flex;justify-content:space-between;gap:20px;margin-top:65px;padding:28px 0 42px;border-top:1px solid var(--line);color:var(--muted);font-size:11px}
          @media(prefers-color-scheme:dark){:root{--bg:#20231f;--paper:#282c26;--ink:#e8e8dc;--muted:#b0b5a7;--line:#42483c;--accent:#ea9875;--soft:#2d322a}}
          @media(max-width:650px){.wrap{width:calc(100% - 36px)}header{padding-top:22px}.hero{grid-template-columns:1fr;padding:46px 0 38px}.rss-art{display:none}.subscribe{grid-template-columns:1fr}.subscribe strong{display:none}.item{grid-template-columns:75px 1fr 16px;gap:12px}.item h3{font-size:17px}.section-head h2{font-size:22px}footer{flex-direction:column}}
        </style>
      </head>
      <body>
        <header class="wrap">
          <a class="brand" href="/"><img src="/images/stamp-no.webp" alt="" /><span>夕影的blog<small>YUUKAGE.COM</small></span></a>
          <a class="back" href="/posts/">返回文章列表 →</a>
        </header>
        <main class="wrap">
          <section class="hero">
            <div>
              <p class="eyebrow">RSS / REALLY SIMPLE SYNDICATION</p>
              <h1>订阅夕影的<br />最新记录。</h1>
              <p class="lead">把下面的订阅地址添加到你的 RSS 阅读器，新文章发布后就能在那里看到。这个页面同时也是一份可以直接阅读的文章清单。</p>
            </div>
            <div class="rss-art" aria-hidden="true"><span>RSS</span></div>
          </section>
          <section class="subscribe" aria-label="订阅地址">
            <p>订阅地址<br /><code><xsl:value-of select="rss/channel/atom:link/@href" /></code></p>
            <strong><xsl:value-of select="count(rss/channel/item)" /></strong>
          </section>
          <section>
            <div class="section-head"><h2>最近的文章</h2><span><xsl:value-of select="count(rss/channel/item)" /> ITEMS IN THIS FEED</span></div>
            <xsl:for-each select="rss/channel/item">
              <article class="item">
                <div class="date"><xsl:value-of select="substring(pubDate,6,11)" /></div>
                <div>
                  <h3><a href="{link}"><xsl:value-of select="title" /></a></h3>
                  <div class="description"><xsl:value-of select="description" disable-output-escaping="yes" /></div>
                  <div class="tags"><xsl:for-each select="category"><span><xsl:value-of select="." /></span></xsl:for-each></div>
                </div>
                <a class="arrow" href="{link}" aria-label="阅读文章">↗</a>
              </article>
            </xsl:for-each>
          </section>
        </main>
        <footer class="wrap"><span>© 2026 Yuukage · 夕影的blog</span><span>标准 RSS 2.0 Feed</span></footer>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
