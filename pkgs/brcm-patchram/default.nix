{ fetchFromGitHub, stdenv, ... }: stdenv.mkDerivation {
  pname = "brcm-patchram-plus";
  version = "2021.09.03";
  compressFirmware = false;

  src = fetchFromGitHub {
      owner = "AsteroidOS";
      repo = "brcm-patchram-plus";
      rev = "15bd6638dd6d3a37d22dbc18059f6d9eb885f057";
      hash = "sha256-cP/z8w2m8ljMArKMYQQ3X9EbVjpom3OQ+6gs2xTDOyw=";
  };
  
  buildPhase = ''
    gcc -O2 -D_DEFAULT_SOURCE -std=c99 -Llposix src/main.c -o brcm_patchram_plus
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp brcm_patchram_plus $out/bin/
  '';
}
