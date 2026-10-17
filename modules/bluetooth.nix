{...}: {
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };

  hardware.bluetooth.settings = {
    General = {
      Enable = "Source,Sink,Media,Socket";
      Experimental = true;
    };
  };

  services.blueman.enable = true;
}
