import { eq } from "drizzle-orm";
import { db } from "../index";
import { organizationInvites } from "../schema";

/**
 * Check if a user is allowed to sign up based on invite status
 * For self-hosted instances, this enforces invite-only signups
 */
export async function isSignupAllowed(
	email: string,
): Promise<{ allowed: boolean; reason?: string }> {
	// Check if REQUIRE_INVITE environment variable is set
	// If not set or false, allow all signups (backwards compatible)
	const requireInvite = process.env.REQUIRE_INVITE === "true";

	if (!requireInvite) {
		return { allowed: true };
	}

	// Check if user has a pending invite
	const [invite] = await db()
		.select()
		.from(organizationInvites)
		.where(eq(organizationInvites.invitedEmail, email.toLowerCase().trim()))
		.limit(1);

	if (invite) {
		return { allowed: true };
	}

	return {
		allowed: false,
		reason:
			"You must be invited to create an account on this instance. Please contact your administrator for an invitation.",
	};
}
