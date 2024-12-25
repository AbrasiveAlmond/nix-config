{ pkgs, ... }: {
  imports = [
    ./tmux.nix
    ./fish.nix
    ./starship.nix
    # ./nixvim.nix
  ];

  home.packages = with pkgs; [
    # direnv # Dynamically load dev environments when cd'ing into folders
    # neovim
    tree
    zoxide
  ];
}