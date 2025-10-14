# Test Deployment Guide - Cap 0.3.72 Compatibility

## Overview

This guide will help you deploy and test the `test-0.3.72-compatibility` branch on Dokploy to fix desktop app authentication issues.

## What This Branch Fixes

- **Desktop app authentication** - Adds missing `users.defaultOrgId` column
- **Pro account recognition** - Adds `organizations.settings` JSON column
- **Session persistence** - Desktop app will stop asking to log in repeatedly
- **Version compatibility** - Syncs self-hosted web app with desktop app 0.3.72

## Pre-Deployment Checklist

### 1. Backup Your Database

**CRITICAL: Create a backup before proceeding!**

```bash
# SSH into your Dokploy server
ssh user@your-dokploy-server

# Find your MySQL container
docker ps | grep mysql

# Create backup
docker exec MYSQL_CONTAINER mysqldump -u root -p[password] cap_db > /tmp/cap_db_backup_$(date +%Y%m%d_%H%M%S).sql

# Download backup to your local machine
scp user@your-dokploy-server:/tmp/cap_db_backup_*.sql ~/backups/
```

## Deployment Steps

### Step 1: Apply Database Migration

The test branch includes migration file `0010_compatibility_0372.sql`. You need to apply this to your database.

#### Option A: Via Dokploy MySQL Terminal

1. Go to your Dokploy dashboard
2. Navigate to your MySQL database service
3. Open the terminal/shell
4. Run:

```sql
USE cap_db;

-- Add defaultOrgId column to users table
ALTER TABLE `users` ADD COLUMN `defaultOrgId` varchar(15) NULL;

-- Add settings column to organizations table
ALTER TABLE `organizations` ADD COLUMN `settings` json NULL;

-- Add index on defaultOrgId for performance
CREATE INDEX `default_org_id_idx` ON `users` (`defaultOrgId`);

-- Verify changes
SHOW COLUMNS FROM users LIKE 'defaultOrgId';
SHOW COLUMNS FROM organizations LIKE 'settings';
```

#### Option B: Via SSH to Dokploy Server

```bash
# SSH into your server
ssh user@your-dokploy-server

# Find MySQL container
MYSQL_CONTAINER=$(docker ps | grep mysql | awk '{print $1}')

# Apply migration
docker exec -i $MYSQL_CONTAINER mysql -u root -pYOUR_PASSWORD cap_db <<'EOF'
ALTER TABLE `users` ADD COLUMN `defaultOrgId` varchar(15) NULL;
ALTER TABLE `organizations` ADD COLUMN `settings` json NULL;
CREATE INDEX `default_org_id_idx` ON `users` (`defaultOrgId`);
EOF

# Verify
docker exec -i $MYSQL_CONTAINER mysql -u root -pYOUR_PASSWORD cap_db -e "SHOW COLUMNS FROM users LIKE 'defaultOrgId';"
```

### Step 2: Deploy Test Branch on Dokploy

1. **In Dokploy Dashboard:**
   - Go to your Cap web app service
   - Navigate to Git settings
   - Change branch from `main` to `test-0.3.72-compatibility`
   - Save changes

2. **Trigger Rebuild:**
   - Click "Deploy" or "Redeploy"
   - Monitor build logs for any errors
   - Wait for deployment to complete (~5-10 minutes)

3. **Verify Deployment:**
   - Check that the service is running
   - Visit your web URL to ensure it loads

### Step 3: Test Desktop App Authentication

1. **Open Cap Desktop App (0.3.72)**
2. **Log in to your self-hosted instance:**
   - Use your custom domain URL
   - Complete authentication flow
3. **Verify:**
   - ✅ Pro account status shows correctly
   - ✅ Recording doesn't prompt for login
   - ✅ Can share/upload recordings
   - ✅ Session persists across app restarts

### Step 4: Test Functionality

Test these critical flows:

- [ ] **Authentication**
  - Sign in works
  - Session persists
  - Pro status displayed correctly

