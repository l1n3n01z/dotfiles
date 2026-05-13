import type { ExtensionAPI, ExtensionContext } from "@mariozechner/pi-coding-agent";

const STATE_CUSTOM_TYPE = "ralph-loop-extension-state";
const MARKER_CUSTOM_TYPE = "ralph-loop-extension";
const MARKER_TEXT = "ralph-loop-extension: active";
const TOKEN_LIMIT = 50_000;

interface RalphLoopState {
	prdRef: string | null;
	issueCount: number;
	resetCount: number;
	updatedAt: string;
}

const defaultState = (): RalphLoopState => ({
	prdRef: null,
	issueCount: 0,
	resetCount: 0,
	updatedAt: new Date().toISOString(),
});

export default function (pi: ExtensionAPI) {
	let state: RalphLoopState = defaultState();

	const loadState = (ctx: ExtensionContext) => {
		state = defaultState();
		for (const entry of ctx.sessionManager.getBranch()) {
			if (entry.type !== "custom" || entry.customType !== STATE_CUSTOM_TYPE) continue;
			const data = entry.data as Partial<RalphLoopState> | undefined;
			if (!data) continue;
			state = {
				prdRef: data.prdRef ?? null,
				issueCount: data.issueCount ?? 0,
				resetCount: data.resetCount ?? 0,
				updatedAt: data.updatedAt ?? new Date().toISOString(),
			};
		}
	};

	const persistState = () => {
		state.updatedAt = new Date().toISOString();
		pi.appendEntry(STATE_CUSTOM_TYPE, { ...state });
	};

	const ensureMarker = (ctx: ExtensionContext) => {
		const hasMarker = ctx.sessionManager.getBranch().some((entry) => {
			return (
				entry.type === "custom_message" &&
				entry.customType === MARKER_CUSTOM_TYPE &&
				entry.content === MARKER_TEXT
			);
		});

		if (!hasMarker) {
			ctx.sessionManager.appendCustomMessageEntry(MARKER_CUSTOM_TYPE, MARKER_TEXT, false);
		}
	};

	const notify = (ctx: ExtensionContext, message: string, level: "info" | "error" = "info") => {
		if (ctx.hasUI) {
			ctx.ui.notify(message, level);
			return;
		}
		pi.sendMessage({
			customType: MARKER_CUSTOM_TYPE,
			content: message,
			display: true,
		});
	};

	const extractPrdRef = (text: string) => {
		const match = text.match(/\/ralph-issue\b[^\n]*\(([^)]+)\)/i);
		return match?.[1]?.trim() ?? null;
	};

	const extractCompletionCount = (text: string) => {
		const matches = text.match(/<ralph-issue-complete\b/gi);
		return matches?.length ?? 0;
	};

	const updatePrdRef = (nextRef: string | null) => {
		if (!nextRef || nextRef === state.prdRef) return;
		state.prdRef = nextRef;
		state.issueCount = 0;
		state.resetCount = 0;
		persistState();
	};

	const incrementIssueCount = (count: number) => {
		if (count <= 0) return;
		state.issueCount += count;
		persistState();
	};

	const getUsage = (ctx: ExtensionContext) => ctx.getContextUsage();

	const getZone = (ctx: ExtensionContext) => {
		const usage = getUsage(ctx);
		if (!usage || typeof usage.tokens !== "number") return "unknown";
		return usage.tokens <= TOKEN_LIMIT ? "smart" : "degraded";
	};

	pi.on("session_start", async (_event, ctx) => {
		loadState(ctx);
		ensureMarker(ctx);
	});

	pi.on("session_tree", async (_event, ctx) => {
		loadState(ctx);
		ensureMarker(ctx);
	});

	pi.on("input", async (event, ctx) => {
		const text = event.text.trim();
		if (text.startsWith("/ralph-issue")) {
			updatePrdRef(extractPrdRef(text));
		}

		if (!text.startsWith("/ralph-loop")) return { action: "continue" };

		ensureMarker(ctx);
		const usage = getUsage(ctx);
		if (!usage || typeof usage.tokens !== "number") {
			notify(ctx, "/ralph-loop blocked: token usage unavailable. Use /ralph-issue manually.", "error");
			return { action: "handled" };
		}

		const markerPresent = ctx.sessionManager.getBranch().some((entry) => {
			return (
				entry.type === "custom_message" &&
				entry.customType === MARKER_CUSTOM_TYPE &&
				entry.content === MARKER_TEXT
			);
		});
		if (!markerPresent) {
			notify(ctx, "/ralph-loop blocked: extension marker missing. Run /reload.", "error");
			return { action: "handled" };
		}

		return { action: "continue" };
	});

	pi.on("message_end", async (event, ctx) => {
		const msg = event.message;
		if (msg.role !== "assistant") return;

		const text = msg.content
			.map((part) => (part.type === "text" ? part.text : ""))
			.join("")
			.trim();

		if (!text) return;

		updatePrdRef(extractPrdRef(text));
		incrementIssueCount(extractCompletionCount(text));
	});

	pi.registerCommand("ralph-loop-status", {
		description: "Show ralph-loop extension status",
		handler: async (_args, ctx) => {
			const usage = getUsage(ctx);
			const tokens = usage?.tokens;
			const zone = getZone(ctx);
			const parts = [
				`PRD: ${state.prdRef ?? "(none)"}`,
				`Issues: ${state.issueCount}`,
				`Resets: ${state.resetCount}`,
				`Tokens: ${tokens ?? "unavailable"}`,
				`Zone: ${zone}`,
			];
			notify(ctx, parts.join(" | "), "info");
		},
	});
}
