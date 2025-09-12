-- Migration 0007: add_preferences_column
-- Adds missing preferences column to users table

ALTER TABLE `users` ADD `preferences` json DEFAULT NULL;