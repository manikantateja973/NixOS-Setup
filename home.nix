{ config, pkgs, lib,... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "mani";
  home.homeDirectory = "/home/mani";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
     pkgs.hello
     pkgs.kitty
     #pkgs.tmux
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/mani/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
    #SHELL = "${pkgs.zsh}";
  };
  #home.defaultShell = "${pkgs.zsh}";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  
  #home.file.".p10k.zsh".source = ~/.p10k.zsh;
 
  programs.zsh = {
  enable = true;
  enableCompletion = true;
  autosuggestion.enable = true;
  syntaxHighlighting.enable = true;
  initExtra = "source ~/.p10k.zsh"; 
  plugins = [
      {
        name = "zsh-powerlevel10k";
        src = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/";
        file = "powerlevel10k.zsh-theme";
      }
    ];
 
  shellAliases = {
    ll = "ls -l";
    update = "sudo nixos-rebuild switch";
    vim = "nvim";
  };
  history = {
    size = 10000;
    path = "${config.xdg.dataHome}/zsh/history";
  };
  zplug = {
    enable = true;
    plugins = [
      { name = "zsh-users/zsh-autosuggestions"; } # Simple plugin installation
      { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; } # Installations with additional options. For the list of options, please refer to Zplug README.
    ];
  };
  oh-my-zsh = {
    enable = true;
    plugins = [ "git" "thefuck" ];
    theme = "robbyrussell";
  };
  };
  
  
  programs.kitty = lib.mkForce {
  enable = true;
  settings = {
    confirm_os_window_close = 0;
    dynamic_background_opacity = true;
    enable_audio_bell = false;
    mouse_hide_wait = "-1.0";
    window_padding_width = 10;
    background_opacity = "0.5";
    background_blur = 5;
    tab_bar_min_tabs = 1;
    tab_bar_edge       =         "bottom";
    tab_bar_style      =         "powerline";
    tab_powerline_style =        "slanted";
    tab_title_template   =      "{title}{' :{}:'.format(num_windows) if num_windows > 1 else ''}";
    
    #Catppuccin theme
    # The basic colors
    foreground = "#cdd6f4";
    background = "#1e1e2e";

  selection_foreground = "#1e1e2e";
  selection_background = "#f5e0dc";

  # Cursor colors
  cursor = "#f5e0dc";
  cursor_text_color = "#1e1e2e";

  # URL underline color when hovering with mouse
  url_color = "#f5e0dc";

  # Kitty window border colors
  active_border_color = "#b4befe";
  inactive_border_color = "#6c7086";
  bell_border_color = "#f9e2af";

  # OS Window titlebar colors
  wayland_titlebar_color = "system";
  macos_titlebar_color = "system";

  # Tab bar colors
  active_tab_foreground = "#11111b";
  active_tab_background = "#cba6f7";
  inactive_tab_foreground = "#cdd6f4";
  inactive_tab_background = "#181825";
  tab_bar_background = "#11111b";

  # Colors for marks (marked text in the terminal)
  mark1_foreground = "#1e1e2e";
  mark1_background = "#b4befe";
  mark2_foreground = "#1e1e2e";
  mark2_background = "#cba6f7";
  mark3_foreground = "#1e1e2e";
  mark3_background = "#74c7ec";

  # The 16 terminal colors

  # black
  color0 = "#45475a";
  color8 = "#585b70";

  # red
  color1 = "#f38ba8";
  color9 = "#f38ba8";

  # green
  color2 = "#a6e3a1";
  color10 = "#a6e3a1";

  # yellow
  color3 = "#f9e2af";
  color11 = "#f9e2af";

  # blue
  color4 = "#89b4fa";
  color12 = "#89b4fa";

  # magenta
  color5 = "#f5c2e7";
  color13 = "#f5c2e7";

  # cyan
  color6 = "#94e2d5";
  color14 = "#94e2d5";

  # white
  color7 = "#bac2de";
  color15 = "#a6adc8";
};
  };

  }
