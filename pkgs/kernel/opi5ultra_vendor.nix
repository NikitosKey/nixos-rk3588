{ fetchFromGitHub
, linuxManualConfig
, ubootTools
, ...
}:
let
  modDirVersion = "6.1.99";
in
(linuxManualConfig {
  inherit modDirVersion;
  version = "${modDirVersion}-opi5ultra";
  extraMeta.branch = "6.1";

  src = fetchFromGitHub {
    owner = "orangepi-xunlong";
    repo = "linux-orangepi";
    rev = "232ed4b97b65da2b7b647c4e3c496f8594b9f3f1";
    hash = "sha256-askpT+yVQ9PgKcrNI1Mpa5k39L8T9eA5U5Q3Fx/4tNU=";
  };

  configfile = ./opi5ultra_vendor.config;


}).overrideAttrs (old: {
  name = "k"; # dodge uboot length limits
  nativeBuildInputs = old.nativeBuildInputs ++ [ ubootTools ];

  preBuild = ''
    mkdir -p drivers/gpu/arm/bifrost
    cp source/drivers/gpu/arm/bifrost/mali_csffw.bin drivers/gpu/arm/bifrost/mali_csffw.bin
  '';
})

