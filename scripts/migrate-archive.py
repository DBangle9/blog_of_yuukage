from pathlib import Path
import re
import shutil
import html

root = Path(__file__).resolve().parents[1]
original = root.parent / 'yuukage.com-20260714'
built = root.parent / 'yuukage-original-build'
urls = {}
for page in (built / 'notes').glob('*/index.html'):
    title = re.search(r'<title>(.*?)</title>', page.read_text(encoding='utf-8'))
    if title:
        urls[html.unescape(title.group(1)).split(' · ')[0]] = '/notes/' + page.parent.name + '/'
for source in (original / 'content/posts').glob('*.md'):
    if source.name == '_index.md':
        continue
    text = source.read_text(encoding='utf-8')
    title = re.search(r'^title: "(.*?)"', text, re.M).group(1)
    if title not in urls:
        raise ValueError(f'Missing old permalink: {title}')
    text = text.replace('---\n', f'---\nurl: "{urls[title]}"\n', 1)
    (root / 'content/creative' / source.name).write_text(text, encoding='utf-8')
shutil.copytree(original / 'static/images', root / 'static/images', dirs_exist_ok=True)
print(f'Migrated {len(urls)} original post URLs and images.')
