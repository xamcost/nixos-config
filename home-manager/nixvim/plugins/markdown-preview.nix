{
  lib,
  pkgs,
  homeConfigName,
  ...
}:
let
  isEnabled =
    !builtins.elem homeConfigName [
      "xam@aeneas"
      "xamcost@elysium"
    ];

  # Maintained fork of markdown-preview.nvim with prebuilt binaries for macOS ARM64
  markdownPreviewSrc = pkgs.fetchFromGitHub {
    owner = "sammaji";
    repo = "markdown-preview.nvim";
    rev = "ab85014cff9baadd49d4d9f495720658af64a158";
    hash = "sha256-qbTlHtcyZxPl/UeMWgpLEi7xSQtmT/pnqp4NQoy2Byo=";
  };
  version = "0.2.0";
  binaryName = "markdown-preview-macos-arm64";
  serverArchive = pkgs.fetchurl {
    url = "https://github.com/sammaji/markdown-preview.nvim/releases/download/v${version}/${binaryName}.tar.gz";
    hash = "sha256-Ik8KSaYKWm5c4jj8nv+BuLIPJkOvYzJQTudMZrEbmQE=";
  };
  markdownPreview = pkgs.vimUtils.buildVimPlugin {
    pname = "markdown-preview-sammaji";
    inherit version;
    src = markdownPreviewSrc;
    postInstall = ''
      mkdir -p "$out/app/bin"
      tar -xzf ${serverArchive} -C "$out/app/bin"
      chmod +x "$out/app/bin/${binaryName}"
      test -x "$out/app/bin/${binaryName}"
    '';
    doCheck = false;
  };
in
{
  programs.nixvim = {
    plugins.markdown-preview = {
      enable = isEnabled;
      package = markdownPreview;

      settings = {
        command_for_global = 1;
      };
    };

    plugins.which-key.settings.spec = lib.mkIf isEnabled [
      {
        __unkeyed-1 = "<leader>m";
        mode = "n";
        icon = " ";
        group = "Markdown";
      }
    ];

    keymaps =
      if isEnabled then
        [
          {
            mode = "n";
            key = "<leader>mp";
            action = ":MarkdownPreviewToggle<CR>";
            options.desc = "Toggle Markdown Preview";
          }
        ]
      else
        [ ];
  };
}
