{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Editors
    vscode
    zed-editor

    # Language servers neovim-dots enables but Mason doesn't install
    ty
    deno
    oxlint
    vscode-langservers-extracted # eslint
    tailwindcss-language-server
    matlab-language-server

    # Formatters neovim-dots' conform.nvim calls
    yamlfmt
    python3Packages.sqlfmt
    rustfmt
    clang-tools # clang-format
  ];

  # Lets prebuilt binaries (Mason language servers, blink.cmp) run on NixOS.
  programs.nix-ld.enable = true;
}
