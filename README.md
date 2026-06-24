# 🎫 Ticket System

Sistema de atendimento multitenancy integrado com WhatsApp via Evolution API.

---

## 📋 Visão Geral

Plataforma SaaS de tickets de suporte onde cada empresa (tenant) possui seu próprio número WhatsApp, setores, agentes e configurações. O bot via n8n recebe as mensagens, exibe um menu de opções e cria os tickets automaticamente. Os atendentes gerenciam tudo pelo painel web em tempo real.

---

## 🏗️ Arquitetura

```
WhatsApp
   ↓
Evolution API (v2.2.3)
   ↓ webhook
n8n (automação do bot)
   ↓ HTTP
NestJS API (backend)
   ↓ WebSocket
Vue 3 (frontend — painel dos atendentes)
```

### Bancos de dados

| Banco          | Usado por       |
| -------------- | --------------- |
| `ticket_db`    | NestJS + Prisma |
| `evolution_db` | Evolution API   |
| `n8n_db`       | n8n             |

---

## 📁 Estrutura de Pastas

```
TICKET/
├── api/                    # NestJS — backend
│   ├── prisma/
│   │   ├── schema.prisma   # Schema completo com multitenancy + RBAC
│   │   └── seed.ts         # Permissões e roles padrão
│   ├── src/
│   │   ├── generated/prisma/ # Prisma client gerado
│   │   ├── prisma/           # PrismaService + PrismaModule
│   │   ├── tenant/           # Middleware, guard e decorator de tenant
│   │   ├── rbac/             # Guard e decorator de permissões
│   │   ├── auth/             # JWT login
│   │   ├── agents/           # CRUD de atendentes
│   │   ├── sectors/          # CRUD de setores
│   │   ├── groups/           # CRUD de grupos
│   │   ├── roles/            # CRUD de roles e permissões
│   │   ├── contacts/         # Clientes do WhatsApp
│   │   ├── tickets/          # Core — tickets com transferência
│   │   ├── messages/         # Histórico de mensagens
│   │   ├── webhook/          # Recebe eventos do n8n
│   │   ├── gateway/          # WebSocket tempo real (Socket.io)
│   │   └── evolution/        # Serviço de envio via Evolution API
│   ├── prisma.config.ts      # Config do Prisma v7
│   ├── .env                  # Variáveis locais da API
│   └── package.json
│
├── app/                    # Vue 3 — frontend
│   ├── src/
│   │   ├── stores/         # Pinia
│   │   ├── views/          # Páginas
│   │   ├── components/     # Componentes Vuetify
│   │   └── services/       # Axios
│   └── .env
│
├── docker/                 # Infraestrutura
│   ├── docker-compose.yml  # Postgres, Redis, Evolution, n8n
│   ├── init.sql            # Cria os 3 bancos automaticamente
│   └── .env                # Senhas do compose
│
└── evolution/
    └── .env                # Configuração da Evolution API
```

---

## 🚀 Stack

| Camada      | Tecnologia                        |
| ----------- | --------------------------------- |
| Frontend    | Vue 3 + Vuetify 3 + Pinia + Axios |
| Backend     | NestJS + Prisma v7                |
| Banco       | PostgreSQL 16                     |
| Cache/Filas | Redis 7                           |
| WhatsApp    | Evolution API v2.2.3              |
| Bot         | n8n                               |
| Auth        | JWT                               |

---

## ⚙️ Setup Local

### Pré-requisitos

- Node.js 20+
- Docker + Docker Compose
- npm

### 1. Infraestrutura (Docker)

```bash
cd docker
docker compose up -d
```

Serviços que sobem:

| Serviço       | Porta | URL                           |
| ------------- | ----- | ----------------------------- |
| PostgreSQL    | 5432  | localhost:5432                |
| Redis         | 6379  | localhost:6379                |
| Evolution API | 8080  | http://localhost:8080/manager |
| n8n           | 5678  | http://localhost:5678         |

### 2. API (NestJS)

```bash
cd api
npm install
npx prisma generate
npx prisma migrate dev --name init
npx prisma db seed
npm run start:dev
```

API disponível em: `http://localhost:3000/api`

### 3. Frontend (Vue)

```bash
cd app
npm install
npm run dev
```

Frontend disponível em: `http://localhost:5173`

---

## 🔐 Multitenancy

Cada tenant é identificado por:

- **Subdomínio**: `empresa1.seudominio.com.br`
- **Header**: `X-Tenant-Slug: empresa1`

O `TenantMiddleware` resolve o tenant automaticamente em toda request. O `TenantGuard` garante que o agente autenticado pertence ao tenant da request.

---

## 🔒 RBAC (Controle de Acesso)

### Modelo

```
Permission (fixas no sistema — ~38 permissões)
    ↑ N:N
  Role (criadas pelo admin do tenant)
    ↑ N:N
  Group → Agent (agente herda permissões do grupo)
    +
  AgentRole (role direta no agente)
```

### Roles padrão (criadas no seed)

| Role          | Descrição                             |
| ------------- | ------------------------------------- |
| Administrador | Acesso total                          |
| Supervisor    | Vê todos os tickets, gerencia equipes |
| Atendente     | Atende tickets do seu setor           |

### Permissões por recurso

