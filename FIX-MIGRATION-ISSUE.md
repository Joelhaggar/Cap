# Fix Migration Issue - 0008_condemned_gamora Missing

## Problem

The app is looking for `0008_condemned_gamora.sql` but it doesn't exist. The migration journal expects it, but:
- Your database already has the tables (from your custom migrations 0008 and 0009)
- The 0.3.72 release didn't actually include this migration file
- We just need to tell the database that migration 0008 is already "applied"

## Solution: Mark Migration as Applied

Since your database already has all the necessary tables and columns from your previous migrations, we just need to mark `0008_condemned_gamora` as completed in the Drizzle migrations table.

### Step 1: Connect to Your Database

```bash
# SSH into Dokploy server
ssh user@your-dokploy-server

# Find MySQL container
docker ps | grep mysql

# Connect to database
docker exec -it CONTAINER_NAME mysql -u root -p cap_db
```

### Step 2: Check Current Migration Status

```sql
-- See what migrations are recorded
SELECT * FROM __drizzle_migrations ORDER BY id;
```

You should see migrations 1-7 (ending at `0007_cheerful_rocket_raccoon`).

### Step 3: Manually Add Migration 0008

```sql
-- Insert the missing migration record
-- This tells Drizzle that migration 0008 has already been applied
INSERT INTO __drizzle_migrations (hash, created_at)
VALUES ('0008_condemned_gamora', 1759139970377);
```

### Step 4: Verify

```sql
-- Check it was added
SELECT * FROM __drizzle_migrations ORDER BY id;

-- Should now show migration for 0008_condemned_gamora

-- Exit MySQL
EXIT;
```

### Step 5: Restart Your Docker Container

```bash
# From Dokploy dashboard, restart the cap-web service
# OR via command line:
docker restart CAP_WEB_CONTAINER_NAME
```

## Alternative: Create Empty Migration File

If the above doesn't work, create a placeholder migration file:

```bash
# On your local machine
cd /Users/joel/DevProjects/Cap/Cap

# Create empty migration that does nothing
cat > packages/database/migrations/0008_condemned_gamora.sql <<'EOF'
-- Migration 0008: condemned_gamora
-- This migration is a placeholder - all changes were already applied via custom migrations
-- Tables already exist: notifications (from your 0008_add_notifications_table.sql)
-- Columns already exist: videos.duration (from your 0009_add_videos_duration.sql)

-- No changes needed
SELECT 1;
EOF

# Commit and push
git add packages/database/migrations/0008_condemned_gamora.sql
git commit -m "Add placeholder 0008 migration for compatibility"
git push origin test-0.3.72-compatibility
```

Then redeploy on Dokploy.

## Why This Happened

Your fork had:
- `0008_add_notifications_table.sql` (custom)
- `0009_add_videos_duration.sql` (custom)

The 0.3.72 release expects:
- `0008_condemned_gamora.sql` (which never actually existed!)

When we merged, the journal file got updated to reference `0008_condemned_gamora`, but the actual SQL file was never in the 0.3.72 release.

## Recommended Approach

**Use Step 1-4 above** (manually marking as applied) because:
- ✅ Your database already has all the tables/columns
- ✅ Faster than creating and deploying new migration
- ✅ More accurate (reflects actual state)

After fixing, the deployment should work!
