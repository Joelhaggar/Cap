-- Migration 0008: condemned_gamora
-- This is a compatibility placeholder migration
--
-- CONTEXT:
-- The original 0.3.72 release referenced this migration in the journal
-- but the actual SQL file was never created in the upstream repo.
--
-- Your fork already applied equivalent changes via:
-- - 0008_add_notifications_table.sql (added notifications table)
-- - 0009_add_videos_duration.sql (added duration column)
--
-- This file exists purely for migration system compatibility.
-- All necessary schema changes have already been applied.

-- No-op query to satisfy migration runner
SELECT 1 AS migration_placeholder;
