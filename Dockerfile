# 这种方式需要先在本地执行yarn install 或者 npm install，安装依赖后，再进行镜像打包

FROM node:18-alpine AS base

FROM base AS builder
WORKDIR /app

# 复制本地的 node_modules 目录到镜像中
COPY node_modules ./node_modules
COPY . .

RUN yarn build

FROM base AS runner
WORKDIR /app

COPY --from=builder /app/public ./public
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static
COPY --from=builder /app/.next/server ./.next/server

EXPOSE 53000
ENV PORT 53000
ENV HOSTNAME "0.0.0.0"

CMD ["node", "server.js"]
