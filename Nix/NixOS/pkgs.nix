{ config, pkgs, inputs, ... }:

{

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Disable sudo by default and replace it with doas.
  security.sudo.enable = false;
  security.doas.enable = true;

  # Allow Wireshark to be enabled.
  programs.wireshark.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
   environment.systemPackages = with pkgs; [
  #  gnomeExtensions.appindicator
  #  gnomeExtensions.just-perfection
  #  gnomeExtensions.dash-to-dock
  #  gnomeExtensions.search-light
  #  gnomeExtensions.desktop-icons-ng-ding
  #  gnomeExtensions.gradient-top-bar
  #  gnomeExtensions.blur-my-shell
  #  gnomeExtensions.user-themes
  #  gnomeExtensions.custom-accent-colors
  #  gnomeExtensions.arcmenu
  #  gnomeExtensions.sound-output-device-chooser
  #  gnomeExtensions.clipboard-indicator
  #  gnomeExtensions.extension-list
  #  gnome-tweaks
  #  dconf-editor
  #  gnome-extension-manager
  #  ghostty
     maliit-keyboard
     mission-center
     pavucontrol
     baobab
     steam
     lutris
     git
     jq
     unzip
     unrar
     kdePackages.konsole
     kdePackages.ark
     kdePackages.kio
     kdePackages.kalk
     kdePackages.marknote
     zoxide
  #  timeshift
     flatpak
     podman
     distrobox
  #  docker
  #  docker-client
  #  docker-compose
  #  docker-gc
  #  docker-ls
     xhost
     spice
     spice-gtk
     spice-vdagent
     spice-protocol
     iproute2
     virt-manager
     gnome-boxes
     zenity
     phodav
     oh-my-posh
  #  q4wine
  #  bottles
     clisp
     guile
     python313
     python313Packages.python-nmap

  # support both 32- and 64-bit applications
  # wineWowPackages.stable

  # support 32-bit only
  # wine

  # support 64-bit only
  # (wine.override { wineBuild = "wine64"; })

  # wine-staging (version with experimental features)
  wineWow64Packages.staging

  # winetricks (all versions)
  winetricks

  # native wayland support (unstable)
  wineWow64Packages.waylandFull

  # Support for wine.
  winetricks

  # Support for Steam Proton.
  protontricks

 #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  ];

  nixpkgs.config.permittedInsecurePackages = [ "libxml2-2.13.8" "olm-3.2.16" ];

  # Set ZSH as the default shell.
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Obligatory Steam module option for compatability.
  programs.steam.enable = true;

  # Guix, the standalone package manager.
  # services.guix.enable = true;

  # Installed Fonts.
  fonts.packages = with pkgs; [
      meslo-lgs-nf
      corefonts
  ];


   # Home Manager configuration.
   home-manager.useGlobalPkgs = true;
   home-manager.useUserPackages = true;
   home-manager.users.saorsa = {pkgs, config, lib, ...}: {
     home.stateVersion = "22.11";
     home.packages = with pkgs; [
  #  prismlauncher
     kdePackages.kate
     fastfetch
     onlyoffice-desktopeditors
     obsidian
 #   vesktop
 #   revolt-desktop
 #   element-desktop
 #   dino
 #   hexchat
 # Privacy focused instant messanging.
 #   telegram-desktop
 #   session-desktop
 #   signal-desktop
 #   briar-desktop
 #   revolt-desktop
     element-desktop
 #   dino
 #   hexchat
     brave
 #   librewolf
    #grayjay # Broken at the moment.
 #   freetube
 #   satisfactorymodmanager
 #   sgdboop
     gnome-disk-utility
     pinta
     dolphin-emu
  #  steam-rom-manager
  #  ryujinx
  #  cemu
  #  xemu
  #  melonDS
  #  audacity
  #  spotify
     authenticator
     go-2fa
     wayclip
     mpv
     ani-cli
     lolcat
     gdlauncher-carbon
  #  For college.
     vscodium
  #  ciscoPacketTracer9
  #  wireshark
     omnissa-horizon-client
     alarm-clock-applet
  #  openvas-scanner
#    Added by Sed.
     ];

  imports = [
    inputs.zen-browser.homeModules.beta
    # or inputs.zen-browser.homeModules.twilight
    # or inputs.zen-browser.homeModules.twilight-official
  ];

  programs.zen-browser = {
    enable = true;

   };
  };
 }
