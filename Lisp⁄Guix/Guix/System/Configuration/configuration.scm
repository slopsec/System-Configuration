;; This is an operating system configuration generated
;; by the graphical installer.
;;
;; Once installation is complete, you can learn and modify
;; this file to tweak the system configuration, and pass it
;; to the 'guix system reconfigure' command to effect your
;; changes.


;; Indicate which modules to import to access the variables
;; used in this configuration.
(use-modules (gnu) (gnu packages shells) (nongnu packages linux) (nongnu system linux-initrd) (Configuration pkgs) (Configuration hardware-configuration))

(operating-system
  (kernel linux)
  (initrd microcode-initrd)
  (firmware (list linux-firmware))
  (locale "en_GB.utf8")
  (timezone "Europe/London")
  (keyboard-layout the-keyboard-layout)
  (host-name "Linux")

  ;; The list of user accounts ('root' is implicit).
  (users (cons* (user-account
                  (name "saorsa")
                  (comment "Dylan")
                  (group "users")
                  (home-directory "/home/saorsa")
                  (supplementary-groups '("wheel" "netdev" "kvm" "libvirt" "audio" "video"))
                  (shell (file-append zsh "/bin/zsh")))
                %base-user-accounts))

  (packages system-packages)

  ;; Below is the list of system services.  To search for available
  ;; services, run 'guix system search KEYWORD' in a terminal.
  (services system-services)
  (bootloader system-bootloader)

  ;; The list of file systems that get "mounted".  The unique
  ;; file system identifiers there ("UUIDs") can be obtained
  ;; by running 'blkid' in a terminal.
  (swap-devices system-swap)
  (file-systems the-file-systems))
