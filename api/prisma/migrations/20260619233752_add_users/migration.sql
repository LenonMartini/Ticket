/*
  Warnings:

  - You are about to drop the column `avatar` on the `agents` table. All the data in the column will be lost.
  - You are about to drop the column `email` on the `agents` table. All the data in the column will be lost.
  - You are about to drop the column `name` on the `agents` table. All the data in the column will be lost.
  - You are about to drop the column `password` on the `agents` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[tenantId,userId]` on the table `agents` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `userId` to the `agents` table without a default value. This is not possible if the table is not empty.

*/
-- DropIndex
DROP INDEX "agents_tenantId_email_key";

-- AlterTable
ALTER TABLE "agents" DROP COLUMN "avatar",
DROP COLUMN "email",
DROP COLUMN "name",
DROP COLUMN "password",
ADD COLUMN     "userId" TEXT NOT NULL;

-- CreateTable
CREATE TABLE "users" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "avatar" TEXT,
    "isActive" BOOLEAN NOT NULL DEFAULT true,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- CreateIndex
CREATE UNIQUE INDEX "agents_tenantId_userId_key" ON "agents"("tenantId", "userId");

-- AddForeignKey
ALTER TABLE "agents" ADD CONSTRAINT "agents_userId_fkey" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
