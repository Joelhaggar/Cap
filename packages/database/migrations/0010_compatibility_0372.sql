-- Migration: Add compatibility columns for Cap 0.3.72
-- This migration adds missing columns that the 0.3.72 desktop app expects

-- Add defaultOrgId column to users table
ALTER TABLE `users` ADD COLUMN `defaultOrgId` varchar(15) NULL;

-- Add settings column to organizations table
ALTER TABLE `organizations` ADD COLUMN `settings` json NULL;

-- Add index on defaultOrgId for performance
CREATE INDEX `default_org_id_idx` ON `users` (`defaultOrgId`);
