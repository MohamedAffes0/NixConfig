{...}: let
  # Mounted at boot, and shown in the file manager sidebar (x-gvfs-show)
  # under the given name. nofail keeps boot going if a disk is missing.
  sidebar = name: ["nofail" "x-gvfs-show" "x-gvfs-name=${name}"];
  # Files owned by mohamed_affes, not executable; folders browsable.
  ntfsOwner = ["uid=1000" "gid=100" "dmask=0022" "fmask=0133"];
in {
  # gvfs and udisks2 are what Nautilus uses to list drives in its sidebar.
  services.gvfs.enable = true;
  services.udisks2.enable = true;

  # NTFS won't mount while Windows is hibernated: turn off Fast Startup in Windows.
  fileSystems."/mnt/windows-data" = {
    device = "/dev/disk/by-uuid/3E26F36726F31E99";
    fsType = "ntfs3";
    options = sidebar "Windows%20Data" ++ ntfsOwner;
    # There is no fsck for NTFS on Linux.
    noCheck = true;
  };

  fileSystems."/mnt/windows-nvme" = {
    device = "/dev/disk/by-uuid/38D0BCAF732D60B3";
    fsType = "ntfs3";
    options = sidebar "Windows%20NVMe" ++ ntfsOwner;
    # There is no fsck for NTFS on Linux.
    noCheck = true;
  };

  # Fedora partition: read-only for safety.
  fileSystems."/mnt/fedora" = {
    device = "/dev/disk/by-uuid/8a2f9b81-462c-4898-9755-e0f6281a68ab";
    fsType = "btrfs";
    options = sidebar "Fedora" ++ ["ro"];
  };
}
