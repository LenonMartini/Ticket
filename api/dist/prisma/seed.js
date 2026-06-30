"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
const prisma_1 = require("../src/generated/prisma");
const adapter_pg_1 = require("@prisma/adapter-pg");
const bcrypt = __importStar(require("bcryptjs"));
require("dotenv/config");
const adapter = new adapter_pg_1.PrismaPg({ connectionString: process.env.DATABASE_URL });
const prisma = new prisma_1.PrismaClient({ adapter });
const PERMISSIONS = [
    {
        key: 'tickets:read',
        resource: 'tickets',
        action: 'read',
        description: 'Visualizar próprios tickets',
    },
    {
        key: 'tickets:read_all',
        resource: 'tickets',
        action: 'read_all',
        description: 'Visualizar todos os tickets do tenant',
    },
    {
        key: 'tickets:create',
        resource: 'tickets',
        action: 'create',
        description: 'Criar tickets manualmente',
    },
    {
        key: 'tickets:assume',
        resource: 'tickets',
        action: 'assume',
        description: 'Assumir tickets da fila',
    },
    {
        key: 'tickets:transfer',
        resource: 'tickets',
        action: 'transfer',
        description: 'Transferir para setor ou agente',
    },
    {
        key: 'tickets:resolve',
        resource: 'tickets',
        action: 'resolve',
        description: 'Marcar ticket como resolvido',
    },
    {
        key: 'tickets:close',
        resource: 'tickets',
        action: 'close',
        description: 'Encerrar ticket definitivamente',
    },
    {
        key: 'tickets:reopen',
        resource: 'tickets',
        action: 'reopen',
        description: 'Reabrir ticket encerrado',
    },
    {
        key: 'tickets:set_priority',
        resource: 'tickets',
        action: 'set_priority',
        description: 'Alterar prioridade do ticket',
    },
    {
        key: 'tickets:add_tag',
        resource: 'tickets',
        action: 'add_tag',
        description: 'Adicionar/remover tags do ticket',
    },
    {
        key: 'tickets:bot_control',
        resource: 'tickets',
        action: 'bot_control',
        description: 'Ativar/desativar bot num ticket',
    },
    {
        key: 'messages:read',
        resource: 'messages',
        action: 'read',
        description: 'Ler mensagens dos tickets',
    },
    {
        key: 'messages:send',
        resource: 'messages',
        action: 'send',
        description: 'Enviar mensagens ao cliente',
    },
    {
        key: 'messages:send_internal',
        resource: 'messages',
        action: 'send_internal',
        description: 'Enviar notas internas (não chegam ao cliente)',
    },
    {
        key: 'contacts:read',
        resource: 'contacts',
        action: 'read',
        description: 'Visualizar contatos',
    },
    {
        key: 'contacts:create',
        resource: 'contacts',
        action: 'create',
        description: 'Criar contatos',
    },
    {
        key: 'contacts:update',
        resource: 'contacts',
        action: 'update',
        description: 'Editar contatos',
    },
    {
        key: 'contacts:block',
        resource: 'contacts',
        action: 'block',
        description: 'Bloquear/desbloquear contatos',
    },
    {
        key: 'contacts:delete',
        resource: 'contacts',
        action: 'delete',
        description: 'Remover contatos',
    },
    {
        key: 'users:read',
        resource: 'users',
        action: 'read',
        description: 'Visualizar usuários',
    },
    {
        key: 'users:create',
        resource: 'users',
        action: 'create',
        description: 'Criar usuários',
    },
    {
        key: 'users:update',
        resource: 'users',
        action: 'update',
        description: 'Editar usuários',
    },
    {
        key: 'users:delete',
        resource: 'users',
        action: 'delete',
        description: 'Remover usuários',
    },
    {
        key: 'stores:read',
        resource: 'stores',
        action: 'read',
        description: 'Visualizar lojas',
    },
    {
        key: 'stores:create',
        resource: 'stores',
        action: 'create',
        description: 'Criar lojas',
    },
    {
        key: 'stores:update',
        resource: 'stores',
        action: 'update',
        description: 'Editar lojas',
    },
    {
        key: 'stores:delete',
        resource: 'stores',
        action: 'delete',
        description: 'Remover lojas',
    },
    {
        key: 'departments:read',
        resource: 'departments',
        action: 'read',
        description: 'Visualizar departamentos',
    },
    {
        key: 'departments:create',
        resource: 'departments',
        action: 'create',
        description: 'Criar departamentos',
    },
    {
        key: 'departments:update',
        resource: 'departments',
        action: 'update',
        description: 'Editar departamentos',
    },
    {
        key: 'departments:delete',
        resource: 'departments',
        action: 'delete',
        description: 'Remover departamentos',
    },
    {
        key: 'roles:read',
        resource: 'roles',
        action: 'read',
        description: 'Visualizar roles',
    },
    {
        key: 'roles:create',
        resource: 'roles',
        action: 'create',
        description: 'Criar roles',
    },
    {
        key: 'roles:update',
        resource: 'roles',
        action: 'update',
        description: 'Editar roles e permissões',
    },
    {
        key: 'roles:delete',
        resource: 'roles',
        action: 'delete',
        description: 'Remover roles',
    },
    {
        key: 'products:read',
        resource: 'products',
        action: 'read',
        description: 'Visualizar produtos',
    },
    {
        key: 'products:create',
        resource: 'products',
        action: 'create',
        description: 'Criar produtos',
    },
    {
        key: 'products:update',
        resource: 'products',
        action: 'update',
        description: 'Editar produtos',
    },
    {
        key: 'products:delete',
        resource: 'products',
        action: 'delete',
        description: 'Remover produtos',
    },
    {
        key: 'stock:read',
        resource: 'stock',
        action: 'read',
        description: 'Visualizar saldo de estoque',
    },
    {
        key: 'stock:write',
        resource: 'stock',
        action: 'write',
        description: 'Realizar movimentações de estoque',
    },
    {
        key: 'stock:transfer',
        resource: 'stock',
        action: 'transfer',
        description: 'Transferir estoque entre lojas',
    },
    {
        key: 'nfe:read',
        resource: 'nfe',
        action: 'read',
        description: 'Visualizar NF-e importadas',
    },
    {
        key: 'nfe:import',
        resource: 'nfe',
        action: 'import',
        description: 'Importar NF-e',
    },
    {
        key: 'nfe:cancel',
        resource: 'nfe',
        action: 'cancel',
        description: 'Cancelar NF-e importada',
    },
    {
        key: 'n8n:read',
        resource: 'n8n',
        action: 'read',
        description: 'Visualizar workflows e execuções',
    },
    {
        key: 'n8n:manage',
        resource: 'n8n',
        action: 'manage',
        description: 'Criar/editar/ativar workflows',
    },
    {
        key: 'whatsapp:read',
        resource: 'whatsapp',
        action: 'read',
        description: 'Visualizar instâncias e status',
    },
    {
        key: 'whatsapp:connect',
        resource: 'whatsapp',
        action: 'connect',
        description: 'Conectar/desconectar instâncias',
    },
    {
        key: 'whatsapp:manage',
        resource: 'whatsapp',
        action: 'manage',
        description: 'Criar/remover instâncias',
    },
    {
        key: 'reports:read',
        resource: 'reports',
        action: 'read',
        description: 'Visualizar relatórios',
    },
    {
        key: 'reports:export',
        resource: 'reports',
        action: 'export',
        description: 'Exportar relatórios',
    },
    {
        key: 'settings:read',
        resource: 'settings',
        action: 'read',
        description: 'Visualizar configurações',
    },
    {
        key: 'settings:update',
        resource: 'settings',
        action: 'update',
        description: 'Editar configurações do tenant',
    },
];
const DEFAULT_ROLES = {
    Administrador: {
        description: 'Acesso total ao sistema',
        isDefault: false,
        permissions: PERMISSIONS.map((p) => p.key),
    },
    Supervisor: {
        description: 'Gerencia equipes, visualiza todos os tickets e relatórios',
        isDefault: false,
        permissions: [
            'tickets:read',
            'tickets:read_all',
            'tickets:create',
            'tickets:transfer',
            'tickets:resolve',
            'tickets:close',
            'tickets:reopen',
            'tickets:set_priority',
            'tickets:add_tag',
            'tickets:bot_control',
            'messages:read',
            'messages:send',
            'messages:send_internal',
            'contacts:read',
            'contacts:update',
            'users:read',
            'stores:read',
            'departments:read',
            'roles:read',
            'products:read',
            'stock:read',
            'nfe:read',
            'n8n:read',
            'whatsapp:read',
            'reports:read',
            'reports:export',
            'settings:read',
        ],
    },
    Atendente: {
        description: 'Atende tickets do próprio setor',
        isDefault: true,
        permissions: [
            'tickets:read',
            'tickets:assume',
            'tickets:transfer',
            'tickets:resolve',
            'tickets:close',
            'tickets:add_tag',
            'messages:read',
            'messages:send',
            'messages:send_internal',
            'contacts:read',
        ],
    },
    'Gestor de Estoque': {
        description: 'Gerencia produtos, estoque e importação de NF-e',
        isDefault: false,
        permissions: [
            'products:read',
            'products:create',
            'products:update',
            'stock:read',
            'stock:write',
            'stock:transfer',
            'nfe:read',
            'nfe:import',
            'nfe:cancel',
            'stores:read',
            'reports:read',
            'reports:export',
        ],
    },
    Visualizador: {
        description: 'Acesso somente leitura (auditoria)',
        isDefault: false,
        permissions: [
            'tickets:read',
            'tickets:read_all',
            'messages:read',
            'contacts:read',
            'users:read',
            'stores:read',
            'departments:read',
            'products:read',
            'stock:read',
            'nfe:read',
            'n8n:read',
            'whatsapp:read',
            'reports:read',
            'settings:read',
        ],
    },
};
async function main() {
    console.log('🌱 Iniciando seed...\n');
    console.log('📋 Sincronizando permissões...');
    for (const perm of PERMISSIONS) {
        await prisma.permission.upsert({
            where: { key: perm.key },
            update: { description: perm.description },
            create: perm,
        });
    }
    console.log(`   ✅ ${PERMISSIONS.length} permissões sincronizadas\n`);
    console.log('🏢 Criando tenant demo...');
    const tenant = await prisma.tenant.upsert({
        where: { slug: 'demo' },
        update: {},
        create: {
            name: 'Empresa Demo',
            slug: 'demo',
            plan: 'PRO',
            isActive: true,
            settings: {
                create: {
                    welcomeMessage: 'Olá! Bem-vindo à Empresa Demo. Como podemos te ajudar? 😊',
                    menuMessage: 'Escolha o departamento:',
                    businessHoursEnabled: true,
                    businessHoursStart: '08:00',
                    businessHoursEnd: '18:00',
                    businessDays: [1, 2, 3, 4, 5],
                    inactivityTimeout: 24,
                    maxTicketsPerAgent: 15,
                },
            },
        },
    });
    console.log(`   ✅ Tenant "${tenant.name}" (slug: ${tenant.slug})\n`);
    console.log('🏪 Criando loja demo...');
    const store = await prisma.store.upsert({
        where: { id: 'store-demo-001' },
        update: {},
        create: {
            id: 'store-demo-001',
            tenantId: tenant.id,
            name: 'Loja Principal',
            phone: '5511999999999',
            address: 'Rua Demo, 100 - São Paulo/SP',
            isActive: true,
        },
    });
    console.log(`   ✅ Loja "${store.name}"\n`);
    console.log('📂 Criando departamentos...');
    const departments = [
        {
            name: 'Suporte',
            color: '#6366f1',
            menuOption: 1,
            description: 'Suporte técnico e dúvidas',
        },
        {
            name: 'Vendas',
            color: '#10b981',
            menuOption: 2,
            description: 'Atendimento comercial',
        },
        {
            name: 'Financeiro',
            color: '#f59e0b',
            menuOption: 3,
            description: 'Cobranças e pagamentos',
        },
    ];
    const createdDepts = {};
    for (const dept of departments) {
        const d = await prisma.department.upsert({
            where: { id: `dept-${dept.name.toLowerCase()}-001` },
            update: {},
            create: {
                id: `dept-${dept.name.toLowerCase()}-001`,
                tenantId: tenant.id,
                storeId: store.id,
                ...dept,
            },
        });
        createdDepts[dept.name] = d.id;
        console.log(`   ✅ Departamento "${d.name}"`);
    }
    console.log();
    console.log('🔐 Criando roles padrão...');
    for (const [roleName, roleData] of Object.entries(DEFAULT_ROLES)) {
        const perms = await prisma.permission.findMany({
            where: { key: { in: roleData.permissions } },
            select: { id: true },
        });
        const existing = await prisma.role.findFirst({
            where: { tenantId: tenant.id, name: roleName },
        });
        if (!existing) {
            await prisma.role.create({
                data: {
                    tenantId: tenant.id,
                    name: roleName,
                    description: roleData.description,
                    isSystem: true,
                    isDefault: roleData.isDefault,
                    rolePermissions: {
                        create: perms.map((p) => ({ permissionId: p.id })),
                    },
                },
            });
        }
        console.log(`   ✅ Role "${roleName}" — ${perms.length} permissões`);
    }
    console.log();
    console.log('👤 Criando usuário admin...');
    const passwordHash = await bcrypt.hash('@suporte', 12);
    const adminUser = await prisma.user.upsert({
        where: {
            tenantId_email: { tenantId: tenant.id, email: 'suporte@gmail.com' },
        },
        update: {},
        create: {
            tenantId: tenant.id,
            name: 'Suporte',
            email: 'suporte@gmail.com',
            passwordHash,
            isActive: true,
        },
    });
    const adminRole = await prisma.role.findFirstOrThrow({
        where: { tenantId: tenant.id, name: 'Administrador' },
    });
    const existingUserRole = await prisma.userRole.findFirst({
        where: {
            userId: adminUser.id,
            roleId: adminRole.id,
            storeId: store.id,
            departmentId: null,
        },
    });
    if (!existingUserRole) {
        await prisma.userRole.create({
            data: {
                userId: adminUser.id,
                roleId: adminRole.id,
                storeId: store.id,
            },
        });
    }
    console.log(`   ✅ Usuário "${adminUser.email}" criado\n`);
    console.log('📱 Criando instância Evolution demo...');
    await prisma.evolutionInstance.upsert({
        where: {
            tenantId_instanceName: {
                tenantId: tenant.id,
                instanceName: 'demo-instance-01',
            },
        },
        update: {},
        create: {
            tenantId: tenant.id,
            storeId: store.id,
            instanceName: 'demo-instance-01',
            apiKey: 'demo-api-key-change-me',
            webhookUrl: `${process.env.API_URL ?? 'http://localhost:3000'}/webhooks/evolution/demo-instance-01`,
            status: 'DISCONNECTED',
        },
    });
    console.log(`   ✅ Instância "demo-instance-01" criada\n`);
    console.log('🤖 Criando workflow N8N demo...');
    const evoInstance = await prisma.evolutionInstance.findFirstOrThrow({
        where: { tenantId: tenant.id, instanceName: 'demo-instance-01' },
    });
    await prisma.n8nWorkflow.upsert({
        where: {
            tenantId_n8nWorkflowId: {
                tenantId: tenant.id,
                n8nWorkflowId: 'wf-atendimento-inicial',
            },
        },
        update: {},
        create: {
            tenantId: tenant.id,
            evolutionInstanceId: evoInstance.id,
            n8nWorkflowId: 'wf-atendimento-inicial',
            name: 'Atendimento Inicial',
            description: 'Boas-vindas, menu principal e roteamento para departamentos',
            triggerType: 'MESSAGE_RECEIVED',
            isActive: true,
            settings: {
                timeoutMinutes: 10,
                maxRetries: 2,
                escalateOnTimeout: true,
            },
        },
    });
    console.log(`   ✅ Workflow "Atendimento Inicial" criado\n`);
    console.log('📦 Criando categorias e produtos demo...');
    const catEletronicos = await prisma.productCategory.upsert({
        where: { id: 'cat-eletronicos-001' },
        update: {},
        create: {
            id: 'cat-eletronicos-001',
            tenantId: tenant.id,
            name: 'Eletrônicos',
            description: 'Produtos eletrônicos em geral',
            isActive: true,
        },
    });
    const catAcessorios = await prisma.productCategory.upsert({
        where: { id: 'cat-acessorios-001' },
        update: {},
        create: {
            id: 'cat-acessorios-001',
            tenantId: tenant.id,
            parentId: catEletronicos.id,
            name: 'Acessórios',
            description: 'Acessórios para eletrônicos',
            isActive: true,
        },
    });
    const products = [
        {
            id: 'prod-001',
            sku: 'CABO-USB-C-01',
            name: 'Cabo USB-C 1m',
            price: 29.9,
            cost: 12.0,
            categoryId: catAcessorios.id,
        },
        {
            id: 'prod-002',
            sku: 'CARR-20W-01',
            name: 'Carregador 20W',
            price: 89.9,
            cost: 35.0,
            categoryId: catAcessorios.id,
        },
        {
            id: 'prod-003',
            sku: 'FONE-BT-01',
            name: 'Fone Bluetooth',
            price: 199.9,
            cost: 80.0,
            categoryId: catEletronicos.id,
        },
    ];
    for (const prod of products) {
        const p = await prisma.product.upsert({
            where: { tenantId_sku: { tenantId: tenant.id, sku: prod.sku } },
            update: {},
            create: {
                id: prod.id,
                tenantId: tenant.id,
                categoryId: prod.categoryId,
                sku: prod.sku,
                name: prod.name,
                price: prod.price,
                cost: prod.cost,
                unit: 'un',
                isActive: true,
            },
        });
        await prisma.stock.upsert({
            where: { productId_storeId: { productId: p.id, storeId: store.id } },
            update: {},
            create: {
                productId: p.id,
                storeId: store.id,
                quantity: 0,
                minQuantity: 5,
                maxQuantity: 100,
            },
        });
        console.log(`   ✅ Produto "${p.name}"`);
    }
    console.log();
    console.log('─'.repeat(50));
    console.log('🎉 Seed concluído com sucesso!\n');
    console.log('📌 Dados criados:');
    console.log(`   Tenant:        ${tenant.name} (slug: "${tenant.slug}")`);
    console.log(`   Loja:          ${store.name}`);
    console.log(`   Departamentos: ${departments.map((d) => d.name).join(', ')}`);
    console.log(`   Roles:         ${Object.keys(DEFAULT_ROLES).join(', ')}`);
    console.log(`   Permissões:    ${PERMISSIONS.length}`);
    console.log(`   Admin:         admin@demo.com / Admin@123`);
    console.log(`   Evolution:     demo-instance-01`);
    console.log(`   N8N workflow:  Atendimento Inicial`);
    console.log(`   Produtos:      ${products.length} (com saldo 0)`);
    console.log('─'.repeat(50));
}
main()
    .catch((e) => {
    console.error('❌ Erro no seed:', e);
    process.exit(1);
})
    .finally(() => prisma.$disconnect());
//# sourceMappingURL=seed.js.map