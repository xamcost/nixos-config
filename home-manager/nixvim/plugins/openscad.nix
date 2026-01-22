{
  homeConfigName,
  ...
}:
let
  isEnabled = builtins.elem homeConfigName [ "maximecostalonga@xam-mac-m4" ];
in
{
  programs.nixvim = {
    plugins.openscad = {
      enable = isEnabled;
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
