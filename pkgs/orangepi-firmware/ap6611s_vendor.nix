{ fetchFromGitHub, stdenvNoCC, ... }: stdenvNoCC.mkDerivation {
    pname = "orangepi-firmware";
    version = "2026.03.19";
    dontBuild = true;
    dontFixup = true;
    compressFirmware = false;

    src = fetchFromGitHub {
        owner = "orangepi-xunlong";
        repo = "firmware";
        rev = "db5e86200ae592c467c4cfa50ec0c66cbc40b158";
        hash = "sha256-v+4dv4U1vIF0kNCzbX8iZsGNkKWUDWdMmQOwuoFKWRo=";
    };

    installPhase = ''
        mkdir -p $out/lib/firmware

        cp fw_syn43711a0_sdio.bin $out/lib/firmware/fw_syn43711a0_sdio.bin
  
        cp nvram_ap6611s.txt-orangepi5ultra $out/lib/firmware/nvram_ap6611s.txt

        cp clm_syn43711a0.blob $out/lib/firmware/clm_syn43711a0.blob

        cp SYN43711A0.hcd $out/lib/firmware/SYN43711A0.hcd
    '';
}
