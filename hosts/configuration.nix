{
  config,
  pkgs,
  caelestia,
  homeManagerModules,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  # ---------------------------------------------------------------- Bootloader
  # UEFI + GRUB. The `nodev` device is correct for an EFI install: GRUB is
  # installed to the EFI system partition, not to a raw disk.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.useOSProber = true;
  boot.kernelParams = ["nvidia-drm.modeset=1"];
  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usbhid"
    "sd_mod"
  ];

  # -------------------------------------------------------------------- Network
  networking.hostName = "LOQ";
  networking.networkmanager.enable = true;

  # ------------------------------------------------------------------- Locale
  time.timeZone = "Africa/Tunis";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "us";

  # ----------------------------------------------------------------- Utilities
  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    btop
    firefox
    ghostty

    # zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default

    upscayl

    loupe
    showtime
    rewaita
    refine
    gnome-tweaks
    adwaita-icon-theme
    papirus-icon-theme

    easyeffects

    morewaita-icon-theme

    # Programming
    nixd
    alejandra

    google-chrome

    kopuz

    nautilus
    kdePackages.dolphin

    # Programming
    nixd
    alejandra

    vscode
    google-chrome
    zed-editor

    nautilus
    kdePackages.dolphin
  ];

  # ------------------------------------------------------------------ Graphics
  # Required for Hyprland/Quickshell (OpenGL/Vulkan).
  hardware.graphics.enable = true;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  # --------------------------------------------------------------------- Audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  security.rtkit.enable = true;

  # ------------------------------------------------- Power / battery reporting
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;

  # --------------------------------------------------------------------- Fonts
  # Fonts the Caelestia shell expects for its icons/glyphs.
  fonts.packages = with pkgs; [
    material-symbols
    rubik
    nerd-fonts.caskaydia-cove
    noto-fonts
    noto-fonts-color-emoji
  ];

  programs.dconf.enable = true;

  # Wayland hint for Electron/Chromium apps.
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  # ---------------------------------------------------------------------- Nvidia
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # ---------------------------------------------------------------------- Printing
  services.printing = {
    enable = true;
    drivers = [
      pkgs.epson-escpr2
      pkgs.epson-escpr
    ];
  };

  # ---------------------------------------------------------------------- User
  users.users.mohamed_affes = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
    ];
  };

  # ------------------------------------------------------- Home Manager / Shell
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = {inherit caelestia homeManagerModules;};
    users.mohamed_affes = import ../home/default.nix;
  };

  # ------------------------------------------------------------------ Nix / GC
  programs.fish.enable = true;
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 3";
    flake = "/home/mohamed_affes/.config/nixos/"; # sets NH_OS_FLAKE variable for you
  };

  nixpkgs.config = {
    allowUnfree = true;
    cudaSupport = true;
  };

  nix.gc.automatic = true;
  nix.gc.dates = "weekly";
  nix.settings = {
    substituters = [
      "https://cache.nixos-cuda.org"
      "https://hyprland.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
    experimental-features = ["nix-command" "flakes"];
  };

  system.stateVersion = "26.05";
}
