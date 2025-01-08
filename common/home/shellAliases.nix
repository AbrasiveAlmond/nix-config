{
  home.shellAliases = {
    hs = "home-manager switch --flake \".#$USER@$HOSTNAME\"";
    ns = "sudo nixos-rebuild switch --flake \".#$HOSTNAME\"";
  };
}