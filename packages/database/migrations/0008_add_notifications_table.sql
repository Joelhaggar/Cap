-- Migration 0009: add_notifications_table
-- Adds missing notifications table

CREATE TABLE IF NOT EXISTS `notifications` (
    `id` varchar(15) NOT NULL PRIMARY KEY,
    `orgId` varchar(15) NOT NULL,
    `recipientId` varchar(15) NOT NULL,
    `type` varchar(10) NOT NULL,
    `data` json NOT NULL,
    `readAt` timestamp NULL,
    `createdAt` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
    INDEX `recipient_id_idx` (`recipientId`),
    INDEX `org_id_idx` (`orgId`),
    INDEX `type_idx` (`type`),
    INDEX `read_at_idx` (`readAt`),
    INDEX `created_at_idx` (`createdAt`),
    INDEX `recipient_read_idx` (`recipientId`, `readAt`),
    INDEX `recipient_created_idx` (`recipientId`, `createdAt`)
);