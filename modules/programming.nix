{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    # Editors 
    vscode
    zed-editor
    neovim
  ];
}
