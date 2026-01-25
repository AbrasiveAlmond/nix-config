{ pkgs, ... }:
{
  # I hate auth, just set it up declaratively once
  home.packages = with pkgs; [
    liboauth
    git-credential-oauth
  ];

  programs.git = {
    enable = true;
    settings = {
      user.name = "AbrasiveAlmond";
      user.email = "qpearson.nz@gmail.com";
      push.autoSetupRemote = true;
      credential = {
        helper = "oauth";
        "https://github.com".username = "AbrasiveAlmond";
        credentialStore = "cache";
      };
    };
  };
}
