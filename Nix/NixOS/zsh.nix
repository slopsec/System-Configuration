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
        ls = "ls -lah | lolcat";
        nix-update = "doas nix flake update --flake /etc/nixos && doas nixos-rebuild switch --flake /etc/nixos#default && nix-collect-garbage -d && doas nix-collect-garbage -d";
        neofetch = "fastfetch | lolcat";
        cd = "z";
        college = "2fa college | waycopy";
        shutdown = "systemctl poweroff";
        sudo = "doas";
  };
 };
}
