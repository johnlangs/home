{ config, pkgs, ... }:

{
  home.username = "john";
  home.homeDirectory = "/home/john";

  home.stateVersion = "24.05";
  
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    # autosuggestion.highlight = "fg=#ffffff,bg=cyan,bold,underline";
    shellAliases = {
      "ll" = "ls -l";
      "la" = "ls -a";
      ".." = "cd ..";

      "devup" = ''git add . && git commit -m "dev up" && git push'';
      "gu" = "gitui";

      "db" = "distrobox";

      "vvv" = "vagrant halt && vagrant up && vagrant ssh";
      "vup" = "vagrant up";
      "vssh" = "vagrant ssh";
      "vhalt" = "vagrant halt";
    };

    initExtra = "source init_conda";
  };

  programs.zoxide.enable = true;

  programs.git = {
    enable = true;
    userName = "johnlangs";
    userEmail = "me@johnlangs.dev";
    extraConfig = {
      init = {
        defaultBranch = "main";        
      };
    };
  };

  programs.gitui.enable = true;

  programs.starship = {
    enable = true;
    settings = {
      username = {
        style_user = "blue bold";
        style_root = "red bold";
        format = "[$user]($style) ";
        disabled = false;
        show_always = true;
      };
      hostname = {
        ssh_only = false;
        ssh_symbol = "🌐 ";
        format = "on [$hostname](bold red) ";
        trim_at = ".local";
        disabled = true;
      };
      add_newline = false;
    };
  };
  
  home.packages = [
    pkgs.neovim
    pkgs.helix
    pkgs.tmux
    pkgs.xclip
    pkgs.yazi

    pkgs.ripgrep
    pkgs.gnumake

    pkgs.bat

    pkgs.nodejs_22

    pkgs.go
    pkgs.gopls
    pkgs.gotools

    pkgs.python3
    pkgs.python311Packages.conda
    pkgs.pyright

    pkgs.rustup
    
    pkgs.zig
    pkgs.zls

    pkgs.distrobox

    (pkgs.writeShellScriptBin "init_zsh" ''
      command -v zsh | sudo tee -a /etc/shells      
      chsh -s $(which zsh)  
    '')

    (pkgs.writeShellScriptBin "init_alacritty" ''
      rustup override set stable
      rustup update stable

      sudo apt -y install cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3

      git clone https://github.com/alacritty/alacritty
      cd ./alacritty

      rustup update stable
      cargo build --release

      sudo tic -xe alacritty,alacritty-direct extra/alacritty.info
      sudo cp target/release/alacritty /usr/local/bin # or anywhere else in $PATH
      sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
      sudo desktop-file-install extra/linux/Alacritty.desktop
      sudo update-desktop-database

      cd ..
      rm -rf ./alacritty
    '')

    (pkgs.writeShellScriptBin "init_conda" ''
      # >>> conda initialize >>>
      # !! Contents within this block are managed by 'conda init' !!
      __conda_setup="$('/home/john/.conda/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
      if [ $? -eq 0 ]; then
          eval "$__conda_setup"
      else
          if [ -f "/home/john/.conda/etc/profile.d/conda.sh" ]; then
              . "/home/john/.conda/etc/profile.d/conda.sh"
          else
              export PATH="/home/john/.conda/bin:$PATH"
          fi
      fi
      unset __conda_setup
      # <<< conda initialize <<<

      conda config --set changeps1 False
    '')

    (pkgs.writeShellScriptBin "init_virt" ''
      sudo apt-get update
      sudo apt-get -y install podman

      # Install Virtual Box
      wget https://download.virtualbox.org/virtualbox/7.0.18/virtualbox-7.0_7.0.18-162988~Ubuntu~jammy_amd64.deb
      sudo apt install ./virtualbox-7.0_7.0.18-162988~Ubuntu~jammy_amd64.deb

      # Add current user to vboxusers group
      sudo usermod -a -G vboxusers $USER
      
      # Install Vagrant
      wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
      echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
      sudo apt update && sudo apt install vagrant
    '')

    (pkgs.writeShellScriptBin "init_ros" ''

    '')

    (pkgs.writeShellScriptBin "init_gaming" ''
      # Install Steam
      flatpak install -y --noninteractive flathub com.valvesoftware.Steam

      # Install Lutris
      flatpak install -y --noninteractive flathub net.lutris.Lutris

      # Install Discord
      flatpak install -y --noninteractive flathub com.discordapp.Discord
    '')
  ];

  home.file = {
    ".config/tmux/tmux.conf".source = dotfiles/tmux/tmux.conf;
    ".config/alacritty/alacritty.toml".source = dotfiles/alacritty/alacritty.toml;
    ".config/helix/config.toml".source = dotfiles/helix/config.toml;
    ".config/helix/languages.toml".source = dotfiles/helix/languages.toml;
    ".config/wezterm/wezterm.lua".source = dotfiles/wezterm/wezterm.lua;
  };

  home.sessionVariables = {
    EDITOR = "hx";
  };

  programs.home-manager.enable = true;
}
