# 🎫 Ticket System

Sistema de atendimento multitenancy integrado com WhatsApp via Evolution API, automação por bot N8N e controle de estoque com entrada por NF-e.

---

## 📋 Visão Geral

Plataforma SaaS de tickets de suporte onde cada empresa (tenant) possui múltiplos números WhatsApp, lojas, departamentos, agentes e configurações independentes. O bot via N8N recebe as mensagens, conduz o atendimento inicial e cria os tickets automaticamente. Os atendentes gerenciam tudo pelo painel web em tempo real.

---

## 🏗️ Arquitetura

```
WhatsApp
   ↓
Evolution API v2.2.3  (N instâncias por tenant — um número por instância)
   ↓ webhook
N8N  (bot de atendimento — menu, coleta de dados, escalonamento)
   ↓ HTTP
NestJS API  (backend principal)
   ↓
PostgreSQL + Redis
   ↓ WebSocket
Vue 3  (painel dos atendentes)
```

### Bancos de dados

| Banco          | Usado por       |
| -------------- | --------------- |
| `ticket_db`    | NestJS + Prisma |
| `evolution_db` | Evolution API   |
| `n8n_db`       | N8N             |

---

## 📁 Estrutura de Pastas

```
TICKET/
├── api/                          # NestJS — backend
│   ├── prisma/
│   │   ├── schema.prisma         # Schema completo (multitenancy + RBAC + N8N + Estoque)
│   │   └── seed.ts               # Permissões, roles, tenant demo e dados iniciais
│   ├── src/
│   │   ├── generated/prisma/     # Prisma client gerado
│   │   ├── prisma/               # PrismaService + PrismaModule
│   │   ├── tenant/               # Middleware, guard e decorator de tenant
│   │   ├── rbac/                 # Guard e decorator de permissões
│   │   ├── auth/                 # JWT login
│   │   ├── users/                # CRUD de usuários
│   │   ├── stores/               # CRUD de lojas
│   │   ├── departments/          # CRUD de departamentos
│   │   ├── roles/                # CRUD de roles e permissões
│   │   ├── contacts/             # Clientes do WhatsApp
│   │   ├── tickets/              # Core — tickets + transferência + timeline
│   │   ├── messages/             # Histórico de mensagens
│   │   ├── evolution/            # Gerenciamento de instâncias + envio de mensagens
│   │   ├── bot/                  # BotSessions — estado do bot por contato
│   │   ├── n8n/                  # Workflows e execuções N8N
│   │   ├── webhook/              # Recebe eventos da Evolution via N8N
│   │   ├── gateway/              # WebSocket tempo real (Socket.io)
│   │   ├── products/             # CRUD de produtos e categorias
│   │   ├── stock/                # Saldo + movimentações de estoque
│   │   └── nfe/                  # Importação e processamento de NF-e
│   ├── .env
│   └── package.json
│
├── app/                          # Vue 3 — frontend
│   ├── src/
│   │   ├── stores/               # Pinia
│   │   ├── views/                # Páginas
│   │   ├── components/           # Componentes Vuetify
│   │   └── services/             # Axios
│   └── .env
│
├── docker/                       # Infraestrutura
│   ├── docker-compose.yml        # Postgres, Redis, Evolution, N8N
│   ├── init.sql                  # Cria os 3 bancos automaticamente
│   └── .env
│
└── evolution/
    └── .env                      # Configuração da Evolution API
```

---

## 🚀 Stack

| Camada        | Tecnologia                        |
| ------------- | --------------------------------- |
| Frontend      | Vue 3 + Vuetify 3 + Pinia + Axios |
| Backend       | NestJS + Prisma v7                |
| Banco         | PostgreSQL 16                     |
| Cache / Filas | Redis 7                           |
| WhatsApp      | Evolution API v2.2.3              |
| Bot           | N8N                               |
| Auth          | JWT                               |

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
| N8N           | 5678  | http://localhost:5678         |

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

- **Subdomínio**: `empresa.seudominio.com.br`
- **Header**: `X-Tenant-Slug: empresa`

O `TenantMiddleware` resolve o tenant automaticamente em toda request. O `TenantGuard` garante que o usuário autenticado pertence ao tenant da request.

Um tenant pode ter **múltiplas instâncias Evolution** — cada instância é um número de WhatsApp independente, podendo estar vinculada a uma loja específica ou compartilhada entre todas.

---

## 🔒 RBAC (Controle de Acesso)

