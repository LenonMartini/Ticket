/*
  Warnings:

  - The values [CONTACT] on the enum `MessageType` will be removed. If these variants are still used in the database, this will fail.
  - The values [NOTE] on the enum `TicketEventType` will be removed. If these variants are still used in the database, this will fail.
  - The values [WAITING_BOT] on the enum `TicketStatus` will be removed. If these variants are still used in the database, this will fail.
  - You are about to drop the column `avatar` on the `contacts` table. All the data in the column will be lost.
  - You are about to drop the column `botState` on the `contacts` table. All the data in the column will be lost.
  - You are about to drop the column `agentId` on the `messages` table. All the data in the column will be lost.
  - You are about to drop the column `createdAt` on the `messages` table. All the data in the column will be lost.
  - You are about to drop the column `fromMe` on the `messages` table. All the data in the column will be lost.
  - You are about to drop the column `tenantId` on the `messages` table. All the data in the column will be lost.
  - You are about to drop the column `whatsappId` on the `messages` table. All the data in the column will be lost.
  - You are about to drop the column `evolutionInstance` on the `tenants` table. All the data in the column will be lost.
  - You are about to drop the column `evolutionStatus` on the `tenants` table. All the data in the column will be lost.
  - You are about to drop the column `agentId` on the `ticket_events` table. All the data in the column will be lost.
  - You are about to drop the column `tenantId` on the `ticket_events` table. All the data in the column will be lost.
  - You are about to drop the column `agentId` on the `tickets` table. All the data in the column will be lost.
  - You are about to drop the column `sectorId` on the `tickets` table. All the data in the column will be lost.
  - You are about to drop the column `avatar` on the `users` table. All the data in the column will be lost.
  - You are about to drop the column `password` on the `users` table. All the data in the column will be lost.
  - You are about to drop the `agent_groups` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `agent_roles` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `agent_sectors` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `agents` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `group_roles` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `group_sectors` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `groups` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `sectors` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `ticket_transfers` table. If the table is not empty, all the data it contains will be lost.
  - A unique constraint covering the columns `[evolutionMsgId]` on the table `messages` will be added. If there are existing duplicate values, this will fail.
  - A unique constraint covering the columns `[tenantId,email]` on the table `users` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `passwordHash` to the `users` table without a default value. This is not possible if the table is not empty.
  - Added the required column `tenantId` to the `users` table without a default value. This is not possible if the table is not empty.

*/
-- CreateEnum
CREATE TYPE "TicketChannel" AS ENUM ('WHATSAPP', 'EMAIL', 'MANUAL');

-- CreateEnum
CREATE TYPE "SenderType" AS ENUM ('CONTACT', 'AGENT', 'BOT', 'SYSTEM');

-- CreateEnum
CREATE TYPE "StockMovementType" AS ENUM ('IN', 'OUT', 'IN_NFE', 'OUT_SALE', 'ADJUSTMENT', 'TRANSFER');

-- CreateEnum
CREATE TYPE "NfeStatus" AS ENUM ('PENDING', 'PROCESSED', 'ERROR', 'CANCELLED');

-- CreateEnum
CREATE TYPE "BotSessionStatus" AS ENUM ('ACTIVE', 'WAITING', 'ESCALATED', 'FINISHED', 'ABANDONED');

-- CreateEnum
CREATE TYPE "N8nTriggerType" AS ENUM ('WEBHOOK', 'MESSAGE_RECEIVED', 'TICKET_CREATED', 'TICKET_CLOSED', 'SCHEDULED');

-- CreateEnum
CREATE TYPE "N8nExecutionStatus" AS ENUM ('RUNNING', 'SUCCESS', 'ERROR', 'TIMEOUT');

-- AlterEnum
ALTER TYPE "EvolutionStatus" ADD VALUE 'QR_PENDING';

-- AlterEnum
BEGIN;
CREATE TYPE "MessageType_new" AS ENUM ('TEXT', 'IMAGE', 'VIDEO', 'AUDIO', 'DOCUMENT', 'STICKER', 'LOCATION', 'CONTACT_CARD', 'SYSTEM', 'NOTE');
ALTER TABLE "public"."messages" ALTER COLUMN "type" DROP DEFAULT;
ALTER TABLE "messages" ALTER COLUMN "type" TYPE "MessageType_new" USING ("type"::text::"MessageType_new");
ALTER TYPE "MessageType" RENAME TO "MessageType_old";
ALTER TYPE "MessageType_new" RENAME TO "MessageType";
DROP TYPE "public"."MessageType_old";
ALTER TABLE "messages" ALTER COLUMN "type" SET DEFAULT 'TEXT';
COMMIT;

