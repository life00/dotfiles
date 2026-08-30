{ pkgs, lib, config, inputs, ... }: {
  # Alacritty — fully Nix-native via `programs.alacritty`; no raw dotfile.
  # Font is JetBrainsMono Nerd Font; colors come from `catppuccin.alacritty`
  # (home/theme.nix) which injects `settings.general.import` pointing at the
  # catppuccin-macchiato.toml in the store. Cursor + Return bindings kept
  # for parity with the old dotfiles/alacritty config.
  # ponytail: `vi_mode_style` must be its own table — putting it inside
  # `cursor.style` is rejected by alacritty 0.17 (ConfigCursorStyle error).
  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        normal = { family = "JetBrainsMono Nerd Font"; style = "Regular"; };
        bold = { family = "JetBrainsMono Nerd Font"; style = "Bold"; };
        italic = { family = "JetBrainsMono Nerd Font"; style = "Italic"; };
        bold_italic = { family = "JetBrainsMono Nerd Font"; style = "Bold Italic"; };
        size = 11;
      };
      cursor = {
        style = { shape = "Beam"; blinking = "On"; };
        vi_mode_style = { shape = "Block"; };
      };
      keyboard.bindings = [
        { key = "Return"; mods = "Shift"; chars = "\\u001B[13;2u"; }
        { key = "Return"; mods = "Control"; chars = "\\u001B[13;5u"; }
      ];
    };
  };
}