-- DropForeignKey
ALTER TABLE `inventory` DROP FOREIGN KEY `Inventory_vendor_id_fkey`;

-- DropForeignKey
ALTER TABLE `notification` DROP FOREIGN KEY `Notification_inventory_id_fkey`;

-- DropForeignKey
ALTER TABLE `rescue` DROP FOREIGN KEY `Rescue_fii_id_fkey`;

-- DropForeignKey
ALTER TABLE `rescue` DROP FOREIGN KEY `Rescue_vendor_id_fkey`;

-- DropForeignKey
ALTER TABLE `rescueinventory` DROP FOREIGN KEY `RescueInventory_inventory_id_fkey`;

-- DropForeignKey
ALTER TABLE `rescueinventory` DROP FOREIGN KEY `RescueInventory_rescue_id_fkey`;

-- DropForeignKey
ALTER TABLE `review` DROP FOREIGN KEY `Review_fii_id_fkey`;

-- DropForeignKey
ALTER TABLE `review` DROP FOREIGN KEY `Review_vendor_id_fkey`;

-- DropForeignKey
ALTER TABLE `usernotification` DROP FOREIGN KEY `UserNotification_notification_id_fkey`;

-- DropForeignKey
ALTER TABLE `usernotification` DROP FOREIGN KEY `UserNotification_user_id_fkey`;

-- AddForeignKey
ALTER TABLE `Inventory` ADD CONSTRAINT `Inventory_vendor_id_fkey` FOREIGN KEY (`vendor_id`) REFERENCES `User`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Review` ADD CONSTRAINT `Review_vendor_id_fkey` FOREIGN KEY (`vendor_id`) REFERENCES `User`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Review` ADD CONSTRAINT `Review_fii_id_fkey` FOREIGN KEY (`fii_id`) REFERENCES `User`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Rescue` ADD CONSTRAINT `Rescue_fii_id_fkey` FOREIGN KEY (`fii_id`) REFERENCES `User`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Rescue` ADD CONSTRAINT `Rescue_vendor_id_fkey` FOREIGN KEY (`vendor_id`) REFERENCES `User`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `RescueInventory` ADD CONSTRAINT `RescueInventory_rescue_id_fkey` FOREIGN KEY (`rescue_id`) REFERENCES `Rescue`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `RescueInventory` ADD CONSTRAINT `RescueInventory_inventory_id_fkey` FOREIGN KEY (`inventory_id`) REFERENCES `Inventory`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Notification` ADD CONSTRAINT `Notification_inventory_id_fkey` FOREIGN KEY (`inventory_id`) REFERENCES `Inventory`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `UserNotification` ADD CONSTRAINT `UserNotification_notification_id_fkey` FOREIGN KEY (`notification_id`) REFERENCES `Notification`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `UserNotification` ADD CONSTRAINT `UserNotification_user_id_fkey` FOREIGN KEY (`user_id`) REFERENCES `User`(`id`) ON DELETE CASCADE ON UPDATE CASCADE;
