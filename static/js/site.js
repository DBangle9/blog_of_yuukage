(() => {
  const toggle = document.querySelector('#theme-toggle');
  const systemDark = window.matchMedia('(prefers-color-scheme: dark)');
  let saved = null;
  try { saved = localStorage.getItem('yuukage-theme'); } catch {}
  function applyTheme(theme) {
    document.documentElement.dataset.theme = theme;
    toggle?.setAttribute('aria-pressed', String(theme === 'dark'));
    toggle?.setAttribute('aria-label', theme === 'dark' ? '切换浅色模式' : '切换深色模式');
  }
  applyTheme(saved || (systemDark.matches ? 'dark' : 'light'));
  if (toggle) {
    toggle.hidden = false;
    toggle.addEventListener('click', () => {
      saved = document.documentElement.dataset.theme === 'dark' ? 'light' : 'dark';
      applyTheme(saved);
      try { localStorage.setItem('yuukage-theme', saved); } catch {}
    });
  }
  systemDark.addEventListener('change', event => { if (!saved) applyTheme(event.matches ? 'dark' : 'light'); });
  if (navigator.clipboard) document.querySelectorAll('.prose pre').forEach(pre => {
    const code = pre.querySelector('code');
    if (!code) return;
    const button = document.createElement('button');
    button.className = 'copy-code'; button.textContent = '复制代码'; button.type = 'button';
    pre.before(button);
    button.addEventListener('click', async () => {
      try { await navigator.clipboard.writeText(code.textContent); button.textContent = '已复制'; }
      catch { button.textContent = '复制失败，请手动选择'; }
      setTimeout(() => { button.textContent = '复制代码'; }, 1800);
    });
  });
  const form = document.querySelector('#search-form');
  if (!form) return;
  const input = document.querySelector('#search-input');
  const status = document.querySelector('#search-status');
  const results = document.querySelector('#search-results');
  let indexPromise;
  let revision = 0;
  const element = (tag, className, text) => {
    const node = document.createElement(tag); node.className = className;
    if (text) node.textContent = text; return node;
  };
  async function search() {
    const current = ++revision;
    const query = input.value.trim().toLocaleLowerCase();
    results.replaceChildren();
    const url = new URL(location.href);
    if (query) url.searchParams.set('q', input.value.trim()); else url.searchParams.delete('q');
    history.replaceState(null, '', url);
    if (!query) { status.textContent = '输入关键词开始搜索。'; return; }
    status.textContent = '正在搜索…';
    try {
      indexPromise ||= fetch('/index.json').then(response => {
        if (!response.ok) throw new Error('Search index unavailable');
        return response.json();
      });
      const index = await indexPromise;
      if (current !== revision) return;
      const words = query.split(/\s+/);
      const matches = index.filter(post => words.every(word =>
        [post.title, post.description, post.content, ...(post.tags || [])].join(' ').toLocaleLowerCase().includes(word)));
      matches.sort((a,b) => b.date.localeCompare(a.date));
      status.textContent = matches.length ? `找到 ${matches.length} 篇文章。` : '没有找到相关记录，试试其他关键词。';
      matches.forEach(post => {
        const row = element('article', 'post-row');
        const date = element('div', 'post-date', post.date);
        const copy = element('div', 'post-copy');
        const heading = element('h3', '');
        const link = element('a', '', post.title); link.href = post.url;
        heading.append(link); copy.append(heading, element('p', '', post.description));
        row.append(date, copy); results.append(row);
      });
    } catch { if (current === revision) { indexPromise = undefined; status.textContent = '搜索暂时不可用，请重试或浏览全部文章。'; } }
  }
  form.addEventListener('submit', event => { event.preventDefault(); search(); });
  let timer;
  input.addEventListener('input', () => { clearTimeout(timer); timer = setTimeout(search, 150); });
  input.value = new URLSearchParams(location.search).get('q') || '';
  if (input.value) search();
})();
