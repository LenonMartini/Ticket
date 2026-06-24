import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { PrismaModule } from './prisma/prisma.module';
import { TenantModule } from './tenant/tenant.module';
import { RbacModule } from './rbac/rbac.module';
import { AuthModule } from './auth/auth.module';
import { AgentsModule } from './agents/agents.module';
import { SectorsModule } from './sectors/sectors.module';
import { GroupsModule } from './groups/groups.module';
import { RolesModule } from './roles/roles.module';
import { ContactsModule } from './contacts/contacts.module';
import { TicketsModule } from './tickets/tickets.module';
import { MessagesModule } from './messages/messages.module';
import { WebhookModule } from './webhook/webhook.module';
import { GatewayModule } from './gateway/gateway.module';
import { EvolutionModule } from './evolution/evolution.module';

@Module({
  imports: [PrismaModule, TenantModule, RbacModule, AuthModule, AgentsModule, SectorsModule, GroupsModule, RolesModule, ContactsModule, TicketsModule, MessagesModule, WebhookModule, GatewayModule, EvolutionModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
