import type { ExtensionAPI, ExtensionContext } from "@oh-my-pi/pi-coding-agent";
import { getEditorCommand, openInEditor } from "@oh-my-pi/pi-coding-agent/utils/external-editor";
import { extractPrintableText, type ThemeColor, type TUI, visibleWidth } from "@oh-my-pi/pi-tui";
import { CustomEditor } from "@oh-my-pi/pi-tui/prompt/custom-editor";

// Vim Normal mode: <Space> then a key. Strings are slash commands, functions are editor hooks.
// `args`: fill the prompt with the command and switch to Insert so arguments can be typed; Enter runs it.
// `color` is a theme color, so the hint follows the active theme; one color per group.
const bindings: Record<
	string,
	{ label: string; color: ThemeColor; run: string | ((e: CustomEditor) => void); args?: boolean }
> = {
	n: { label: "new", color: "syntaxFunction", run: "/new" },
	r: { label: "resume", color: "syntaxFunction", run: "/resume" },
	l: { label: "resume", color: "syntaxFunction", run: "/resume" },
	t: { label: "tree", color: "syntaxFunction", run: "/tree" },
	f: { label: "fork", color: "syntaxFunction", run: "/fork" },
	b: { label: "branch", color: "syntaxFunction", run: "/branch" },
	".": { label: "retry", color: "syntaxFunction", run: e => e.onRetry?.() },
	c: { label: "compact", color: "syntaxType", run: "/compact" },
	i: { label: "context", color: "syntaxType", run: "/context" },
	p: { label: "plan", color: "syntaxKeyword", run: "/plan" },
	s: { label: "settings", color: "syntaxKeyword", run: "/settings" },
	m: { label: "model", color: "syntaxString", run: e => e.onSelectModelTemporary?.() },
	e: { label: "editor", color: "syntaxOperator", run: e => void editExternally(e) },
	a: { label: "agent hub", color: "syntaxOperator", run: "/hub" },
	g: { label: "git", color: "syntaxOperator", run: "/git" },
	w: { label: "worktree…", color: "syntaxOperator", run: "/wt", args: true },
	y: { label: "copy", color: "syntaxOperator", run: "/copy" },
	u: { label: "usage", color: "syntaxType", run: "/usage" },
	q: { label: "quit", color: "error", run: "/quit" },
};

let ctx: ExtensionContext | undefined;
let tui: TUI | undefined;

// Mirrors omp's Ctrl+G (`InputController.openExternalEditor`), which is an input listener, not an editor hook.
async function editExternally(e: CustomEditor): Promise<void> {
	const cmd = getEditorCommand();
	if (!cmd || !tui) return ctx?.ui.notify("leader: set $VISUAL or $EDITOR", "warning");
	try {
		tui.stop();
		const text = await openInEditor(cmd, e.getExpandedText(), { extension: ".omp.md" });
		if (text !== null) e.setText(text);
	} catch (err) {
		ctx?.ui.notify(`leader: editor failed: ${err instanceof Error ? err.message : String(err)}`, "error");
	} finally {
		tui.start();
		tui.requestRender();
	}
}

class LeaderEditor extends CustomEditor {
	#armed = false;
	#hintLines = 0;

	// One status entry per line: omp renders each hook status as a single truncated line.
	#setHint(lines: string[]): void {
		for (let i = 0; i < Math.max(lines.length, this.#hintLines); i++) ctx?.ui.setStatus(`leader${i}`, lines[i]);
		this.#hintLines = lines.length;
	}

	override handleInput(data: string): void {
		if (this.#armed) {
			this.#armed = false;
			this.#setHint([]);
			const binding = bindings[extractPrintableText(data) ?? ""];
			if (!binding) return; // any other key, Escape included, just disarms
			if (typeof binding.run === "function") return binding.run(this);
			// Submitting replaces the draft, and pastes/images would not survive a restore.
			if (this.getText().trim()) return ctx?.ui.notify(`leader: clear the prompt before ${binding.run}`, "warning");
			if (binding.args) {
				this.setText(`${binding.run} `);
				return super.handleInput("A"); // vim `A`: Insert at line end
			}
			this.setText(binding.run);
			this.submit();
			return;
		}
		if (this.vimMode === "normal" && this.vimPending === "" && extractPrintableText(data) === " ") {
			this.#armed = true;
			// Built per press, not cached: the theme can switch (dark/light) mid-session.
			const t = ctx?.ui.theme;
			if (t) {
				const width = tui?.terminal.columns ?? 80;
				const sep = t.fg("dim", " · ");
				const lines = [`${t.bold(t.fg("accent", "␣ LEADER"))} `];
				for (const [k, b] of Object.entries(bindings)) {
					const item = `${t.bold(t.fg(b.color, k))} ${t.fg("muted", b.label)}`;
					const last = lines.length - 1;
					const joined = lines[last] + (lines[last].endsWith(" ") ? " " : sep) + item;
					if (visibleWidth(joined) < width) lines[last] = joined;
					else lines.push(item);
				}
				this.#setHint(lines);
			}
			return;
		}
		super.handleInput(data);
	}
}

const factory = (t: TUI, theme: unknown) => {
	tui = t;
	return new LeaderEditor(theme);
};

export default function (pi: ExtensionAPI) {
	pi.on("session_start", (_event, c) => {
		ctx = c;
		if (c.ui.getEditorComponent() !== factory) c.ui.setEditorComponent(factory);
	});
}
