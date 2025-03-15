{ homeConfigName, ... }:
let
  isEnabled = !builtins.elem homeConfigName [
    "xam@aeneas" "xamcost@elysium"
  ];
in
{
  programs.nixvim = {
    plugins.octo = {
      enable = isEnabled;

      lazyLoad = {
	settings = {
	  cmd = "Octo";
	};
      };

      settings = {
	suppress_missing_scope = { projects_v2 = true; };
      };
    };
  };
}

