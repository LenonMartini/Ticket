import { PrismaClient } from '../src/generated/prisma';
import { PrismaPg } from '@prisma/adapter-pg';
import 'dotenv/config';

const adapter = new PrismaPg({ connectionString: process.env.DATABASE_URL! });
const prisma = new PrismaClient({ adapter });

// ─────────────────────────────────────────────────────────────
// Todas as permissões atômicas do sistema
// Formato: recurso:ação
// ─────────────────────────────────────────────────────────────
const PERMISSIONS = [
  // Tickets
  {
    key: 'tickets:read',
    resource: 'tickets',
    action: 'read',
    description: 'Visualizar tickets',
  },
  {
    key: 'tickets:read_all',
    resource: 'tickets',
    action: 'read_all',
    description: 'Visualizar todos os tickets (outros agentes)',
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
    description: 'Transferir tickets para setor ou agente',
  },
  {
    key: 'tickets:resolve',
    resource: 'tickets',
    action: 'resolve',
    description: 'Resolver tickets',
  },
  {
    key: 'tickets:close',
    resource: 'tickets',
    action: 'close',
    description: 'Encerrar tickets',
  },
  {
    key: 'tickets:reopen',
    resource: 'tickets',
    action: 'reopen',
    description: 'Reabrir tickets encerrados',
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
    description: 'Adicionar tags ao ticket',
  },

  // Mensagens
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

  // Contatos
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
    description: 'Bloquear contatos',
  },

  // Relatórios
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

  // Agentes
  {
    key: 'agents:read',
    resource: 'agents',
    action: 'read',
    description: 'Visualizar agentes',
  },
  {
    key: 'agents:create',
    resource: 'agents',
    action: 'create',
    description: 'Criar agentes',
  },
  {
    key: 'agents:update',
    resource: 'agents',
    action: 'update',
    description: 'Editar agentes',
  },
  {
    key: 'agents:delete',
    resource: 'agents',
    action: 'delete',
    description: 'Remover agentes',
  },

  // Grupos
  {
    key: 'groups:read',
    resource: 'groups',
    action: 'read',
    description: 'Visualizar grupos',
  },
  {
    key: 'groups:create',
    resource: 'groups',
    action: 'create',
    description: 'Criar grupos',
  },
  {
    key: 'groups:update',
    resource: 'groups',
    action: 'update',
    description: 'Editar grupos',
  },
  {
    key: 'groups:delete',
    resource: 'groups',
    action: 'delete',
    description: 'Remover grupos',
  },

  // Roles
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

  // Setores
  {
    key: 'sectors:read',
    resource: 'sectors',
    action: 'read',
    description: 'Visualizar setores',
  },
  {
    key: 'sectors:create',
    resource: 'sectors',
    action: 'create',
    description: 'Criar setores',
  },
  {
    key: 'sectors:update',
    resource: 'sectors',
    action: 'update',
    description: 'Editar setores',
  },
  {
    key: 'sectors:delete',
    resource: 'sectors',
    action: 'delete',
    description: 'Remover setores',
  },

  // Configurações do tenant
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
    description: 'Editar configurações do sistema',
  },

  // WhatsApp / Evolution
  {
    key: 'whatsapp:connect',
    resource: 'whatsapp',
    action: 'connect',
    description: 'Conectar/desconectar WhatsApp',
  },
  {
    key: 'whatsapp:read_status',
    resource: 'whatsapp',
    action: 'read_status',
    description: 'Visualizar status do WhatsApp',
  },
];

// ─────────────────────────────────────────────────────────────
// Roles padrão que todo tenant recebe ao ser criado
// ─────────────────────────────────────────────────────────────
const DEFAULT_ROLES: Record<
  string,
  { description: string; permissions: string[] }
> = {
  Administrador: {
    description: 'Acesso total ao sistema',
    permissions: PERMISSIONS.map((p) => p.key), // todas
  },
  Supervisor: {
    description: 'Gerencia equipes e visualiza todos os tickets',
    permissions: [
      'tickets:read',
      'tickets:read_all',
      'tickets:transfer',
      'tickets:resolve',
      'tickets:close',
      'tickets:reopen',
      'tickets:set_priority',
      'tickets:add_tag',
      'messages:read',
      'messages:send',
      'messages:send_internal',
      'contacts:read',
      'contacts:update',
      'reports:read',
      'reports:export',
      'agents:read',
      'groups:read',
      'roles:read',
      'sectors:read',
      'settings:read',
      'whatsapp:read_status',
    ],
  },
  Atendente: {
    description: 'Atende tickets do seu setor',
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
};

async function main() {
  console.log('🌱 Iniciando seed...');

  // 1. Upsert de todas as permissões
  console.log('📋 Criando permissões...');
  for (const perm of PERMISSIONS) {
    await prisma.permission.upsert({
      where: { key: perm.key },
      update: { description: perm.description },
      create: perm,
    });
  }
  console.log(`✅ ${PERMISSIONS.length} permissões criadas/atualizadas`);

  // 2. Seed de tenant de exemplo + roles padrão
  console.log('🏢 Criando tenant de exemplo...');
  const tenant = await prisma.tenant.upsert({
    where: { slug: 'demo' },
    update: {},
    create: {
      name: 'Empresa Demo',
      slug: 'demo',
      isActive: true,
      plan: 'PRO',
      settings: {
        create: {},
      },
    },
  });

  // 3. Cria roles padrão para o tenant demo
  console.log('🔐 Criando roles padrão...');
  for (const [roleName, roleData] of Object.entries(DEFAULT_ROLES)) {
    const perms = await prisma.permission.findMany({
      where: { key: { in: roleData.permissions } },
    });

    await prisma.role.upsert({
      where: { tenantId_name: { tenantId: tenant.id, name: roleName } },
      update: {},
      create: {
        tenantId: tenant.id,
        name: roleName,
        description: roleData.description,
        isSystem: true,
        isDefault: roleName === 'Atendente',
        permissions: {
          create: perms.map((p) => ({ permissionId: p.id })),
        },
      },
    });
    console.log(`  ✅ Role "${roleName}" com ${perms.length} permissões`);
  }

  console.log('\n🎉 Seed concluído!');
  console.log('   Tenant demo: slug = "demo"');
  console.log('   Roles criadas: Administrador, Supervisor, Atendente');
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(() => prisma.$disconnect());
