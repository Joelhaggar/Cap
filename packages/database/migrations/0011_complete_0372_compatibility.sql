-- Migration 0011: Complete 0.3.72 compatibility
-- Adds all missing columns and tables that 0.3.72 code expects

-- Add orgId to videos (if not exists)
ALTER TABLE `videos` ADD COLUMN IF NOT EXISTS `orgId` varchar(15) NULL;
CREATE INDEX IF NOT EXISTS `org_id_idx` ON `videos` (`orgId`);

-- Add settings to videos (if not exists)
ALTER TABLE `videos` ADD COLUMN IF NOT EXISTS `settings` json NULL;

-- Add defaultOrgId to users (if not exists)
ALTER TABLE `users` ADD COLUMN IF NOT EXISTS `defaultOrgId` varchar(15) NULL;
CREATE INDEX IF NOT EXISTS `default_org_id_idx` ON `users` (`defaultOrgId`);

-- Add settings to organizations (if not exists)
ALTER TABLE `organizations` ADD COLUMN IF NOT EXISTS `settings` json NULL;

-- Create video_uploads table (if not exists)
CREATE TABLE IF NOT EXISTS `video_uploads` (
  `id` varchar(15) NOT NULL,
  `video_id` varchar(15) NOT NULL,
  `upload_id` varchar(255) NOT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'pending',
  `parts` json DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `video_uploads_id_unique` (`id`),
  KEY `video_id_idx` (`video_id`),
  KEY `upload_id_idx` (`upload_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Populate orgId for existing videos
UPDATE videos v
JOIN users u ON v.ownerId = u.id
SET v.orgId = u.activeOrganizationId
WHERE v.orgId IS NULL AND u.activeOrganizationId IS NOT NULL;

-- Populate defaultOrgId for existing users
UPDATE users
SET defaultOrgId = activeOrganizationId
WHERE defaultOrgId IS NULL AND activeOrganizationId IS NOT NULL;
