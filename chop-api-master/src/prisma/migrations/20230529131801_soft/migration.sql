-- AlterTable
ALTER TABLE `inventory` ADD COLUMN `deleted` BOOLEAN NOT NULL DEFAULT false;

-- AlterTable
ALTER TABLE `notification` ADD COLUMN `deleted` BOOLEAN NOT NULL DEFAULT false;

-- AlterTable
ALTER TABLE `rescue` ADD COLUMN `deleted` BOOLEAN NOT NULL DEFAULT false;

-- AlterTable
ALTER TABLE `rescueinventory` ADD COLUMN `deleted` BOOLEAN NOT NULL DEFAULT false;

-- AlterTable
ALTER TABLE `review` ADD COLUMN `deleted` BOOLEAN NOT NULL DEFAULT false;

-- AlterTable
ALTER TABLE `user` ADD COLUMN `deleted` BOOLEAN NOT NULL DEFAULT false;

-- AlterTable
ALTER TABLE `usernotification` ADD COLUMN `deleted` BOOLEAN NOT NULL DEFAULT false;
