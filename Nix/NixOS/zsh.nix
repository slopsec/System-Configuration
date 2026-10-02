{pkgs, ...}:
{
  users.users.saorsa = {
    isNormalUser = true;
    shell = pkgs.zsh;
  };
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    shellAliases = {
        ls = "ls -lah --color=tty | lolcat";
        clear = "printf '\e[2J\e[H'";
        system-gc = "su -c 'guix gc --delete-generations=1m' - && su -c 'nix-collect-garbage -d' - && guix gc --delete-generations=1m && nix-collect-garbage -d";
        system-update = "su -c 'nixos-rebuild switch --flake /home/saorsa/.files/Symlinks/Projects/.coding/Nix/NixOS#default' - && guix time-machine -C /media/shared/.files/Symlinks/Projects/.coding/Lisp/Guix/lock.scm -- home reconfigure /home/saorsa/.files/Symlinks/Projects/.coding/Lisp/Guix/home-configuration.scm";
        neofetch = "fastfetch | lolcat";
        cd = "z";
        shutdown = "systemctl poweroff";
        sudo = "doas";
  };
 };
}
