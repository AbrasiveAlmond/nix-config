{ pkgs }:
{
  programs = {
    steam = {
      enable = true;
      gamescopeSession.enable = true;
      remotePlay.openFirewall = true;
      localNetworkGameTransfers = true;
      extest.enable = true;
      extraPackages = with pkgs; [
        gamescope
      ];
    };

    gamemode.enable = true;
    # To use games that distribute via AppImage on linux
    # appimage.enable = true;
    # appimage.binfmt = true;
  };
}
