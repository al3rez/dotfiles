{ pkgs, ... }:
let
  plemoljp-nf = pkgs.stdenvNoCC.mkDerivation {
    pname = "plemoljp-nf";
    version = "3.0.0";

    src = pkgs.fetchzip {
      url = "https://github.com/yuru7/PlemolJP/releases/download/v3.0.0/PlemolJP_NF_v3.0.0.zip";
      hash = "sha256-xHxILHQ4eCzDeyRLi+mq1HhcT+Aghr345WyOBJ8q5eQ=";
      stripRoot = false;
    };

    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/fonts/truetype
      find . -type f \( -name "*.ttf" -o -name "*.otf" \) -exec cp {} $out/share/fonts/truetype/ \;
      runHook postInstall
    '';
  };
in {
  home.username = "al3rez";
  home.homeDirectory = "/home/al3rez";

  # Keep this at your initial HM version unless you intentionally migrate.
  home.stateVersion = "24.11";

  fonts.fontconfig.enable = true;

  # Install apps with Nix.
  home.packages = with pkgs; [
    kitty
    tmux
    neovim
    hyprland
    walker
    swaybg
    wl-clipboard
    plemoljp-nf
  ];

  # Manage configs from this repo.
  home.file = {
    ".bashrc".source = ./.bashrc;
    ".tmux.conf".source = ./.tmux.conf;
    ".local/bin/kitty".source = ./bin/kitty;

    ".config/kitty/kitty.conf".source = ./.config/kitty/kitty.conf;
    ".config/starship.toml".source = ./.config/starship.toml;

    ".config/nvim" = {
      source = ./.config/nvim;
      recursive = true;
    };

    ".config/hypr" = {
      source = ./.config/hypr;
      recursive = true;
    };

    ".config/walker" = {
      source = ./.config/walker;
      recursive = true;
    };

    "Pictures/13-Ventura-Light.jpg".source = ./wallpapers/13-Ventura-Light.jpg;
    "Pictures/13-Ventura-Dark.jpg".source = ./wallpapers/13-Ventura-Dark.jpg;
  };

  # Avoid generating Home Manager options/manpage artifacts during activation.
  manual.json.enable = false;
  manual.manpages.enable = false;

  programs.home-manager.enable = true;
}
