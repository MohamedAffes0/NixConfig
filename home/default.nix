{
  pkgs,
  homeManagerModules,
  caelestia-dots,
  ...
}: let
  hypr = "${caelestia-dots}/hypr";
in {
  imports = [
    homeManagerModules.default
    ./ghostty.nix
  ];

  home.stateVersion = "26.05";

  programs.caelestia = {
    enable = true;
    cli.enable = true;
    systemd.enable = true;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    package = null;
    portalPackage = null;
    # UWSM (programs.hyprland.withUWSM) already manages the systemd session.
    systemd.enable = false;
    # Caelestia's entry point. It loads the files linked below, then
    # ~/.config/caelestia/hypr-vars.lua and hypr-user.lua.
    extraConfig = builtins.readFile "${hypr}/hyprland.lua";
  };

  xdg.configFile = {
    "hypr/variables.lua".source = "${hypr}/variables.lua";
    "hypr/hyprland".source = "${hypr}/hyprland";
    "hypr/utils".source = "${hypr}/utils";
    # Only link the default scheme: Caelestia writes scheme/current.lua at runtime.
    "hypr/scheme/default.lua".source = "${hypr}/scheme/default.lua";

    "caelestia/hypr-vars.lua".source = ./hypr/vars.lua;
    "caelestia/hypr-user.lua".source = ./hypr/user.lua;
  };

  services.hyprpolkitagent.enable = true;

  home.packages = with pkgs; [
    wofi
    pwvucontrol
    discord
    vesktop
  ];
}
