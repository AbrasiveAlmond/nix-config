{inputs, outputs, nixvim, ... }: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];
  
  programs.nixvim = {
    enable = false;

    colorschemes.catppuccin.enable = true;
    plugins.lualine.enable = true;
  };
}