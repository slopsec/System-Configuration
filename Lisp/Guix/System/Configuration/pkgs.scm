(define-module (Configuration pkgs)
  #:use-module (gnu)
  #:use-module (gnu system privilege)
  #:use-module (gnu home)
  #:use-module (gnu home services)
  #:use-module (gnu home services desktop)
  #:use-module (gnu home services shells)
  #:use-module (gnu home services sound)
  #:use-module (gnu home services symlink-manager)
  #:use-module (gnu home services shepherd)
  #:use-module (guix)
  #:use-module (guix gexp)
  #:use-module (gnu packages admin)
  #:use-module (gnu system shadow)
  #:use-module (gnu services)
  #:use-module (gnu services guix)
  #:use-module (gnu services virtualization)
  #:use-module (gnu services dbus)
  #:use-module (gnu services nix)
  #:use-module (gnu services cups)
  #:use-module (gnu services desktop)
  #:use-module (gnu services sddm)
  #:use-module (gnu services networking)
  #:use-module (gnu services spice)
  #:use-module (gnu packages spice)
  #:use-module (gnu services ssh)
  #:use-module (gnu services xorg)
  #:use-module (srfi srfi-1)
  #:use-module (Configuration plasma)
  #:export (the-keyboard-layout
            %base-packages-doas
            %privileged-programs
            system-packages
            system-services
            home-packages
            home-services
            system-bootloader))

  ;; Defining the keyboard layout in use.
  (define the-keyboard-layout (keyboard-layout "gb"))

  ;; Definitions to remove sudo and replace it with doas on GNU Guix.
  (define %base-packages-doas
    (remove
    (lambda (package)
      (string=? (package-name package) "sudo"))
    %base-packages))

  (define %privileged-programs
    (cons
    (privileged-program
      (program (file-append opendoas "/bin/doas"))
      (setuid? #t))

    (remove
      (lambda (entry)
        (let ((program (privileged-program-program entry)))
          (or
          (equal? program
                  (file-append sudo "/bin/sudo"))
          (equal? program
                  (file-append sudo "/bin/sudoedit")))))
      %default-privileged-programs)))

  ;; Packages installed system-wide.  Users can also install packages
  ;; under their own account: use 'guix search KEYWORD' to search
  ;; for packages and 'guix install PACKAGE' to install a package.
  (define system-packages (append (specifications->packages
                                    '("opendoas"
                                      "nss-certs"
                                      "xdg-utils"
;                                      "nftables"
;                                      "ulogd"
;                                      "clamav"
                                      "font-google-noto"
                                      "font-google-noto-emoji"
                                      "font-sarasa-gothic"
                                      "font-meslo-lg"
                                      "font-nerd-symbols"

                                      ;; Global Packages.
                                      "easyeffects"
                                      "wl-clipboard"
                                      "distrobox"
                                      "podman"
                                      "nix"
                                      "pavucontrol-qt"
                                      "zsh"
                                      "zsh-completions"                       ;;TODO Find out how to get the source packages to work.
                                      "zsh-autosuggestions"                   ;; For both packages.
                                      "zsh-syntax-highlighting"
                                      "wayland-protocols"
                                      "qemu"
                                      "lvm2"
                                      "drbd-utils"
                                      "ceph"
                                      "virt-manager"
                                      "gnome-boxes"
                                      "x11-ssh-askpass"
                                      "bridge-utils"
                                      "spice"
                                      "spice-protocol"
                                      "spice-vdagent"
                                      "spice-gtk"
                                      "asco"
                                      "phodav"
                                      "git"
                                      "file"
                                      "gawk"
                                      "bash"
                                      "git"
                                      "ripgrep"
                                      "unzip"
                                      "wget"
                                      "xdotool"
                                      "xprop"
                                      "xrandr"
                                      "xwininfo"
                                      "xxd"
                                      "yad"
                                      "jq"
                                      "uchardet"
                                      "unrar"
                                      "kate"
                                      "kcalc"
                                      "gwenview"
                                      "ark"
                                      "zoxide"))
                                  %base-packages-doas))

  (define home-packages
                                  (specifications->packages
                                  '("glibc-locales"
                                    "fastfetch"
                                    "steam"
                                    "wine64-staging"
                                    "wine-staging-patchset-data"
                                    "emacs"
                                    "emacs-dashboard"
                                    "emacs-projectile"
                                    "emacs-counsel-projectile"
                                    "emacs-ag"
                                    "emacs-vertico"
                                    "emacs-marginalia"
                                    "emacs-org-brain"
                                    "emacs-org-modern"
                                    "emacs-olivetti"
                                    "emacs-guix"
                                    "emacs-use-package"
                                    "emacs-magit"
                                    "emacs-ivy"
                                    "emacs-ivy-rich"
                                    "emacs-which-key"
                                    "emacs-pcmpl-args"
                                    "emacs-auto-complete"
                                    "emacs-goto-chg"
                                    "emacs-taxy-magit-section"
                                    "emacs-doom-modeline"
                                    "emacs-counsel"
                                    "emacs-swiper"
                                    "emacs-rainbow-delimiters"
                                    "emacs-helpful"
                                    "emacs-nerd-icons"
                                    "emacs-all-the-icons"
                                    "emacs-all-the-icons-completion"
                                    "emacs-all-the-icons-dired"
                                    "emacs-ement"
                                    "emacs-slime"
                                    "sbcl"
                                    "sbcl-alexandria"
                                    "sbcl-quicksearch"
                                    "gajim"
                                    "librewolf"
                                    "calligra"
                                    "otpclient"
                                    "dolphin-emu"
                                    "mpv"
                                    "ffmpeg"
                                    "yt-dlp"
                                    "fzf"
                                    "openssl"
                                    "ani-cli"
                                    "gnome-disk-utility"
                                    "lolcat"
                                    "obsidian"

                                    ;; For College
                                    "python"
                                    "wireshark"
                                    "vscodium")))

  (define home-services
    (list
    ;; example:
       (service home-zsh-service-type
         (home-zsh-configuration
           (environment-variables
             '(("EDITOR" . "emacs")))
           (zshrc
             (list
               (local-file
                "/media/shared/.files/Symlinks/Projects/.configuration/Software/zshrc")
                  (plain-file
                    "aliases"
                      "alias ll='ls -lah'
                      alias guix-update='doas guix pull -C /media/shared/.files/Symlinks/Projects/.coding/Lisp/Guix/rolling.scm && doas guix describe -f channels > /media/shared/.files/Symlinks/Projects/.coding/Lisp/Guix/lock.scm && guix pull -C /home/saorsa/.files/Symlinks/Projects/.coding/Lisp/Guix/lock.scm && nix flake update --flake /media/shared/.files/Symlinks/Projects/.coding/Nix'
                      alias guix-system='doas guix time-machine -C /media/shared/.files/Symlinks/Projects/.coding/Lisp/Guix/lock.scm -- system -L /media/shared/.files/Symlinks/Projects/.coding/Lisp/Guix/System reconfigure /media/shared/.files/Symlinks/Projects/.coding/Lisp/Guix/System/Configuration/configuration.scm && home-manager switch --flake /media/shared/.files/Symlinks/Projects/.coding/Nix'
                      alias home-update='guix pull -C /home/saorsa/.files/Symlinks/Projects/.coding/Lisp/Guix/lock.scm'
                      alias guix-home='guix time-machine -C /media/shared/.files/Symlinks/Projects/.coding/Lisp/Guix/lock.scm -- home reconfigure /home/saorsa/.files/Symlinks/Projects/.coding/Lisp/Guix/home-configuration.scm'
                      alias guix-gc='guix gc --delete-generations=1m && nix-collect-garbage -d && doas guix gc --delete-generations=1m && doas nix-collect-garbage -d'
                      alias ls='ls -lah --color=tty | lolcat'
                      alias neofetch='fastfetch | lolcat'
                      alias cd='z'
                      alias sudo='doas'
                      alias college='2fa college | waycopy'")))))
       (service home-dbus-service-type)
       (service home-pipewire-service-type
        (home-pipewire-configuration
         (enable-pulseaudio? #t)))

           ;; Global theme configuration for KDE PLasma.
           (service home-plasma-look-and-feel-service-type
             (plasma-look-and-feel-configuration
               (name "Utterly-Mine")))

           ;; Home-manager activation hook.
            (simple-service
              'home-manager-activation
              home-activation-service-type
              #~(let ((status
                      (system* "su" "-" "saorsa" "-c"
                                "/home/saorsa/.nix-profile/bin/home-manager switch --flake /media/shared/.files/Symlinks/Projects/.coding/Nix")))
                  (if (zero? status)
                      (format #t "Flake update failed, skipping Home Manager\n"))))

             ;; System Symlinks.
             (simple-service
             'symlink
             home-activation-service-type
             #~(begin
             (use-modules (ice-9 match)
             (ice-9 ftw))

             (define symlinks
                      '(("/media/shared/.files/Symlinks/Desktop"
                         "/home/saorsa/Desktop")
                        ("/media/shared/.files/Symlinks/Documents"
                         "/home/saorsa/Documents")
                        ("/media/shared/.files/Symlinks/Downloads"
                         "/home/saorsa/Downloads")
                        ("/media/shared/.files/Symlinks/Media/Music"
                         "/home/saorsa/Music")
                        ("/media/shared/.files/Symlinks/Media/Pictures"
                         "/home/saorsa/Pictures")
                        ("/media/shared/.files/Symlinks/Media/Videos"
                         "/home/saorsa/Videos")
                        ("/media/shared/.files/Symlinks/Projects"
                         "/home/saorsa/Projects")
                        ("/media/shared/.files/Symlinks/Public"
                         "/home/saorsa/Public")
                        ("/media/shared/.files/Symlinks/Templates"
                         "/home/saorsa/Templates")
                        ("/media/shared/.files/Symlinks/Projects/.configuration/Games"
                         "/home/saorsa/Games")
                        ("/media/shared/.files"
                         "/home/saorsa/.files")
                        ("/media/shared/.files/Symlinks/Projects/.ssh"
                         "/home/saorsa/.ssh")
                        ("/media/shared/.files/Symlinks/Projects/.configuration/Software/Grayjay"
                         "/home/saorsa/.local/share/Grayjay")
                        ("/media/shared/.files/Symlinks/Projects/.configuration/Software/konsole"
                         "/home/saorsa/.local/share/konsole")
                        ("/media/shared/.files/Symlinks/Projects/.virt"
                         "/home/saorsa/.virt")
                        ("/media/shared/.files/Symlinks/Projects/.containers"
                         "/home/saorsa/.containers")
                        ("/media/shared/.files/Symlinks/Projects/.configuration/Software/.zshrc"
                        "/home/saorsa/.config/zsh/.zshrc")
                        ("/media/shared/.files/Symlinks/Projects/.configuration/Games/Arcanists/SavedData"
                         "/media/shared/SteamLibrary/steamapps/common/Arcanists/SavedData")
                        ("/media/shared/.files/Symlinks/Projects/.configuration/Software/Plasma/kdedefaults"
                        "/home/saorsa/.config/kdedefaults")
                        ("/media/shared/SteamLibrary/steamapps"
                        "/home/saorsa/.local/share/guix-sandbox-home/.local/share/Steam/steamapps")
                        ("/media/shared/.files/Symlinks/Projects/.coding/Nix"
                        "/home/saorsa/.config/home-manager")
                        ("/media/shared/.files/Symlinks/Projects/.configuration/Software/applications"
                        "/home/saorsa/.local/share/applications")
                        ("/media/shared/.files/Symlinks/Projects/.configuration/Software/Plasma/plasma"
                        "/home/saorsa/.local/share/plasma")
                        ("/media/shared/.files/Symlinks/Projects/.configuration/Software/Plasma/plasma-workspace"
                        "/home/saorsa/.config/plasma-workspace")
                        ("/media/shared/.files/Symlinks/Projects/.configuration/Software/Browsers/librewolf/gqjz8zx6.Arkenfox"
                        "/home/saorsa/.config/librewolf/librewolf/gqjz8zx6.Arkenfox")
                        ("/media/shared/.files/Symlinks/Projects/.configuration/Software/Browsers/BraveSoftware"
                        "/home/saorsa/.config/BraveSoftware")
                        ("/media/shared/.files/Symlinks/Projects/.configuration/Software/.oh-my-zsh"
                        "/home/saorsa/.oh-my-zsh")
                        ("/home/saorsa/.local/share/guix-sandbox-home/.local/share/Steam"
                        "/home/saorsa/.local/share/Steam")
                        ("/media/shared/.files/Symlinks/Projects/.virt"
                        "/home/saorsa/.local/share/gnome-boxes/images")
                        ("/media/shared/.files/Symlinks/Projects/.virt"
                        "/var/lib/libvirt/images")
                        ("/media/shared/.files/Symlinks/Projects/.coding/Lisp/Emacs"
                        "/home/saorsa/.emacs.d")))

                    (define (sys-sym src dst)
                      (unless (or (file-exists? dst)
                                  (file-is-symbolic-link? dst))
                        (mkdir-p (dirname dst))
                        (symlink src dst)
                        ;; make the link owned by the user
                        (chown dst (passwd:uid (getpwnam "saorsa"))
                                  (passwd:gid (getpwnam "saorsa")))))

                    (for-each (match-lambda
                                ((src dst) (sys-sym src dst)))
                              symlinks)))))

  ;; Below is the list of system services.  To search for available
  ;; services, run 'guix system search KEYWORD' in a terminal.
  (define system-services
   (cons*        (service plasma-desktop-service-type)

                 ;; To configure OpenSSH, pass an 'openssh-configuration'
                 ;; record as a second argument to 'service' below.
                 (service sddm-service-type
                  (sddm-configuration
                   (auto-login-user "saorsa")
                   (auto-login-session "plasma.desktop")
                   (themes-directory "/home/saorsa/.local/share/sddm/themes")
                   (theme "Utterly-Sweet")
                   (remember-last-user? #t)
                   (remember-last-session? #t)))
                 (service libvirt-service-type
                  (libvirt-configuration
                   (unix-sock-group "libvirt")))
                (service virtlog-service-type
                 (virtlog-configuration
                  (max-clients 1000)))
                 (service nix-service-type)
                 (service openssh-service-type
                  (openssh-configuration
                   (port-number 6967)
                   (permit-root-login #f)
                   (password-authentication? #f)
                   (public-key-authentication? #f)))
                 (service iptables-service-type)
                 (service spice-vdagent-service-type)
                 (simple-service 'spice-polkit polkit-service-type (list spice-gtk))
               ; (service tor-service-type)
               ; (set-xorg-configuration
               ;  (xorg-configuration (keyboard-layout the-keyboard-layout)))

           ;; Configure doas.conf.
           (simple-service
           'doas-config
           etc-service-type
           `(("doas.conf"
               ,(plain-file
                 "doas.conf"
                 "permit persist :wheel\n"))))

            ;; Nested home configuration.
            (service guix-home-service-type
                      `(("saorsa"
                        ,(home-environment
                          (packages home-packages)
                          (services home-services)))))

           ;; Udev rule for allowing Steam to use hidraw for the Steam Deck controls.
           (simple-service
           'steamdeck-hidraw
           udev-service-type
           (list
             (udev-rule
             "60-steamdeck-hidraw.rules"
             "KERNEL==\"hidraw*\", ATTRS{idVendor}==\"28de\", TAG+=\"uaccess\"")
             (udev-rule
             "60-uinput.rules"
             "KERNEL==\"uinput\", TAG+=\"uaccess\"")))

           ;; "Nonguix": binary substitutes for non-free packages
           (simple-service 'nonguix guix-service-type
             (guix-extension
               (authorized-keys
               (list (plain-file "nonguix.pub"
                       "(public-key (ecc (curve Ed25519) (q #C1FD53E5D4CE971933EC50C9F307AE2171A2D3B52C804642A7A35F84F3A4EA98#)))")))
               (substitute-urls
               '("https://substitutes.nonguix.org"))))

           ;; "Guix Moe": Build farm and mirrors for community channels
           (simple-service 'guix-moe guix-service-type
             (guix-extension
               (authorized-keys
               (list (plain-file "guix-moe.pub"
                       "(public-key (ecc (curve Ed25519) (q #552F670D5005D7EB6ACF05284A1066E52156B51D75DE3EBD3030CD046675D543#)))")))
               (substitute-urls
               '("https://cache-fi.guix.moe"))))

           ;; This is the default list of services we
           ;; are appending to.
           (remove (lambda (service) (eq? (service-kind service) gdm-service-type)) %desktop-services)))

  (define system-bootloader (bootloader-configuration
                              (bootloader grub-efi-bootloader)
                              (targets (list "/boot/efi"))
                              (menu-entries
                                (list
                                  (menu-entry
                                  (label "NixOS")
                                  (device (uuid "246C-4059" 'fat))
                                  (chain-loader "/EFI/systemd/systemd-bootx64.efi"))))
                              (keyboard-layout the-keyboard-layout)))
