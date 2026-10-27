{ homeConfigName, pkgs, ... }:
let
  isEnabled =
    !builtins.elem homeConfigName [
      "xam@aeneas"
      "xamcost@elysium"
    ];
in
{
  programs.nixvim = {
    plugins.vimtex = {
      enable = isEnabled;
      texlivePackage = pkgs.texliveMedium;
      settings = {
        view_method = "skim";
        quickfix_open_on_warning = 0;
      };
    };
  };
}
