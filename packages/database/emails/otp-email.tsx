import { CAP_LOGO_URL } from "@cap/utils";
import {
	Body,
	Button,
	Container,
	Head,
	Heading,
	Html,
	Img,
	Preview,
	Section,
	Tailwind,
	Text,
} from "@react-email/components";
import Footer from "./components/Footer";

export function OTPEmail({
	email = "",
	code = "",
	magicLink = "",
}: {
	email: string;
	code: string;
	magicLink?: string;
}) {
	return (
		<Html>
			<Head />
			<Preview>Your Cap Verification Code: {code}</Preview>
			<Tailwind>
				<Body className="mx-auto my-auto bg-gray-1 font-sans">
					<Container className="mx-auto my-10 max-w-[500px] rounded border border-solid border-gray-200 px-10 py-5">
						<Section className="mt-8">
							<Img
								src={CAP_LOGO_URL}
								width="40"
								height="40"
								alt="Cap"
								className="mx-auto my-0"
							/>
						</Section>
						<Heading className="mx-0 my-7 p-0 text-center text-xl font-semibold text-black">
							Your Verification Code
						</Heading>
						<Text className="text-sm leading-6 text-black">
							Welcome to Cap!
						</Text>
						<Text className="text-sm leading-6 text-black">
							Please use the following verification code to sign in to your
							account:
						</Text>
						<Section className="my-8 text-center">
							<div className="rounded-lg bg-gray-100 px-8 py-6">
								<Text className="m-0 text-3xl font-bold tracking-wider text-black">
									{code}
								</Text>
							</div>
						</Section>
						<Text className="text-sm leading-6 text-black">
							This code will expire in 10 minutes. If you didn't request this
							code, you can safely ignore this email.
						</Text>
						{magicLink && (
							<>
								<div className="my-8 text-center">
									<div className="h-px bg-gray-300 my-4" />
									<Text className="text-sm leading-6 text-black my-4">
										Or click the button below to sign in directly:
									</Text>
								</div>
								<Section className="text-center my-8">
									<Button
										href={magicLink}
										className="px-6 py-3 text-white bg-blue-600 rounded-lg text-sm font-medium"
									>
										Sign in to Cap
									</Button>
								</Section>
							</>
						)}
						<Footer email={email} />
					</Container>
				</Body>
			</Tailwind>
		</Html>
	);
}
