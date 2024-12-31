{ pkgs, ... }: {
  imports = [
    ../../cli
  ];

  home.packages = with pkgs; [
    git
    vim
    wget
  ];
}
