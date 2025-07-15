{pkgs, ...} : {
  # I hate auth, just set it up declaratively once
  home.packages = with pkgs; [
    liboauth
    git-credential-oauth
  ];

  programs.git = {
    enable = true;
    userName = "AbrasiveAlmond";
    userEmail = "qpearson.nz@gmail.com";
    extraConfig = {
      push.autoSetupRemote = true;
      credential = {
        helper = "oauth";
        "https://github.com".username = "AbrasiveAlmond";
        credentialStore = "cache";
      };
    };
  };
}
