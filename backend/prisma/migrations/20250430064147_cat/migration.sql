-- DropForeignKey
ALTER TABLE "Services" DROP CONSTRAINT "Services_categoryId_fkey";

-- AlterTable
ALTER TABLE "Services" ALTER COLUMN "categoryId" DROP NOT NULL;

-- AddForeignKey
ALTER TABLE "Services" ADD CONSTRAINT "Services_categoryId_fkey" FOREIGN KEY ("categoryId") REFERENCES "Category"("id") ON DELETE SET NULL ON UPDATE CASCADE;
