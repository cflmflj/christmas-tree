# --- 第一阶段：构建 (Builder) ---
    FROM node:18-alpine as builder

    # 设置工作目录
    WORKDIR /app
    
    # 复制依赖文件并安装 (利用缓存层)
    COPY package.json package-lock.json ./
    # 如果你在国内构建，建议加上淘宝源
    # RUN npm config set registry https://registry.npmmirror.com
    RUN npm install
    
    # 复制所有源代码
    COPY . .
    
    # 执行构建 (会生成 dist 目录)
    RUN npm run build
    
    # --- 第二阶段：运行 (Runner) ---
    FROM nginx:alpine
    
    # 从第一阶段复制构建好的静态文件到 Nginx 目录
    COPY --from=builder /app/dist /usr/share/nginx/html
    
    # (可选) 如果你有自定义的 nginx.conf，可以取消注释下面这行
    # COPY nginx.conf /etc/nginx/conf.d/default.conf
    
    # 暴露 80 端口
    EXPOSE 80
    
    # 启动 Nginx
    CMD ["nginx", "-g", "daemon off;"]