# =========================================================================
#      Orange Pi 5 Ultra Specific Configuration
# =========================================================================
{ pkgs, lib, config, rk3588, ... }:
let
  pkgsKernel = rk3588.pkgsKernel;
  wifi-fw = pkgs.callPackage ../../pkgs/orangepi-firmware/ap6611s_vendor.nix {};
  brcm-patchram = pkgs.callPackage ../../pkgs/brcm-patchram {};
in {
  imports = [
    ./base.nix
  ];
  boot = {

    kernelPackages = pkgsKernel.linuxPackagesFor(pkgs.callPackage ../../pkgs/kernel/opi5ultra_vendor.nix {});

    kernelParams = [
      "loglevel=3"
      "rootwait"
      "earlycon"
      "consoleblank=0"
      "console=ttyS2,1500000"
      "console=tty1"
      
      "cgroup_enable=cpuset"
      "swapaccount=1"
    ];
    initrd.kernelModules = [ "bcmdhd" "hci_uart" ];
  };

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    deviceTree = {
      enable = true;
      name = "rockchip/rk3588-orangepi-5-ultra.dtb";
    };

    firmware = [
      wifi-fw
    ];
  };

  systemd.services.ap6611s-bluetooth = {
    description = "Broadcom Bluetooth Patchram Loader";
    
    wantedBy = [ "multi-user.target" ];
    before = [ "bluetooth.service" ];
    after = [ "dev-ttyS7.device" ];

    serviceConfig = {
      Type = "simple";
      ExecStartPre = "${pkgs.util-linux}/bin/rfkill unblock bluetooth";
      ExecStart = ''
        ${brcm-patchram}/bin/brcm_patchram_plus \
          --patchram ${wifi-fw}/lib/firmware/SYN43711A0.hcd \
          --baudrate 1500000 \
          --enable_hci \
          --no2bytes \
          --tosleep 200000 \
          /dev/ttyS7
      '';
      
      Restart = "on-failure";
      RestartSec = 5;
    };
  };

  networking.networkmanager = {
    settings = {
      device = {
        "wifi.scan-rand-mac-address" = "no";
      };
      connection = {
        "wifi.cloned-mac-address" = "preserve";
        "wifi.powersave" = 2;
      };
    };
  };

  security.polkit = {
    enable = true;
  };
}

