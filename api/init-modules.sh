#!/bin/bash
set -e

echo "🚀 Criando módulos NestJS..."

# Prisma
nest g module prisma --no-spec
nest g service prisma --no-spec

# Tenant
nest g module tenant --no-spec
nest g service tenant --no-spec

# RBAC
nest g module rbac --no-spec

# Auth
nest g module auth --no-spec
nest g service auth --no-spec
nest g controller auth --no-spec

# Agents
nest g module agents --no-spec
nest g service agents --no-spec
nest g controller agents --no-spec

# Sectors
nest g module sectors --no-spec
nest g service sectors --no-spec
nest g controller sectors --no-spec

# Groups
nest g module groups --no-spec
nest g service groups --no-spec
nest g controller groups --no-spec

# Roles
nest g module roles --no-spec
nest g service roles --no-spec
nest g controller roles --no-spec

# Contacts
nest g module contacts --no-spec
nest g service contacts --no-spec
nest g controller contacts --no-spec

# Tickets
nest g module tickets --no-spec
nest g service tickets --no-spec
nest g controller tickets --no-spec

# Messages
nest g module messages --no-spec
nest g service messages --no-spec
nest g controller messages --no-spec

# Webhook
nest g module webhook --no-spec
nest g service webhook --no-spec
nest g controller webhook --no-spec

# Gateway
nest g module gateway --no-spec

# Evolution
nest g module evolution --no-spec
nest g service evolution --no-spec

echo "✅ Todos os módulos criados!"