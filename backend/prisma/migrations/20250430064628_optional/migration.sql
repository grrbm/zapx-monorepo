-- DropForeignKey
ALTER TABLE "Scheduler" DROP CONSTRAINT "Scheduler_categoryId_fkey";

-- AlterTable
ALTER TABLE "Scheduler" ALTER COLUMN "categoryId" DROP NOT NULL;

-- AddForeignKey
ALTER TABLE "Scheduler" ADD CONSTRAINT "Scheduler_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "Category"("id") ON DELETE SET NULL ON UPDATE CASCADE;
