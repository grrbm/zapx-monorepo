/*
  Warnings:

  - You are about to drop the column `rate` on the `Scheduler` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "Scheduler" DROP COLUMN "rate";

-- AlterTable
ALTER TABLE "Time" ADD COLUMN     "rate" DOUBLE PRECISION NOT NULL DEFAULT 0;
