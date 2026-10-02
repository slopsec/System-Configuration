{ config, inputs, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "saorsa";
  home.homeDirectory = "/home/saorsa";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "26.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
      meslo-lgs-nf
      corefonts
      deepfilternet
#     prismlauncher
      onlyoffice-desktopeditors
#     obsidian
#     vesktop
   # Privacy focused instant messanging.
      telegram-desktop
      session-desktop
      signal-desktop
#     briar-desktop
#     revolt-desktop
#     element-desktop
#     sable-unwrapped
#     cwtch-ui
      xdg-utils
#     dino
      gajim
#     hexchat
      mission-center
      brave-origin
      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
      winetricks
      protontricks
      protonup-qt
#     pavucontrol
      grayjay
#     freetube
#     satisfactorymodmanager
      pinta
      protonup-qt
      steam
#     steam-rom-manager
#     ryujinx
#     cemu
#     xemu
#     melonDS
#     audacity
#     spotify
#     authenticator
#     oh-my-posh
#     oh-my-zsh
#     go-2fa
#     wayclip
#     gdlauncher-carbon
      prismlauncher
  # For college.
#     vscodium
      cisco-packet-tracer_9
#     wireshark
#     teams-for-linux
      omnissa-horizon-client
      gst_all_1.gstreamer
      gst_all_1.gst-plugins-good
      gst_all_1.gst-plugins-bad
      gst_all_1.gst-libav
      alarm-clock-applet
#     openvas-scanner
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

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

  # Overlay for cisco-packet-tracer_9 to address an issue between Nix versions.
  nixpkgs.overlays = [ (final: prev: {
  packettracer = prev.packettracer.overrideAttrs (old: {
    src = prev.requireFile {
      name = "CiscoPacketTracer_901_Ubuntu_64bit.deb";
      sha256 = "sha256-NoPdh+d5iFNyrpo1wabllNEvST5knnxpdAhynBRZR5s=";
    };
  });
}) ];

  fonts.fontconfig.enable = true;
  fonts.fontconfig.defaultFonts = {
    sansSerif = [ "Noto Sans" ];
    serif = [ "Noto Serif" ];
    monospace = [ "Fira Code" ];
    emoji = [ "Noto Color Emoji" ];
  };

  # Enable Nix Commands and flakes.
    nix = {
     package = pkgs.nix;
     settings.experimental-features = [ "nix-command" "flakes" ];
    };

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
  #  /etc/profiles/per-user/saorsa/etc/profile.d/hm-session-vars.sh
  #
  # home.sessionVariables = {
  #    EDITOR = "nano";
  # };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
