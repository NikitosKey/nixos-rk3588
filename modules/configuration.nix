{
  lib,
  pkgs,
  ...
}: let
  username = "nixos";
  # To generate a hashed password run `mkpasswd -m scrypt`.
  # this is the hash of the password "rk3588"
  hashedPassword = "$7$CU..../....V0jtKuZ0br4b8aG2QjRPX/$R1His9huRVhQgZqQF02g0Vxfe.QBTEFT9ofhn1nsAE8";
in {
  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    trusted-users = [ "root" "@wheel" "nixos" ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git # used by nix flakes
    curl

    neofetch
    lm_sensors # `sensors`
    btop # monitor system resources

    # Peripherals
    mtdutils
    i2c-tools
    minicom
  ];

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = lib.mkDefault true;
    settings = {
      X11Forwarding = lib.mkDefault true;
      PasswordAuthentication = lib.mkDefault true;
    };
    openFirewall = lib.mkDefault true;
    permitRootLogin = true;
  };

  # Enable networkmanager.
  networking.networkmanager = {
    enable = true;
  };

  # =========================================================================
  #      Users & Groups NixOS Configuration
  # =========================================================================

  # TODO Define a user account. Don't forget to update this!
  users.users."${username}" = {
    inherit hashedPassword;
    isNormalUser = true;
    home = "/home/${username}";
    extraGroups = ["users" "wheel" "networkmanager"];
  };

  system.stateVersion = "26.05";
}
