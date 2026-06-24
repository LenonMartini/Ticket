# ─────────────────────────────────────────
# Stage: base
# ─────────────────────────────────────────
FROM node:20-alpine AS base
WORKDIR /app
RUN apk add --no-cache openssl
COPY package*.json ./
RUN npm ci

# ─────────────────────────────────────────
# Stage: development (hot reload)
# ─────────────────────────────────────────
FROM base AS development
COPY . .
RUN npx prisma generate
CMD ["npm", "run", "start:dev"]

# ─────────────────────────────────────────
# Stage: builder
# ─────────────────────────────────────────
FROM base AS builder
COPY . .
RUN npx prisma generate
RUN npm run build

# ─────────────────────────────────────────
# Stage: production
# ─────────────────────────────────────────
FROM node:20-alpine AS production
WORKDIR /app
RUN apk add --no-cache openssl
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/prisma ./prisma
RUN npx prisma generate
EXPOSE 3000
CMD ["node", "dist/main"]