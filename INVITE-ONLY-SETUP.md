# Invite-Only Signup Setup

## Overview

Your Cap instance now supports invite-only signups. Only users who have been invited through the UI can create accounts.

## How to Enable

### Step 1: Add Environment Variable in Dokploy

Add this to your cap-web service environment variables:

```
REQUIRE_INVITE=true
```

### Step 2: Redeploy

Redeploy your cap-web service in Dokploy to apply the changes.

## How It Works

### For You (Admin)

1. **Go to Dashboard → Settings → Organization → Members**
2. **Click "Invite Members"**
3. **Enter email addresses** (one or multiple)
4. **Send invites**

The system will:
- Create invite records in the database
- Send invitation emails to those addresses
- Allow those specific emails to sign up

### For New Users

1. **Receive invitation email** with link
2. **Click the link** (or manually go to your Cap instance)
3. **Sign up with the invited email address**
4. **Successfully create account** ✅

### For Non-Invited Users

1. **Try to sign up**
2. **Get blocked** with message:
   > "You must be invited to create an account on this instance. Please contact your administrator for an invitation."

## Testing

### Test 1: Invite Someone
```
1. Go to your dashboard
2. Navigate to Settings → Organization → Members
3. Click "Invite Members"
4. Enter: test@example.com
5. Click Send
```

### Test 2: Invited User Signs Up
```
1. Open incognito/private browser
2. Go to your Cap instance login page
3. Enter: test@example.com
4. Complete sign up flow
5. Should work! ✅
```

### Test 3: Non-Invited User Blocked
```
1. Open incognito/private browser
2. Try to sign up with: random@example.com
3. Should be blocked with error message ❌
```

## Disable Invite-Only Mode

To allow anyone to sign up again:

1. **In Dokploy, remove or change the env var:**
   ```
   REQUIRE_INVITE=false
   ```
   Or just delete the variable entirely

2. **Redeploy**

## Current Invites

You can see pending invites in the database:

```sql
SELECT
  invitedEmail,
  role,
  status,
  createdAt
FROM organization_invites
WHERE organizationId = '89568w9hmptrx49'  -- Your Infinite Automation org
ORDER BY createdAt DESC;
```

## Managing Invites

### Remove an Invite

If you invited someone by mistake:

```sql
DELETE FROM organization_invites
WHERE invitedEmail = 'wrong@example.com';
```

### Check Invite Status

```sql
SELECT * FROM organization_invites
WHERE invitedEmail = 'user@example.com';
```

## How Existing Users Are Affected

- **Existing users**: Can log in normally, not affected
- **New invited users**: Can create accounts
- **Non-invited users**: Cannot create accounts

## Benefits

✅ **Full control** over who can access your instance
✅ **Use existing UI** - no command-line needed
✅ **Invitation emails** sent automatically
✅ **Easy to enable/disable** via environment variable
✅ **Backwards compatible** - disabled by default

## Troubleshooting

### "I invited someone but they can't sign up"

Check if the invite exists:
```sql
SELECT * FROM organization_invites
WHERE invitedEmail = 'their@email.com';
```

Make sure `REQUIRE_INVITE=true` is set in Dokploy and the service has been redeployed.

### "I want to bulk invite many users"

You can insert multiple invites via SQL:

```sql
INSERT INTO organization_invites (id, organizationId, invitedEmail, invitedByUserId, role, status)
VALUES
  ('inv001', '89568w9hmptrx49', 'user1@example.com', '7fk5n1v9x5hfce8', 'member', 'pending'),
  ('inv002', '89568w9hmptrx49', 'user2@example.com', '7fk5n1v9x5hfce8', 'member', 'pending'),
  ('inv003', '89568w9hmptrx49', 'user3@example.com', '7fk5n1v9x5hfce8', 'member', 'pending');
```

### "Error when someone tries to sign up"

Check the Dokploy logs for error messages. Look for lines starting with `🚫 Signup blocked` or `✅ Signup allowed`.

## Summary

Your self-hosted Cap instance is now invite-only!

**To enable**: Set `REQUIRE_INVITE=true` in Dokploy and redeploy
**To invite users**: Use Dashboard → Settings → Organization → Members → Invite
**To disable**: Remove the env var or set to `false`