| Recurso  | Ações                                                                                   |
| -------- | --------------------------------------------------------------------------------------- |
| tickets  | read, read_all, create, assume, transfer, resolve, close, reopen, set_priority, add_tag |
| messages | read, send, send_internal                                                               |
| contacts | read, create, update, block                                                             |
| reports  | read, export                                                                            |
| agents   | read, create, update, delete                                                            |
| groups   | read, create, update, delete                                                            |
| roles    | read, create, update, delete                                                            |
| sectors  | read, create, update, delete                                                            |
| settings | read, update                                                                            |
| whatsapp | connect, read_status                                                                    |

---

## 🤖 Fluxo do Bot (n8n)

```
Cliente manda mensagem
        ↓
Evolution API → webhook → n8n
        ↓
Tem ticket aberto?
  SIM → encaminha mensagem para o agente
  NÃO → envia menu de setores
        ↓
Cliente escolhe (ex: 1 = Comercial, 2 = T.I)
        ↓
n8n → POST /api/tickets → NestJS cria ticket
        ↓
NestJS → WebSocket → atendente recebe no painel
```

---

## 🎫 Status dos Tickets

| Status      | Descrição                            |
| ----------- | ------------------------------------ |
| PENDING     | Na fila, sem agente                  |
| WAITING_BOT | Bot enviou menu, aguardando resposta |
| OPEN        | Agente assumiu                       |
| TRANSFERRED | Em transferência                     |
| RESOLVED    | Resolvido pelo agente                |
| CLOSED      | Encerrado                            |

---

## 🔄 Transferência de Tickets

Atendente pode:

- **Assumir** ticket da fila
- **Transferir para setor** → vai para fila do novo setor
- **Transferir para agente** → atribuído diretamente
- **Resolver** → status RESOLVED
- **Encerrar** → status CLOSED

Todas as ações geram eventos na timeline do ticket.

---

## 📡 WebSocket — Salas (Socket.io)

| Sala          | Quem escuta                          |
| ------------- | ------------------------------------ |
| `sector_{id}` | Atendentes do setor — novos tickets  |
| `agent_{id}`  | Atendente específico — transferência |
| `ticket_{id}` | Chat em tempo real                   |

---

## 🖥️ Telas do Frontend (planejado)

| Rota              | Descrição                         |
| ----------------- | --------------------------------- |
| `/login`          | Login do atendente                |
| `/dashboard`      | Visão geral + métricas            |
| `/tickets`        | Lista de tickets por setor/status |
| `/tickets/:id`    | Chat em tempo real + timeline     |
| `/admin/sectors`  | CRUD setores                      |
| `/admin/agents`   | CRUD agentes                      |
| `/admin/groups`   | CRUD grupos                       |
| `/admin/roles`    | CRUD roles e permissões           |
| `/admin/settings` | Configurações do tenant           |
| `/reports`        | Relatórios e gráficos             |

---

## 📦 Variáveis de Ambiente

### `docker/.env`

```env
POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres
REDIS_PASSWORD=admin
N8N_USER=admin
N8N_PASSWORD=admin
N8N_ENCRYPTION_KEY=sua_chave_aqui
```

### `api/.env`

```env
NODE_ENV=development
PORT=3000
DATABASE_URL="postgresql://postgres:postgres@localhost:5432/ticket_db?schema=public"
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=admin
JWT_SECRET=sua_chave_jwt
JWT_EXPIRES_IN=8h
EVOLUTION_API_URL=http://localhost:8080
EVOLUTION_API_KEY=sua_api_key
EVOLUTION_INSTANCE_NAME=ticket-central
WS_CORS_ORIGIN=http://localhost:5173
```

### `app/.env`

```env
VITE_API_URL=http://localhost:3000
VITE_WS_URL=http://localhost:3000
VITE_APP_NAME=TicketSystem
```

### `evolution/.env`

```env
DATABASE_CONNECTION_URI=postgresql://postgres:postgres@postgres:5432/evolution_db
CACHE_REDIS_URI=redis://:admin@redis:6379/6
WEBHOOK_GLOBAL_URL=http://n8n:5678/webhook/evolution
AUTHENTICATION_API_KEY=sua_api_key
```

---

## 🗺️ Roadmap

### ✅ Concluído

- [x] Infraestrutura Docker (Postgres, Redis, Evolution, n8n)
- [x] Schema Prisma completo (multitenancy + RBAC)
- [x] Seed de permissões e roles padrão
- [x] Middleware/Guard de tenant
- [x] Guard RBAC com herança de grupos

### 🔧 Em andamento

- [ ] Módulo Auth (JWT login)
- [ ] Módulo Agents
- [ ] Módulo Sectors
- [ ] Módulo Groups + Roles
- [ ] Módulo Tickets (CRUD + transferência)
- [ ] Módulo Messages
- [ ] WebSocket Gateway
- [ ] Módulo Evolution (envio de mensagens)
- [ ] Webhook receiver (n8n → NestJS)

### 📅 Próximos

- [ ] Fluxo n8n do bot (menu + criação de ticket)
- [ ] Frontend Vue (layout base + autenticação)
- [ ] Painel de tickets com chat em tempo real
- [ ] Dashboard e relatórios
- [ ] Configurações do tenant
