#!/bin/sh
# 在本服务器上重新构建并发布到 nginx 站点目录
set -eu
cd "$(dirname "$0")/.."
BASE_URL="${BASE_URL:-http://64.83.48.226/}"
DEST="${DEST:-/www/wwwroot/yuukage}"
hugo --minify --gc --baseURL "$BASE_URL" -d "$DEST" --cleanDestinationDir
echo "已发布到 $DEST（$BASE_URL）"
