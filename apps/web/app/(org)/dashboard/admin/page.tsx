import { getCurrentUser } from "@cap/database/auth/session";
import { redirect } from "next/navigation";
import AdminDashboardClient from "./AdminDashboardClient";

export default async function AdminDashboard() {
	const currentUser = await getCurrentUser();

	if (currentUser?.email !== "joel@domegaia.com") {
		redirect("/dashboard");
	}

	return <AdminDashboardClient />;
}
