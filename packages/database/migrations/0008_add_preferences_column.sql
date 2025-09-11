-- Migration 0008: add_preferences_column
-- Adds the missing preferences JSON column to users table

ALTER TABLE `users` ADD `preferences` JSON DEFAULT NULL;