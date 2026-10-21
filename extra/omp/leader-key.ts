import type { ExtensionAPI, ExtensionContext } from "@oh-my-pi/pi-coding-agent";
import { extractPrintableText, type ThemeColor } from "@oh-my-pi/pi-tui";
import { CustomEditor } from "@oh-my-pi/pi-tui/prompt/custom-editor";

// Vim Normal mode: <Space> then a key. Strings are slash commands, functions are editor hooks.
// `color` is a theme color, so the hint follows the active theme; one color per group.
const bindings: Record<string, { label: string; color: ThemeColor; run: string | ((e: CustomEditor) => void) }> = {
	n: { label: "new", color: "syntaxFunction", run: "/new" },
	r: { label: "resume", color: "syntaxFunction", run: "/resume" },
	t: { label: "tree", color: "syntaxFunction", run: "/tree" },
	f: { label: "fork", color: "syntaxFunction", run: "/fork" },
	c: { label: "compact", color: "syntaxType", run: "/compact" },
	p: { label: "plan", color: "syntaxKeyword", run: "/plan" },
	s: { label: "settings", color: "syntaxKeyword", run: "/settings" },
	m: { label: "model", color: "syntaxString", run: e => e.onSelectModel?.() },
	M: { label: "model (temp)", color: "syntaxString", run: e => e.onSelectModelTemporary?.() },
	e: { label: "effort", color: "syntaxString", run: e => e.onCycleThinkingLevel?.() },
};

let ctx: ExtensionContext | undefined;

class LeaderEditor extends CustomEditor {
	#armed = false;

	override handleInput(data: string): void {
		if (this.#armed) {
			this.#armed = false;
			ctx?.ui.setStatus("leader", undefined);
			const binding = bindings[extractPrintableText(data) ?? ""];
			if (!binding) return; // any other key, Escape included, just disarms
			if (typeof binding.run === "function") return binding.run(this);
			// Submitting replaces the draft, and pastes/images would not survive a restore.
			if (this.getText().trim()) return ctx?.ui.notify(`leader: clear the prompt before ${binding.run}`, "warning");
			this.setText(binding.run);
			this.submit();
			return;
		}
		if (this.vimMode === "normal" && this.vimPending === "" && extractPrintableText(data) === " ") {
			this.#armed = true;
			// Built per press, not cached: the theme can switch (dark/light) mid-session.
			const t = ctx?.ui.theme;
			if (t) {
				const items = Object.entries(bindings).map(
					([k, b]) => `${t.bold(t.fg(b.color, k))} ${t.fg("muted", b.label)}`,
				);
				ctx?.ui.setStatus("leader", `${t.bold(t.fg("accent", "␣ LEADER"))}  ${items.join(t.fg("dim", " · "))}`);
			}
			return;
		}
		super.handleInput(data);
	}
}

const factory = (_tui: unknown, theme: unknown) => new LeaderEditor(theme);

export default function (pi: ExtensionAPI) {
	pi.on("session_start", (_event, c) => {
		ctx = c;
		if (c.ui.getEditorComponent() !== factory) c.ui.setEditorComponent(factory);
	});
}
