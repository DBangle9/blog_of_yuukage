from pathlib import Path
from zipfile import ZipFile, ZIP_DEFLATED
from html.parser import HTMLParser
from urllib.parse import urlsplit, unquote

root = Path(__file__).resolve().parents[1]
public = root / 'public'

class Links(HTMLParser):
    def handle_starttag(self, tag, attrs):
        for name, value in attrs:
            if name in ('href', 'src') and value and value.startswith('/') and not value.startswith('//'):
                target = public / unquote(urlsplit(value).path).lstrip('/')
                if not target.exists():
                    raise AssertionError(f'Broken local link: {value}')

for file in public.rglob('*.html'):
    Links().feed(file.read_text(encoding='utf-8'))

with ZipFile(root.parent / 'yuukage-blog-source.zip', 'w', ZIP_DEFLATED) as archive:
    for file in root.rglob('*'):
        if not file.is_file():
            continue
        relative = file.relative_to(root)
        if relative.parts[0] in ('public', 'resources', 'qa', '.git', 'node_modules') or file.name == '.hugo_build.lock':
            continue
        archive.write(file, Path('yuukage-blog') / relative)

with ZipFile(root.parent / 'yuukage-blog-cloudflare-upload.zip', 'w', ZIP_DEFLATED) as archive:
    for file in public.rglob('*'):
        if file.is_file():
            archive.write(file, file.relative_to(public))

print('All generated local links exist. Source and Cloudflare upload ZIPs created.')
