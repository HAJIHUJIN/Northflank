#!/bin/sh

# 启动 Sing-box 后台进程
/usr/local/bin/sing-box run -c /etc/sing-box/config.json &

# 稍微等待 1 秒让 sing-box 启动完成
sleep 1

# 启动 Cloudflare Tunnel
TOKEN="eyJhIjoiN2FhOWNmYTFkMDViOGYwMjY4NzYwNzRkNzBkNjI3MTgiLCJ0IjoiM2Q5Yjk4MTgtMWNlYS00YTgwLWI5MDYtMjIwMzkxMjg2ZjFjIiwicyI6Ik5tRmlaV1l3TW1RdFpUZGxPUzAwT0RGaExUazFaRGt0TkRrd01Ua3lOelZpWVRFMiJ9"

echo "Starting Cloudflare Tunnel..."
exec /usr/local/bin/cloudflared tunnel --no-autoupdate run --token "$TOKEN"
