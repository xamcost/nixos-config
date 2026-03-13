{
  pkgs,
  homeConfigName,
  ...
}:
let
  isEnabled = builtins.elem homeConfigName [ "maximecostalonga@xam-mac-m4" ];
  # Fix needed because openscad is a dependency that fails to build on darwin, and the plugin doesn't actually need it.
  openscad-nvim-clean = pkgs.vimUtils.buildVimPlugin {
    pname = "openscad.nvim";
    version = "git";

    src = pkgs.fetchFromGitHub {
      owner = "salkin-mada";
      repo = "openscad.nvim";
      rev = "e81d938252fde30fbbe156bfc544bf2d9758272a";
      sha256 = "sha256-K0TKik9+YNlcxwhIxL+Azb8i+r9ULBzSIjZx2TqeSzM=";
    };

    nvimSkipModules = [
      "openscad"
      "openscad.snippets.openscad"
      "openscad.utilities"
    ];
  };
in
{
  programs.nixvim = {
    plugins.openscad = {
      enable = isEnabled;
      package = openscad-nvim-clean;
      lazyLoad = {
        settings = {
          ft = [ "openscad" ];
        };
      };
      settings = {
        pdf_command = "open";
        default_mappings = true;
      };
    };
  };
}