### Modelo

```
Permission  (globais no sistema — 57 permissões atômicas)
    ↑ N:N
  Role  (criadas e gerenciadas pelo admin do tenant)
    ↑ N:N
  UserRole  (vínculo contextual: user + role + loja + departamento)
```

O mesmo usuário pode ter papéis diferentes em lojas ou departamentos distintos dentro do mesmo tenant.

### Roles padrão (criadas no seed)

| Role              | Descrição                              |
| ----------------- | -------------------------------------- |
| Administrador     | Acesso total ao sistema                |
| Supervisor        | Gerencia equipes, vê todos os tickets  |
| Atendente         | Atende tickets do próprio setor        |
| Gestor de Estoque | Produtos, estoque e importação de NF-e |
| Visualizador      | Somente leitura (auditoria)            |

### Permissões por recurso

| Recurso     | Ações                                                                                                |
| ----------- | ---------------------------------------------------------------------------------------------------- |
| tickets     | read, read_all, create, assume, transfer, resolve, close, reopen, set_priority, add_tag, bot_control |
| messages    | read, send, send_internal                                                                            |
| contacts    | read, create, update, block, delete                                                                  |
| users       | read, create, update, delete                                                                         |
| stores      | read, create, update, delete                                                                         |
| departments | read, create, update, delete                                                                         |
| roles       | read, create, update, delete                                                                         |
| products    | read, create, update, delete                                                                         |
| stock       | read, write, transfer                                                                                |
| nfe         | read, import, cancel                                                                                 |
| n8n         | read, manage                                                                                         |
| whatsapp    | read, connect, manage                                                                                |
| reports     | read, export                                                                                         |
| settings    | read, update                                                                                         |

---

## 📱 Evolution API — Múltiplas Instâncias

Cada instância representa um número de WhatsApp. Um tenant pode ter quantas instâncias quiser (limitado pelo plano).

```
Tenant
 ├── Instância 01  →  Loja SP  →  (55 11) 9xxxx-xxxx
 ├── Instância 02  →  Loja RJ  →  (55 21) 9xxxx-xxxx
 └── Instância 03  →  Compartilhada  →  (55 11) 3xxx-xxxx
```

Ciclo de vida de uma instância:

```
DISCONNECTED → QR_PENDING → CONNECTING → CONNECTED
                                              ↓
                                        DISCONNECTED  (logout / queda)
```

Cada instância tem seu próprio `webhookUrl` configurado para receber eventos da Evolution.

---

## 🤖 Fluxo do Bot (N8N)

```
Cliente manda mensagem
        ↓
Evolution API → webhook → N8N
        ↓
Já existe BotSession ativa para este contato + instância?
  SIM → continua no currentStep do fluxo
  NÃO → inicia novo workflow (Atendimento Inicial)
        ↓
Bot exibe menu de departamentos
        ↓
Cliente escolhe opção
        ↓
Bot coleta dados (nome, assunto…) e salva em BotSession.context
        ↓
Escalonar para humano?
  NÃO → conclui o fluxo (BotSession.status = FINISHED)
  SIM → N8N → POST /api/tickets → NestJS cria Ticket
              BotSession.status = ESCALATED
              Ticket.isBotActive = false
        ↓
NestJS → WebSocket → atendente recebe no painel
```

### Estados da BotSession

| Status    | Descrição                         |
| --------- | --------------------------------- |
| ACTIVE    | Bot conduzindo o fluxo ativamente |
| WAITING   | Aguardando resposta do cliente    |
| ESCALATED | Transferido para agente humano    |
| FINISHED  | Fluxo concluído sem escalonamento |
| ABANDONED | Cliente não respondeu (timeout)   |

### N8nExecution

Cada execução de workflow é registrada com `inputData`, `outputData`, `durationMs` e `status`, permitindo rastrear e debugar o comportamento do bot.

---

## 🎫 Status dos Tickets

| Status      | Descrição                         |
| ----------- | --------------------------------- |
| PENDING     | Na fila, sem agente               |
| BOT_ACTIVE  | Bot conduzindo o atendimento      |
| OPEN        | Agente assumiu                    |
| WAITING     | Aguardando resposta do cliente    |
| TRANSFERRED | Em transferência para outro setor |
| RESOLVED    | Resolvido pelo agente             |
| CLOSED      | Encerrado definitivamente         |

---

## 🔄 Transferência de Tickets

Um agente pode:

- **Assumir** ticket da fila
- **Transferir para departamento** → vai para fila do novo departamento
- **Transferir para usuário** → atribuído diretamente
- **Devolver ao bot** → `isBotActive = true`, N8N reassume o fluxo
- **Resolver** → status `RESOLVED`
- **Encerrar** → status `CLOSED`

Todas as ações geram eventos em `TicketEvent` (timeline de auditoria).

---

## 📦 Estoque & NF-e

### Fluxo de entrada por NF-e

```
Upload do XML da NF-e
        ↓
NfeImport criado (status: PENDING)  →  XML armazenado em rawXml
        ↓
Gestor faz o de-para: NfeItem.productCode → Product.sku
        ↓
Processar NF-e
        ↓
StockMovement criado (type: IN_NFE) por item
Stock.quantity atualizado
NfeImport.status = PROCESSED
```

### Tipos de movimentação

| Tipo       | Descrição                 |
| ---------- | ------------------------- |
| IN         | Entrada manual            |
| OUT        | Saída manual              |
| IN_NFE     | Entrada por NF-e          |
| OUT_SALE   | Saída por venda           |
| ADJUSTMENT | Ajuste de inventário      |
| TRANSFER   | Transferência entre lojas |

`StockMovement` é **append-only** — nunca atualizado, apenas inserido. O saldo real fica em `Stock.quantity`, atualizado pela aplicação a cada movimento.

---

## 📡 WebSocket — Salas (Socket.io)

| Sala          | Quem escuta                               |
| ------------- | ----------------------------------------- |
| `dept_{id}`   | Usuários do departamento — novos tickets  |
| `user_{id}`   | Usuário específico — transferência direta |
| `ticket_{id}` | Chat em tempo real                        |
| `tenant_{id}` | Admins — eventos globais do tenant        |

---

## 🖥️ Telas do Frontend (planejado)

| Rota                 | Descrição                          |
| -------------------- | ---------------------------------- |
| `/login`             | Login                              |
| `/dashboard`         | Visão geral + métricas             |
| `/tickets`           | Lista por departamento/status      |
| `/tickets/:id`       | Chat em tempo real + timeline      |
| `/admin/stores`      | CRUD lojas                         |
| `/admin/departments` | CRUD departamentos                 |
| `/admin/users`       | CRUD usuários + roles              |
| `/admin/roles`       | CRUD roles e permissões            |
| `/admin/evolution`   | Instâncias WhatsApp (QR code)      |
| `/admin/n8n`         | Workflows e histórico de execuções |
| `/admin/settings`    | Configurações do tenant            |
| `/stock`             | Saldo de estoque por loja          |
| `/stock/movements`   | Histórico de movimentações         |
| `/stock/nfe`         | Importação de NF-e                 |
| `/reports`           | Relatórios e gráficos              |

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
API_URL=http://localhost:3000
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

- [x] Infraestrutura Docker (Postgres, Redis, Evolution, N8N)
- [x] Schema Prisma completo (multitenancy + RBAC + N8N + Estoque + NF-e)
- [x] Seed com 57 permissões, 5 roles, tenant demo, usuário admin, instância Evolution e workflow N8N
- [x] README e documentação de arquitetura

### 🔧 Em andamento

- [ ] Módulo Auth (JWT login + refresh token)
- [ ] Módulo Users + UserRoles
- [ ] Módulo Stores + Departments
- [ ] Módulo Roles + Permissions
- [ ] Módulo Contacts
- [ ] Módulo Evolution (gerenciamento de instâncias + QR code)
- [ ] Módulo Tickets (CRUD + assunção + transferência + timeline)
- [ ] Módulo Messages
- [ ] WebSocket Gateway (Socket.io)
- [ ] Módulo Webhook (recebe eventos Evolution via N8N)
- [ ] Módulo Bot (BotSession — estado do fluxo N8N)
- [ ] Módulo N8N (workflows + execuções)

### 📅 Próximos

- [ ] Módulo Products + ProductCategories
- [ ] Módulo Stock (saldo + movimentações)
- [ ] Módulo NF-e (import XML + de-para de produtos)
- [ ] Fluxo N8N do bot (menu + coleta + escalonamento)
- [ ] Frontend Vue — layout base + autenticação
- [ ] Frontend Vue — painel de tickets com chat em tempo real
- [ ] Frontend Vue — gerenciamento de instâncias Evolution (QR code)
- [ ] Frontend Vue — estoque e NF-e
- [ ] Dashboard e relatórios
