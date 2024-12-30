
{nixpkgs, ...}: {
  name = "simple";
  builder = "${nixpkgs.legacyPackages."x86_64-linux".bash}/bin/bash";
  args = [ "-c" "echo foo > $out" ];
  src = ./.;
  system = "x86_64-linux";
}