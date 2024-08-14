
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader = {
  grub = {
    enable = true;  # Enable GRUB bootloader
    useOSProber = true; # Automatically detect other OSes
    copyKernels = true; # Copy kernels into the GRUB directory (optional)
    efiSupport = true;  # Enable EFI support (if applicable)
    efiInstallAsRemovable = false; # Install GRUB on a separate EFI partition (UEFI only)
    device = "nodev";   # Don't install on any specific device (recommended)
    };
  };  
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;
  

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  
  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.theme = "captppuccin-mocha";
  services.desktopManager.plasma6.enable = false;

  # Configure GDM as display manager
  services.xserver.displayManager.gdm.enable = false;

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mani = {
    isNormalUser = true;
    description = "Mani";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
    #shell = pkgs.zsh;
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Authentication agents
  systemd = {
  user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    neovim
    alacritty 
    jitsi-meet
    git 
    wget
    gcc
    libgccjit
    gnumake
    lf
    #tmux stuff
    tmux
    tmuxPlugins.vim-tmux-navigator
    tmuxPlugins.sensible
    tmuxPlugins.yank
    emacs
    zsh
    qt5ct
    qt6ct
    wl-clipboard
    firefox-wayland
    home-manager
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk
    hyprland
    xwayland 
    dconf
    networkmanagerapplet
    waybar # For wayland, enables configuration with json and css
    (waybar.overrideAttrs (oldAttrs: {
	mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
	}))
    dunst # Notification daemon
    libnotify # dependency for dunst
    swww # wall paper
    kitty # hyprland default's terminal
    rofi-wayland # app launcher
    #Fonts
    nerdfonts
    zip
    pipewire
    wireplumber
    jitsi
    keyd
    dolphin
    wofi
    rofi-power-menu
    eww  
    trayer
    socat
    geticons
    rofi-bluetooth
    networkmanager_dmenu
    zsh-powerlevel10k
    thefuck
    lemurs
    #greetd.greetd
    greetd.tuigreet
    #theme for hyprland
      glib
      gsettings-desktop-schemas
      gtk3
      catppuccin-gtk
      nwg-look
      papirus-icon-theme
      catppuccin-cursors.mochaDark
  ];
  programs.tmux = {
	enable = true;
	extraConfig = ''
  	set-option -g default-command "bash --rcfile ~/.bashrc";
        run-shell ${pkgs.tmuxPlugins.sensible}/share/tmux-plugins/sensible/sensible.tmux
	run-shell ${pkgs.tmuxPlugins.vim-tmux-navigator}/share/tmux-plugins/vim-tmux-navigator/vim-tmux-navigator.tmux 
 	run-shell ${pkgs.tmuxPlugins.yank}/share/tmux-plugins/yank/yank.tmux 
	'';
  };
  
  services.greetd = {
	enable = true;
	settings = rec {
		initial_session = {
		command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --time-format '%a, %d %b %Y • %T' --greeting  '[Become Visible]' --asterisks --remember --theme 'border=magenta;text=cyan;prompt=green;time=red;action=blue;button=yellow;container=black;input=red' --cmd Hyprland";
		user = "mani";
	};
	default_session = initial_session;
     };
  };

  programs.zsh.enable = false;

  qt = {
	enable = true;
	platformTheme="qt5ct";
  };
  
  # Setting the cursor theme for the user
  environment.variables = {
    XCURSOR_THEME = "Catppuccin-Mocha-Dark";  # Ensure the theme name matches the installed theme
  };
  
  # setting zsh as the shell
  environment.shells = with pkgs; [ bash ];
    
  # Optional, but makes sure that when you type the make palm rejection work with keyd
  # https://github.com/rvaiya/keyd/issues/723
  environment.etc."libinput/local-overrides.quirks".text = ''
    [Serial Keyboards]
    MatchUdevType=keyboard
    MatchName=keyd virtual keyboard
    AttrKeyboardIntegration=internal
  '';
  environment.etc = {
    "sddm/themes/catppuccin-mocha".source = pkgs.fetchurl {
      url = "https://github.com/catppuccin/sddm/releases/download/v1.0.0/catppuccin-mocha.zip";  # replace with the correct URL
      sha256 = "1fb17a79685d97ea616e81c0b9f4fd01c70bdd08f4f5c11d33db7eb0b1d32999";  # replace with the correct sha256 hash
    };
  };

  # Fonts
  fonts.packages = with pkgs; [
  (nerdfonts.override { fonts = [ "JetBrainsMono" "Mononoki" "FiraCode"]; })
  ];

  # Desktop protal 
   xdg.portal.enable = true;
   xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
 
  # Enabling hyprland on NixOS
  programs.hyprland = {
	enable = true;
	xwayland.enable = true;
  };
  
  environment.sessionVariables = {
	# If the cursor becomes invisible
	WLR_NO_HARDWARE_CURSORS = "1";
	# Hint electron apps to use wayland
	NIXOS_OZONE_WL = "1";	 
  };
  
  #Enable polkit for hyprland
  security.polkit.enable = true; 
  
  # Enable OpenGL
  hardware.opengl = {
    enable = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.beta;
    }; 

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

  #Bluetooth
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
  
  services.blueman.enable = true;
}

