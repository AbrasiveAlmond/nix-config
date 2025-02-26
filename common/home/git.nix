{
  programs.git = {
    enable = true;
    userName = "AbrasiveAlmond";
    userEmail = "qpearson.nz@gmail.com";
    extraConfig = {
      push.autoSetupRemote = true;
      credential.helper = "&{
        pkgs.git.override { withLibsecret = true; }
        }/bin/git-credential-libsecret";
    };
  };
}
