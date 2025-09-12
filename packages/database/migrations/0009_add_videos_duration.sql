-- Migration 0010: add_videos_duration
-- Adds missing duration column to videos table

ALTER TABLE `videos` ADD `duration` float;