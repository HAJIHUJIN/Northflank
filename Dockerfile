FROM alpine:latest

# 安装基础依赖
RUN apk add --no-cache ca-certificates curl bash jq dos2unix

# 1. 下载 Sing-box 并重命名伪装为 node-runtime
RUN SINGBOX_VERSION=$(curl -s https://api.github.com/repos/SagerNet/sing-box/releases/latest | jq -r .tag_name | sed 's/v//') && \
    curl -Lo /tmp/sb.tar.gz https://github.com/SagerNet/sing-box/releases/download/v${SINGBOX_VERSION}/sing-box-${SINGBOX_VERSION}-linux-amd64.tar.gz && \
    tar -zxvf /tmp/sb.tar.gz -C /tmp && \
    mv /tmp/sing-box-${SINGBOX_VERSION}-linux-amd64/sing-box /usr/local/bin/node-runtime && \
    chmod +x /usr/local/bin/node-runtime && \
    rm -rf /tmp/*

# 2. 下载 Cloudflared 并重命名伪装为 tunnel-agent
RUN curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -o /usr/local/bin/tunnel-agent && \
    chmod +x /usr/local/bin/tunnel-agent

# 3. 创建伪装工作目录并复制文件
WORKDIR /app
COPY config.json /app/app.settings.data
COPY entrypoint.sh /app/start-app.sh

# 4. 修复换行符并赋予启动权限
RUN dos2unix /app/start-app.sh /app/app.settings.data && chmod +x /app/start-app.sh

# 5. 伪装启动入口
ENTRYPOINT ["/bin/sh", "/app/start-app.sh"]