-- AlterEnum
BEGIN;
CREATE TYPE "TicketEventType_new" AS ENUM ('CREATED', 'BOT_STARTED', 'BOT_ESCALATED', 'BOT_FINISHED', 'ASSUMED', 'TRANSFERRED', 'RESOLVED', 'CLOSED', 'REOPENED', 'PRIORITY_CHANGED', 'TAG_ADDED', 'TAG_REMOVED', 'NOTE_ADDED');
ALTER TABLE "ticket_events" ALTER COLUMN "type" TYPE "TicketEventType_new" USING ("type"::text::"TicketEventType_new");
ALTER TYPE "TicketEventType" RENAME TO "TicketEventType_old";
ALTER TYPE "TicketEventType_new" RENAME TO "TicketEventType";
DROP TYPE "public"."TicketEventType_old";
COMMIT;

-- AlterEnum
BEGIN;
CREATE TYPE "TicketStatus_new" AS ENUM ('PENDING', 'BOT_ACTIVE', 'OPEN', 'WAITING', 'TRANSFERRED', 'RESOLVED', 'CLOSED');
ALTER TABLE "public"."tickets" ALTER COLUMN "status" DROP DEFAULT;
ALTER TABLE "tickets" ALTER COLUMN "status" TYPE "TicketStatus_new" USING ("status"::text::"TicketStatus_new");
ALTER TYPE "TicketStatus" RENAME TO "TicketStatus_old";
ALTER TYPE "TicketStatus_new" RENAME TO "TicketStatus";
DROP TYPE "public"."TicketStatus_old";
ALTER TABLE "tickets" ALTER COLUMN "status" SET DEFAULT 'PENDING';
COMMIT;

-- DropForeignKey
ALTER TABLE "agent_groups" DROP CONSTRAINT "agent_groups_agentId_fkey";

-- DropForeignKey
ALTER TABLE "agent_groups" DROP CONSTRAINT "agent_groups_groupId_fkey";

-- DropForeignKey
ALTER TABLE "agent_roles" DROP CONSTRAINT "agent_roles_agentId_fkey";

-- DropForeignKey
ALTER TABLE "agent_roles" DROP CONSTRAINT "agent_roles_roleId_fkey";

-- DropForeignKey
ALTER TABLE "agent_sectors" DROP CONSTRAINT "agent_sectors_agentId_fkey";

-- DropForeignKey
ALTER TABLE "agent_sectors" DROP CONSTRAINT "agent_sectors_sectorId_fkey";

-- DropForeignKey
ALTER TABLE "agents" DROP CONSTRAINT "agents_tenantId_fkey";

-- DropForeignKey
ALTER TABLE "agents" DROP CONSTRAINT "agents_userId_fkey";

-- DropForeignKey
ALTER TABLE "group_roles" DROP CONSTRAINT "group_roles_groupId_fkey";

-- DropForeignKey
ALTER TABLE "group_roles" DROP CONSTRAINT "group_roles_roleId_fkey";

-- DropForeignKey
ALTER TABLE "group_sectors" DROP CONSTRAINT "group_sectors_groupId_fkey";

-- DropForeignKey
ALTER TABLE "group_sectors" DROP CONSTRAINT "group_sectors_sectorId_fkey";

-- DropForeignKey
ALTER TABLE "groups" DROP CONSTRAINT "groups_tenantId_fkey";

-- DropForeignKey
ALTER TABLE "messages" DROP CONSTRAINT "messages_agentId_fkey";

-- DropForeignKey
ALTER TABLE "sectors" DROP CONSTRAINT "sectors_tenantId_fkey";

-- DropForeignKey
ALTER TABLE "ticket_events" DROP CONSTRAINT "ticket_events_agentId_fkey";

-- DropForeignKey
ALTER TABLE "ticket_transfers" DROP CONSTRAINT "ticket_transfers_fromAgentId_fkey";

-- DropForeignKey
ALTER TABLE "ticket_transfers" DROP CONSTRAINT "ticket_transfers_ticketId_fkey";

-- DropForeignKey
ALTER TABLE "ticket_transfers" DROP CONSTRAINT "ticket_transfers_toAgentId_fkey";

