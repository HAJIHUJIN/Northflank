# 第一阶段：借用官方 Sing-box 和 Cloudflared 镜像直接提取文件（保证100%存在）
FROM ghcr.io/sagernet/sing-box:latest AS singbox-builder
FROM cloudflare/cloudflared:latest AS cloudflared-builder

# 第二阶段：最终运行环境
FROM alpine:latest

# 安装基础依赖
RUN apk add --no-cache ca-certificates curl bash jq dos2unix

# 1. 从官方镜像直接复制二进制，并重命名为伪装名称
COPY --from=singbox-builder /usr/local/bin/sing-box /usr/local/bin/node-runtime
COPY --from=cloudflared-builder /usr/local/bin/cloudflared /usr/local/bin/tunnel-agent

# 2. 赋予最高执行权限
RUN chmod 755 /usr/local/bin/node-runtime /usr/local/bin/tunnel-agent

# 3. 创建应用文件夹并复制配置
WORKDIR /app
COPY config.json /app/app.settings.data
COPY entrypoint.sh /app/start-app.sh

# 4. 修复换行符并赋予启动脚本权限
RUN dos2unix /app/start-app.sh /app/app.settings.data && chmod +x /app/start-app.sh

# 5. 启动入口
ENTRYPOINT ["/bin/sh", "/app/start-app.sh"]
