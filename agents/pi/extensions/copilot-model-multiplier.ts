import type { ExtensionAPI, ExtensionContext, ExtensionCommandContext } from "@mariozechner/pi-coding-agent";

const COPILOT_PROVIDER = "github-copilot";
const STATUS_KEY = "copilot-multiplier";
const DEBUG_PREFIX = "[copilot-mult]";
const ENABLE_EXTENSION_STATUS = false;

// Baseline static map (cache-backed lookup comes in next issue slice)
const KNOWN_MULTIPLIERS: Record<string, number> = {
	"gpt-5.3-codex": 1,
	"gpt-5": 1,
	"gpt-5-mini": 0.5,
	"gpt-5-nano": 0.25,
};

function getMultiplier(provider: string, modelId: string): number | null {
	if (provider !== COPILOT_PROVIDER) return null;
	return KNOWN_MULTIPLIERS[modelId] ?? null;
}

function formatMultiplier(multiplier: number | null): string {
	if (multiplier === null) return "×?";
	return `×${multiplier}`;
}

function colorizeMultiplier(ctx: ExtensionContext, multiplier: number | null): string {
	const text = formatMultiplier(multiplier);
	if (multiplier === null) return ctx.ui.theme.fg("customMessageLabel", text);
	if (multiplier > 2) return ctx.ui.theme.fg("error", text);
	if (multiplier > 1) return ctx.ui.theme.fg("customMessageLabel", text);
	return ctx.ui.theme.fg("muted", text);
}

function formatModelLabel(ctx: ExtensionContext, provider: string, modelId: string): string {
	if (provider === COPILOT_PROVIDER) {
		const multiplier = getMultiplier(provider, modelId);
		return `${modelId} ${colorizeMultiplier(ctx, multiplier)}`;
	}

	return `${modelId} ${ctx.ui.theme.fg("dim", `[${provider}]`)}`;
}

function updateMultiplierStatus(ctx: ExtensionContext): void {
	if (!ENABLE_EXTENSION_STATUS) {
		ctx.ui.setStatus(STATUS_KEY, undefined);
		return;
	}

	const model = ctx.model;
	if (!model || model.provider !== COPILOT_PROVIDER) {
		ctx.ui.setStatus(STATUS_KEY, undefined);
		return;
	}

	const multiplier = getMultiplier(model.provider, model.id);
	ctx.ui.setStatus(STATUS_KEY, `mult ${formatMultiplier(multiplier)}`);
}

async function selectModelWithMultiplier(ctx: ExtensionCommandContext, pi: ExtensionAPI): Promise<void> {
	const models = [...ctx.modelRegistry.getAvailable()].sort((a, b) => {
		const left = `${a.provider}/${a.id}`;
		const right = `${b.provider}/${b.id}`;
		return left.localeCompare(right);
	});

	if (models.length === 0) {
		ctx.ui.notify(`${DEBUG_PREFIX} No models available`, "warning");
		return;
	}

	const options = models.map((model) => formatModelLabel(ctx, model.provider, model.id));
	const choice = await ctx.ui.select("Select model", options);
	if (!choice) return;

	const choiceIndex = options.indexOf(choice);
	if (choiceIndex < 0) return;

	const selectedModel = models[choiceIndex];
	if (!selectedModel) return;

	const success = await pi.setModel(selectedModel);
	if (!success) {
		ctx.ui.notify(`${DEBUG_PREFIX} Missing auth for ${selectedModel.provider}/${selectedModel.id}`, "warning");
		return;
	}

	updateMultiplierStatus(ctx);
}

export default function (pi: ExtensionAPI) {
	pi.on("session_start", async (_event, ctx) => {
		updateMultiplierStatus(ctx);
	});

	pi.on("model_select", async (_event, ctx) => {
		updateMultiplierStatus(ctx);
	});

	pi.registerCommand("copilot-model", {
		description: "Select model with Copilot multiplier labels",
		handler: async (_args, ctx) => {
			await selectModelWithMultiplier(ctx, pi);
		},
	});
}