-- DropForeignKey
ALTER TABLE "ticket_transfers" DROP CONSTRAINT "ticket_transfers_toSectorId_fkey";

-- DropForeignKey
ALTER TABLE "tickets" DROP CONSTRAINT "tickets_agentId_fkey";

-- DropForeignKey
ALTER TABLE "tickets" DROP CONSTRAINT "tickets_sectorId_fkey";

-- DropIndex
DROP INDEX "messages_tenantId_idx";

-- DropIndex
DROP INDEX "messages_whatsappId_key";

-- DropIndex
DROP INDEX "tickets_tenantId_agentId_idx";

-- DropIndex
DROP INDEX "tickets_tenantId_sectorId_idx";

-- DropIndex
DROP INDEX "users_email_key";

-- AlterTable
ALTER TABLE "contacts" DROP COLUMN "avatar",
DROP COLUMN "botState",
ADD COLUMN     "avatarUrl" TEXT,
ADD COLUMN     "extraData" JSONB;

-- AlterTable
ALTER TABLE "messages" DROP COLUMN "agentId",
DROP COLUMN "createdAt",
DROP COLUMN "fromMe",
DROP COLUMN "tenantId",
DROP COLUMN "whatsappId",
ADD COLUMN     "evolutionMsgId" TEXT,
ADD COLUMN     "isRead" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "senderType" "SenderType" NOT NULL DEFAULT 'CONTACT',
ADD COLUMN     "senderUserId" TEXT,
ADD COLUMN     "sentAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP;

-- AlterTable
ALTER TABLE "tenant_settings" ADD COLUMN     "maxTicketsPerAgent" INTEGER NOT NULL DEFAULT 10;

-- AlterTable
ALTER TABLE "tenants" DROP COLUMN "evolutionInstance",
DROP COLUMN "evolutionStatus";

-- AlterTable
ALTER TABLE "ticket_events" DROP COLUMN "agentId",
DROP COLUMN "tenantId",
ADD COLUMN     "changes" JSONB,
ADD COLUMN     "userId" TEXT;

-- AlterTable
ALTER TABLE "tickets" DROP COLUMN "agentId",
DROP COLUMN "sectorId",
ADD COLUMN     "assignedTo" TEXT,
ADD COLUMN     "channel" "TicketChannel" NOT NULL DEFAULT 'WHATSAPP',
ADD COLUMN     "departmentId" TEXT,
ADD COLUMN     "evolutionInstanceId" TEXT,
ADD COLUMN     "isBotActive" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "openedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN     "storeId" TEXT;

-- AlterTable
ALTER TABLE "users" DROP COLUMN "avatar",
DROP COLUMN "password",
ADD COLUMN     "avatarUrl" TEXT,
ADD COLUMN     "lastLogin" TIMESTAMP(3),
ADD COLUMN     "passwordHash" TEXT NOT NULL,
ADD COLUMN     "tenantId" TEXT NOT NULL;

-- DropTable
DROP TABLE "agent_groups";

-- DropTable
DROP TABLE "agent_roles";

-- DropTable
DROP TABLE "agent_sectors";

-- DropTable
DROP TABLE "agents";

-- DropTable
DROP TABLE "group_roles";

-- DropTable
DROP TABLE "group_sectors";

-- DropTable
DROP TABLE "groups";

-- DropTable
DROP TABLE "sectors";

-- DropTable
DROP TABLE "ticket_transfers";

-- DropEnum
DROP TYPE "BotState";

