{...}: {
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  programs.qylock = {
    enable = true;
    theme = "material-you-dark"; # any directory name under themes/
  };
}
