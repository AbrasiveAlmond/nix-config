{
  pkgs,
  ...
} : {
  home.packages = with pkgs; [
    tree
    # vivid # Some sort of terminal theme setter

    # Language servers
    nil # Nix language server
    rust-analyzer

    # Languages (cbb with flake if its python)
    # python314
    # uv # Python package manager
    # ruff # Python liter and code formatter
    # ty # Unfinished python type checker

  ];
}
