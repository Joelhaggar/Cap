-- Migration 0007: cheerful_rocket_raccoon
-- Add preferences column to users table

ALTER TABLE `users` ADD `preferences` json;