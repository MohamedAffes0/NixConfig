{
  inputs,
  pkgs,
  ...
}: {
  # If you use the module, you don't need to add the packages to environment.systemPacakges
  services.skwd-deck = {
    # enable the systemd service
    enable = true;
  };
}
