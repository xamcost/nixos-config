{ pkgs, ... }:
{
  programs.nixvim = {
    extraPlugins = [(pkgs.vimUtils.buildVimPlugin {
      name = "nvim-base64";
      src = pkgs.fetchFromGitHub {
	owner = "deponian";
	repo = "nvim-base64";
	rev = "0.2.0";
	hash = "sha256-zBhSQCxcFh5s1ekyoLy48IKB+nkj9JsUfz+KWSYGVYQ=";
      };
    })];

    extraConfigLua = ''
      require('nvim-base64').setup({})
    '';

    keymaps = [
      {
	mode = "x";
	key = "<leader>Bd";
	action = "<Plug>(FromBase64)";
	options.desc = "Decode base64";
      }
      {
	mode = "x";
	key = "<leader>Be";
	action = "<Plug>(ToBase64)";
	options.desc = "Encode base64";
      }
    ];
  };
}
