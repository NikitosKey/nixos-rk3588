{
  lib,
  config,
  rk3588,
  pkgs,
  ...
}: let
  rootPartitionUUID = "14e19a7b-0ae0-484d-9d54-43bd6fdc20c7";
  uboot = pkgs.callPackage ../../pkgs/u-boot-opi5ultra {
        inherit (pkgs) ubootOrangePi5Ultra;
  };
in {
  imports = [
    "${rk3588.nixpkgs}/nixos/modules/installer/sd-card/sd-image.nix"
  ];

  boot = {
    kernelParams = [
      "root=UUID=${rootPartitionUUID}"
      "rootfstype=ext4"
    ];

    loader = {
      grub.enable = lib.mkForce false;
      generic-extlinux-compatible.enable = lib.mkForce true;
    };
  };

  sdImage = {
    inherit rootPartitionUUID;
    compressImage = false;

    # install firmware into a separate partition: /boot/firmware
    populateFirmwareCommands = "";
    # Gap in front of the /boot/firmware partition, in mebibytes (1024×1024 bytes).
    # Can be increased to make more space for boards requiring to dd u-boot SPL before actual partitions.
    firmwarePartitionOffset = 32;
    firmwarePartitionName = "UNUSED";
    firmwareSize = 1; # MiB

    populateRootCommands = ''
      ${config.boot.loader.generic-extlinux-compatible.populateCmd} -c ${config.system.build.toplevel} -d ./files/boot
    '';

    # postBuildCommands = ''
    #   dd if=${uboot}/idbloader.img of=$img seek=64 conv=fsync,notrunc
    #   dd if=${uboot}/u-boot.itb of=$img seek=16384 conv=fsync,notrunc
    # '';
  };
}
