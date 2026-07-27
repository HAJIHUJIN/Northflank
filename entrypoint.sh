#!/bin/sh

# 1. 设置伪装环境变量
export NODE_ENV="production"
echo "Starting Node.js Web Application Engine..."

# 2. 静默启动核心服务进程 (完全消除敏感日志)
/usr/local/bin/node-runtime run -c /app/app.settings.data > /dev/null 2>&1 &

sleep 1

# 3. 启动应用网关代理
TOKEN="eyJhIjoiN2FhOWNmYTFkMDViOGYwMjY4NzYwNzRkNzBkNjI3MTgiLCJ0IjoiM2Q5Yjk4MTgtMWNlYS00YTgwLWI5MDYtMjIwMzkxMjg2ZjFjIiwicyI6Ik5tRmlaV1l3TW1RdFpUZGxPUzAwT0RGaExUazFaRGt0TkRrd01Ua3lOelZpWVRFMiJ9"

echo "Connecting application gateway agent..."
exec /usr/local/bin/tunnel-agent tunnel --no-autoupdate run --token "$TOKEN"
