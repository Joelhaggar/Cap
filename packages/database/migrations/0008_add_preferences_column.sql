-- Migration 0008: add_preferences_column
-- Adds the missing preferences JSON column to users table
-- This migration will definitely run since it's a new migration file

ALTER TABLE `users` ADD COLUMN IF NOT EXISTS `preferences` json DEFAULT NULL;