- [ ] **Recording**
  - Create new recording
  - No unexpected login prompts
  - Upload works after recording

- [ ] **Sharing**
  - Share button works
  - Upload progress displays
  - Shareable link generated

- [ ] **Organization Features**
  - Workspace/organization loads
  - Members can access shared recordings
  - Settings save correctly

## Troubleshooting

### Issue: Migration Fails - "Column already exists"

**Solution:** The columns might already exist from previous attempts.

```sql
-- Check if columns exist
SHOW COLUMNS FROM users LIKE 'defaultOrgId';
SHOW COLUMNS FROM organizations LIKE 'settings';

-- If they exist, you're already good! Skip to Step 2.
```

### Issue: Desktop App Still Asking to Login

**Checklist:**
1. Verify migration was applied: `SHOW COLUMNS FROM users LIKE 'defaultOrgId';`
2. Verify test branch is deployed (check Dokploy logs)
3. Clear desktop app cache:
   - macOS: `~/Library/Application Support/so.cap.desktop.dev/`
   - Windows: `%APPDATA%/so.cap.desktop.dev/`
4. Restart desktop app completely
5. Re-authenticate

### Issue: Build Fails on Dokploy

Check build logs for:
- TypeScript errors
- Missing dependencies
- Environment variable issues

Most common fix:
```bash
# SSH into Dokploy, find your app container
docker logs CONTAINER_NAME --tail 100

# If pnpm install fails, try clearing build cache in Dokploy
```

### Issue: Cannot Connect to Database

Verify `DATABASE_URL` in Dokploy environment variables:
```
DATABASE_URL=mysql://user:password@mysql:3306/cap_db
```

## Rollback Plan

If something goes wrong:

### 1. Restore Database

```bash
# SSH to server
ssh user@your-dokploy-server

# Restore from backup
docker exec -i MYSQL_CONTAINER mysql -u root -pYOUR_PASSWORD cap_db < /tmp/cap_db_backup_YYYYMMDD_HHMMSS.sql
```

### 2. Rollback Code

In Dokploy:
1. Change branch back to `main`
2. Redeploy

## Success Criteria

The test is successful when:

✅ Desktop app 0.3.72 authenticates successfully
✅ Pro account status displays correctly
✅ No repeated login prompts during recording
✅ Recordings can be uploaded and shared
✅ Web dashboard loads and functions normally
✅ No errors in Dokploy logs

## After Successful Testing

Once you've confirmed everything works:

1. **Merge to Main:**
```bash
git checkout main
git merge test-0.3.72-compatibility
git push origin main
```

2. **Update Dokploy:**
   - Switch branch back to `main` in Dokploy
   - Deploy

3. **Clean Up:**
   - Delete test branch (optional)
   - Archive database backup (keep for 30 days)

## Migration Details

### Database Changes

**users table:**
```sql
ALTER TABLE `users` ADD COLUMN `defaultOrgId` varchar(15) NULL;
CREATE INDEX `default_org_id_idx` ON `users` (`defaultOrgId`);
```

**organizations table:**
```sql
ALTER TABLE `organizations` ADD COLUMN `settings` json NULL;
```

### Code Changes

- Merged Cap 0.3.72 release tag
- Updated schema.ts with branded types
- Added compatibility migration
- Resolved authentication flow conflicts

## Support

If you encounter issues:

1. Check Dokploy logs
2. Verify database migration was applied
3. Review this guide's Troubleshooting section
4. Check desktop app console logs

## Notes

- **Backwards Compatible:** These changes are backwards compatible
- **Safe Migration:** Only adds columns, no data modification
- **No Downtime Required:** Can be applied while system is running (though brief restart recommended)
- **Desktop App Version:** This fixes compatibility with desktop app 0.3.72+

---

**Last Updated:** 2025-10-14
**Branch:** test-0.3.72-compatibility
**Target Version:** Cap 0.3.72
