FROM alpine:latest

# 1. 安装基础依赖和 dos2unix（用于修复 Windows 换行符问题）
RUN apk add --no-cache ca-certificates curl bash jq dos2unix

# 2. 下载并安装 Sing-box
RUN SINGBOX_VERSION=$(curl -s https://api.github.com/repos/SagerNet/sing-box/releases/latest | jq -r .tag_name | sed 's/v//') && \
    curl -Lo /tmp/sing-box.tar.gz https://github.com/SagerNet/sing-box/releases/download/v${SINGBOX_VERSION}/sing-box-${SINGBOX_VERSION}-linux-amd64.tar.gz && \
    tar -zxvf /tmp/sing-box.tar.gz -C /tmp && \
    mv /tmp/sing-box-${SINGBOX_VERSION}-linux-amd64/sing-box /usr/local/bin/sing-box && \
    chmod +x /usr/local/bin/sing-box && \
    rm -rf /tmp/*

# 3. 下载并安装 Cloudflared
RUN curl -L https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64 -o /usr/local/bin/cloudflared && \
    chmod +x /usr/local/bin/cloudflared

# 4. 复制配置文件和脚本，强制转换换行符并赋予执行权限
WORKDIR /etc/sing-box
COPY config.json /etc/sing-box/config.json
COPY entrypoint.sh /entrypoint.sh
RUN dos2unix /entrypoint.sh /etc/sing-box/config.json && chmod +x /entrypoint.sh

# 5. 明确入口使用 /bin/sh 执行，彻底避免 No such file 错误
ENTRYPOINT ["/bin/sh", "/entrypoint.sh"]
