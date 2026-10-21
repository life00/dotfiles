import type { ExtensionAPI, ExtensionContext } from "@oh-my-pi/pi-coding-agent";
import { extractPrintableText } from "@oh-my-pi/pi-tui";
import { CustomEditor } from "@oh-my-pi/pi-tui/prompt/custom-editor";

// Vim Normal mode: <Space> then a key. Strings are slash commands, functions are editor hooks.
const bindings: Record<string, { label: string; run: string | ((e: CustomEditor) => void) }> = {
	n: { label: "new", run: "/new" },
	r: { label: "resume", run: "/resume" },
	t: { label: "tree", run: "/tree" },
	f: { label: "fork", run: "/fork" },
	c: { label: "compact", run: "/compact" },
	p: { label: "plan", run: "/plan" },
	s: { label: "settings", run: "/settings" },
	m: { label: "model", run: e => e.onSelectModel?.() },
	M: { label: "model (temp)", run: e => e.onSelectModelTemporary?.() },
	e: { label: "effort", run: e => e.onCycleThinkingLevel?.() },
};
const hint = `␣ ${Object.entries(bindings)
	.map(([k, b]) => `${k} ${b.label}`)
	.join(" · ")}`;

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
			ctx?.ui.setStatus("leader", hint);
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
