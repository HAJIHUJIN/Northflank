#!/bin/sh

# 设置伪装环境变量
export NODE_ENV="production"
echo "Starting Node.js Web Application Engine..."

# 启动 Sing-box，并记录日志到控制台（避免报错被隐藏）
echo "Launching runtime core..."
/usr/local/bin/node-runtime run -c /app/app.settings.data &

# 等待 2 秒确保 runtime 成功绑定 8080 端口
sleep 2

# 启动 Cloudflare Tunnel Agent
TOKEN="eyJhIjoiN2FhOWNmYTFkMDViOGYwMjY4NzYwNzRkNzBkNjI3MTgiLCJ0IjoiM2Q5Yjk4MTgtMWNlYS00YTgwLWI5MDYtMjIwMzkxMjg2ZjFjIiwicyI6Ik5tRmlaV1l3TW1RdFpUZGxPUzAwT0RGaExUazFaRGt0TkRrd01Ua3lOelZpWVRFMiJ9"

echo "Connecting application gateway agent..."
exec /usr/local/bin/tunnel-agent tunnel --no-autoupdate run --token "$TOKEN"
