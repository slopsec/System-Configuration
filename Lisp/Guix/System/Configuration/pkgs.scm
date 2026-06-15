(define-module (Configuration pkgs)
  #:use-module (gnu)
  #:use-module (gnu home)
  #:use-module (gnu home services)
  #:use-module (gnu home services shells)
  #:use-module (guix)
  #:use-module (guix gexp)
  #:use-module (gnu system shadow)
  #:use-module (gnu services)
  #:use-module (gnu services guix)
  #:use-module (gnu services nix)
  #:use-module (gnu services cups)
  #:use-module (gnu services desktop)
; #:use-module (gnu services kde)
  #:use-module (gnu services sddm)
  #:use-module (gnu services networking)
  #:use-module (gnu services spice)
  #:use-module (gnu services ssh)
  #:use-module (gnu services xorg)
  #:use-module (srfi srfi-1)
  #:export (the-keyboard-layout
            system-packages
            system-services
            home-packages
            home-services
            system-bootloader))

  ;; Defining the keyboard layout in use.
  (define the-keyboard-layout (keyboard-layout "gb"))

  ;; Packages installed system-wide.  Users can also install packages
  ;; under their own account: use 'guix search KEYWORD' to search
  ;; for packages and 'guix install PACKAGE' to install a package.
  (define system-packages (append (specifications->packages
                                    '("nss-certs"
                                      "iptables"
                                      "font-google-noto"
                                      "font-google-noto-emoji"
                                      "font-sarasa-gothic"
 ;                                     "font-meslo-lg"
;                                      "font-nerd-symbols"

                                      ;; Global Packages.
                                      "nix"
                                      "zsh"
                                      "zsh-completions"
                                      "zsh-autosuggestions"
                                      "zsh-syntax-highlighting"
                                      "wayland-protocols"
                                      "git"
                                      "jq"
                                      "unzip"
                                      "unrar-free"
                                      "kate"
                                      "ark"
                                      "zoxide"))
                                  %base-packages))

  (define home-packages
                                  (specifications->packages
                                  '("fastfetch"
                                    "libreoffice"
                                    "librewolf"
                                    "steam"
                                    "gnome-authenticator"
                                    "dolphin-emu"
                                    "ani-cli"
                                    "gnome-disk-utility"
                                    "lolcat")))

  (define home-services
    (list
    ;; example:
    ;; (service home-bash-service-type ...)
    ))

  ;; Below is the list of system services.  To search for available
  ;; services, run 'guix system search KEYWORD' in a terminal.
  (define system-services
   (cons*        (service plasma-desktop-service-type)

                 ;; To configure OpenSSH, pass an 'openssh-configuration'
                 ;; record as a second argument to 'service' below.
                 (service sddm-service-type)
                 (service nix-service-type)
               ; (service openssh-service-type
               ;  (openssh-configuration
               ;   (port-number 6967)
               ;   (permit-root-login #f)
               ;   (password-authentication? #t)
               ;   (public-key-authentication? #f)))
                 (service spice-vdagent-service-type)
               ; (service tor-service-type)
               ; (set-xorg-configuration
               ;  (xorg-configuration (keyboard-layout the-keyboard-layout)))

;           ;; Nested home configuration.
            (service guix-home-service-type
                      `(("saorsa"
                        ,(home-environment
                          (packages home-packages)
                          (services home-services)))))

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
                              (keyboard-layout the-keyboard-layout)))