-- CreateTable
CREATE TABLE "stores" (
    "id" TEXT NOT NULL,
    "tenantId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "phone" TEXT,
    "address" TEXT,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "settings" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "stores_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "departments" (
    "id" TEXT NOT NULL,
    "tenantId" TEXT NOT NULL,
    "storeId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "color" TEXT NOT NULL DEFAULT '#6366f1',
    "menuOption" INTEGER,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "departments_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_roles" (
    "id" TEXT NOT NULL,
    "userId" TEXT NOT NULL,
    "roleId" TEXT NOT NULL,
    "storeId" TEXT,
    "departmentId" TEXT,
    "assignedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "user_roles_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "evolution_instances" (
    "id" TEXT NOT NULL,
    "tenantId" TEXT NOT NULL,
    "storeId" TEXT,
    "instanceName" TEXT NOT NULL,
    "phoneNumber" TEXT,
    "apiKey" TEXT NOT NULL,
    "webhookUrl" TEXT,
    "status" "EvolutionStatus" NOT NULL DEFAULT 'DISCONNECTED',
    "qrCode" TEXT,
    "connectedAt" TIMESTAMP(3),
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "evolution_instances_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "n8n_workflows" (
    "id" TEXT NOT NULL,
    "tenantId" TEXT NOT NULL,
    "evolutionInstanceId" TEXT,
    "n8nWorkflowId" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "triggerType" "N8nTriggerType" NOT NULL DEFAULT 'MESSAGE_RECEIVED',
    "triggerEvent" TEXT,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "settings" JSONB,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "n8n_workflows_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "bot_sessions" (
    "id" TEXT NOT NULL,
    "tenantId" TEXT NOT NULL,
    "contactId" TEXT NOT NULL,
    "evolutionInstanceId" TEXT NOT NULL,
    "n8nWorkflowId" TEXT,
    "ticketId" TEXT,
    "status" "BotSessionStatus" NOT NULL DEFAULT 'ACTIVE',
    "currentStep" TEXT,
    "context" JSONB,
    "interactionsCount" INTEGER NOT NULL DEFAULT 0,
    "startedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "lastInteractionAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "finishedAt" TIMESTAMP(3),

    CONSTRAINT "bot_sessions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "n8n_executions" (
    "id" TEXT NOT NULL,
    "n8nWorkflowId" TEXT NOT NULL,
    "botSessionId" TEXT,
    "ticketId" TEXT,
    "n8nExecutionId" TEXT,
    "status" "N8nExecutionStatus" NOT NULL DEFAULT 'RUNNING',
    "triggerEvent" TEXT,
    "inputData" JSONB,
    "outputData" JSONB,
    "errorMessage" TEXT,
    "durationMs" INTEGER,
    "startedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "finishedAt" TIMESTAMP(3),

    CONSTRAINT "n8n_executions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "product_categories" (
    "id" TEXT NOT NULL,
    "tenantId" TEXT NOT NULL,
    "parentId" TEXT,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "product_categories_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "products" (
    "id" TEXT NOT NULL,
    "tenantId" TEXT NOT NULL,
    "categoryId" TEXT,
    "sku" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT,
    "price" DECIMAL(12,2) NOT NULL,
    "cost" DECIMAL(12,2) NOT NULL DEFAULT 0,
    "unit" TEXT NOT NULL DEFAULT 'un',
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "products_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "stock" (
    "id" TEXT NOT NULL,
    "productId" TEXT NOT NULL,
    "storeId" TEXT NOT NULL,
    "quantity" DECIMAL(12,3) NOT NULL DEFAULT 0,
    "minQuantity" DECIMAL(12,3) NOT NULL DEFAULT 0,
    "maxQuantity" DECIMAL(12,3) NOT NULL DEFAULT 0,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "stock_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "stock_movements" (
    "id" TEXT NOT NULL,
    "productId" TEXT NOT NULL,
    "storeId" TEXT NOT NULL,
    "userId" TEXT,
    "type" "StockMovementType" NOT NULL,
    "quantity" DECIMAL(12,3) NOT NULL,
    "unitCost" DECIMAL(12,2) NOT NULL DEFAULT 0,
    "referenceId" TEXT,
    "referenceType" TEXT,
    "notes" TEXT,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "stock_movements_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "nfe_imports" (
    "id" TEXT NOT NULL,
    "tenantId" TEXT NOT NULL,
    "storeId" TEXT NOT NULL,
    "userId" TEXT,
    "accessKey" TEXT NOT NULL,
    "supplierName" TEXT NOT NULL,
    "supplierCnpj" TEXT NOT NULL,
    "totalValue" DECIMAL(12,2) NOT NULL,
    "status" "NfeStatus" NOT NULL DEFAULT 'PENDING',
    "rawXml" TEXT,
    "issuedAt" TIMESTAMP(3) NOT NULL,
    "importedAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "nfe_imports_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "nfe_items" (
    "id" TEXT NOT NULL,
    "nfeId" TEXT NOT NULL,
    "productId" TEXT,
    "productCode" TEXT NOT NULL,
    "description" TEXT NOT NULL,
    "ncm" TEXT,
    "quantity" DECIMAL(12,3) NOT NULL,
    "unitPrice" DECIMAL(12,4) NOT NULL,
    "totalPrice" DECIMAL(12,2) NOT NULL,

    CONSTRAINT "nfe_items_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE INDEX "stores_tenantId_idx" ON "stores"("tenantId");

-- CreateIndex
CREATE INDEX "departments_tenantId_idx" ON "departments"("tenantId");

-- CreateIndex
CREATE INDEX "departments_storeId_idx" ON "departments"("storeId");

-- CreateIndex
CREATE INDEX "user_roles_userId_idx" ON "user_roles"("userId");

-- CreateIndex
CREATE INDEX "user_roles_roleId_idx" ON "user_roles"("roleId");

-- CreateIndex
CREATE UNIQUE INDEX "user_roles_userId_roleId_storeId_departmentId_key" ON "user_roles"("userId", "roleId", "storeId", "departmentId");

-- CreateIndex
CREATE INDEX "evolution_instances_tenantId_idx" ON "evolution_instances"("tenantId");

-- CreateIndex
CREATE UNIQUE INDEX "evolution_instances_tenantId_instanceName_key" ON "evolution_instances"("tenantId", "instanceName");

-- CreateIndex
CREATE INDEX "n8n_workflows_tenantId_idx" ON "n8n_workflows"("tenantId");

-- CreateIndex
CREATE UNIQUE INDEX "n8n_workflows_tenantId_n8nWorkflowId_key" ON "n8n_workflows"("tenantId", "n8nWorkflowId");

-- CreateIndex
CREATE UNIQUE INDEX "bot_sessions_ticketId_key" ON "bot_sessions"("ticketId");

-- CreateIndex
CREATE INDEX "bot_sessions_tenantId_idx" ON "bot_sessions"("tenantId");

-- CreateIndex
CREATE INDEX "bot_sessions_contactId_idx" ON "bot_sessions"("contactId");

-- CreateIndex
CREATE INDEX "bot_sessions_evolutionInstanceId_idx" ON "bot_sessions"("evolutionInstanceId");

-- CreateIndex
CREATE INDEX "n8n_executions_n8nWorkflowId_idx" ON "n8n_executions"("n8nWorkflowId");

-- CreateIndex
CREATE INDEX "n8n_executions_botSessionId_idx" ON "n8n_executions"("botSessionId");

-- CreateIndex
CREATE INDEX "product_categories_tenantId_idx" ON "product_categories"("tenantId");

-- CreateIndex
CREATE INDEX "products_tenantId_idx" ON "products"("tenantId");

-- CreateIndex
CREATE UNIQUE INDEX "products_tenantId_sku_key" ON "products"("tenantId", "sku");

-- CreateIndex
CREATE UNIQUE INDEX "stock_productId_storeId_key" ON "stock"("productId", "storeId");

-- CreateIndex
CREATE INDEX "stock_movements_productId_idx" ON "stock_movements"("productId");

-- CreateIndex
CREATE INDEX "stock_movements_storeId_idx" ON "stock_movements"("storeId");

-- CreateIndex
CREATE INDEX "stock_movements_referenceId_idx" ON "stock_movements"("referenceId");

-- CreateIndex
CREATE UNIQUE INDEX "nfe_imports_accessKey_key" ON "nfe_imports"("accessKey");

-- CreateIndex
CREATE INDEX "nfe_imports_tenantId_idx" ON "nfe_imports"("tenantId");

-- CreateIndex
CREATE INDEX "nfe_imports_storeId_idx" ON "nfe_imports"("storeId");

-- CreateIndex
CREATE INDEX "nfe_items_nfeId_idx" ON "nfe_items"("nfeId");

-- CreateIndex
CREATE UNIQUE INDEX "messages_evolutionMsgId_key" ON "messages"("evolutionMsgId");

-- CreateIndex
CREATE INDEX "tickets_tenantId_assignedTo_idx" ON "tickets"("tenantId", "assignedTo");

-- CreateIndex
CREATE INDEX "tickets_tenantId_departmentId_idx" ON "tickets"("tenantId", "departmentId");

-- CreateIndex
CREATE INDEX "users_tenantId_idx" ON "users"("tenantId");

-- CreateIndex
CREATE UNIQUE INDEX "users_tenantId_email_key" ON "users"("tenantId", "email");

-- AddForeignKey
ALTER TABLE "users" ADD CONSTRAINT "users_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "tenants"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "stores" ADD CONSTRAINT "stores_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "tenants"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "departments" ADD CONSTRAINT "departments_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "tenants"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "departments" ADD CONSTRAINT "departments_storeId_fkey" FOREIGN KEY ("storeId") REFERENCES "stores"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_roles" ADD CONSTRAINT "user_roles_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_roles" ADD CONSTRAINT "user_roles_roleId_fkey" FOREIGN KEY ("roleId") REFERENCES "roles"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_roles" ADD CONSTRAINT "user_roles_storeId_fkey" FOREIGN KEY ("storeId") REFERENCES "stores"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_roles" ADD CONSTRAINT "user_roles_departmentId_fkey" FOREIGN KEY ("departmentId") REFERENCES "departments"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "evolution_instances" ADD CONSTRAINT "evolution_instances_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "tenants"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "evolution_instances" ADD CONSTRAINT "evolution_instances_storeId_fkey" FOREIGN KEY ("storeId") REFERENCES "stores"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "n8n_workflows" ADD CONSTRAINT "n8n_workflows_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "tenants"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "n8n_workflows" ADD CONSTRAINT "n8n_workflows_evolutionInstanceId_fkey" FOREIGN KEY ("evolutionInstanceId") REFERENCES "evolution_instances"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "bot_sessions" ADD CONSTRAINT "bot_sessions_contactId_fkey" FOREIGN KEY ("contactId") REFERENCES "contacts"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "bot_sessions" ADD CONSTRAINT "bot_sessions_evolutionInstanceId_fkey" FOREIGN KEY ("evolutionInstanceId") REFERENCES "evolution_instances"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "bot_sessions" ADD CONSTRAINT "bot_sessions_n8nWorkflowId_fkey" FOREIGN KEY ("n8nWorkflowId") REFERENCES "n8n_workflows"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "bot_sessions" ADD CONSTRAINT "bot_sessions_ticketId_fkey" FOREIGN KEY ("ticketId") REFERENCES "tickets"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "n8n_executions" ADD CONSTRAINT "n8n_executions_n8nWorkflowId_fkey" FOREIGN KEY ("n8nWorkflowId") REFERENCES "n8n_workflows"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "n8n_executions" ADD CONSTRAINT "n8n_executions_botSessionId_fkey" FOREIGN KEY ("botSessionId") REFERENCES "bot_sessions"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tickets" ADD CONSTRAINT "tickets_storeId_fkey" FOREIGN KEY ("storeId") REFERENCES "stores"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tickets" ADD CONSTRAINT "tickets_departmentId_fkey" FOREIGN KEY ("departmentId") REFERENCES "departments"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tickets" ADD CONSTRAINT "tickets_assignedTo_fkey" FOREIGN KEY ("assignedTo") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tickets" ADD CONSTRAINT "tickets_evolutionInstanceId_fkey" FOREIGN KEY ("evolutionInstanceId") REFERENCES "evolution_instances"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "messages" ADD CONSTRAINT "messages_senderUserId_fkey" FOREIGN KEY ("senderUserId") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ticket_events" ADD CONSTRAINT "ticket_events_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "product_categories" ADD CONSTRAINT "product_categories_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "tenants"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "product_categories" ADD CONSTRAINT "product_categories_parentId_fkey" FOREIGN KEY ("parentId") REFERENCES "product_categories"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "products" ADD CONSTRAINT "products_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "tenants"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "products" ADD CONSTRAINT "products_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "product_categories"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "stock" ADD CONSTRAINT "stock_productId_fkey" FOREIGN KEY ("productId") REFERENCES "products"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "stock" ADD CONSTRAINT "stock_storeId_fkey" FOREIGN KEY ("storeId") REFERENCES "stores"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "stock_movements" ADD CONSTRAINT "stock_movements_productId_fkey" FOREIGN KEY ("productId") REFERENCES "products"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "stock_movements" ADD CONSTRAINT "stock_movements_storeId_fkey" FOREIGN KEY ("storeId") REFERENCES "stores"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "stock_movements" ADD CONSTRAINT "stock_movements_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "nfe_imports" ADD CONSTRAINT "nfe_imports_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "tenants"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "nfe_imports" ADD CONSTRAINT "nfe_imports_storeId_fkey" FOREIGN KEY ("storeId") REFERENCES "stores"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "nfe_imports" ADD CONSTRAINT "nfe_imports_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "nfe_items" ADD CONSTRAINT "nfe_items_nfeId_fkey" FOREIGN KEY ("nfeId") REFERENCES "nfe_imports"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "nfe_items" ADD CONSTRAINT "nfe_items_productId_fkey" FOREIGN KEY ("productId") REFERENCES "products"("id") ON DELETE SET NULL ON UPDATE CASCADE;
