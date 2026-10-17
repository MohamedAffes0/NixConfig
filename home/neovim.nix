{
  pkgs,
  lib,
  neovim-dots,
  ...
}: {
  programs.neovim = {
    enable = true;
    withNodeJs = true;
    withPython3 = true;
    # Only on nvim's PATH: what lazy.nvim, Mason and tree-sitter-manager need
    # to install plugins, servers and parsers, plus tools the config calls.
    extraPackages = with pkgs; [
      git
      gcc
      gnumake
      tree-sitter
      unzip
      curl
      wget
      gnutar
      gzip
      nodejs
      python3
      ripgrep
      fd
      lua-language-server
      stylua
    ];
    # Home Manager writes init.lua (provider setup), so append neovim-dots' own.
    initLua = lib.mkAfter (builtins.readFile "${neovim-dots}/init.lua");
  };

  # lazy.nvim installs plugins into ~/.local/share/nvim at runtime.
  xdg.configFile."nvim/lua".source = "${neovim-dots}/lua";

  # lazy.nvim rewrites lazy-lock.json on every install or update, so it can't
  # be a read-only store link. Seed a writable copy once.
  home.activation.neovimLazyLock = lib.hm.dag.entryAfter ["linkGeneration"] ''
    lock="''${XDG_CONFIG_HOME:-$HOME/.config}/nvim/lazy-lock.json"
    if [ ! -e "$lock" ]; then
      run install -m 644 ${neovim-dots}/lazy-lock.json "$lock"
    fi
  '';
}
