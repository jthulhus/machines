{ pkgs, self, ... }:
{
  environment.etc."my-config".source = self;

  environment.systemPackages = with pkgs; [
    git
    emacs
  ];

  isoImage.squashfsCompression = "zstd -Xcompression-level 3";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
