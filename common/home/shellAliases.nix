{
  home.shellAliases = {
    hs = "home-manager switch --flake \".#$USER@$HOSTNAME\"";
    ns = "sudo nixos-rebuild switch --flake \".#$HOSTNAME\"";
    hotspot = "nmcli r wifi off && rfkill unblock wlan && sudo create_ap --daemon wlp13s0 enp14s0 'Minifridge' 'ColdBeers'";
  };
}
