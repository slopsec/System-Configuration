(define-module (Configuration hardware-configuration)
  #:use-module (gnu)
  #:use-module (guix)
  #:export (system-swap swap-arguments the-file-systems))

(define system-swap
  (list
   (swap-space
    (target
     (uuid "f46bf722-109e-4d74-b64f-0a7c8c1477a1")))))

;; The list of file systems that get "mounted".  The unique
;; file system identifiers there ("UUIDs") can be obtained
;; by running 'blkid' in a terminal.
(define the-file-systems
  (cons* (file-system
           (mount-point "/")
           (device (uuid "c28531f4-8246-4f9b-bab1-05ec16fccf96"
                         'btrfs))
           (type "btrfs")
           (options "compress=zstd,subvol=@guix/@"))
         (file-system
           (mount-point "/media/shared")
           (device (uuid "c28531f4-8246-4f9b-bab1-05ec16fccf96"
                         'btrfs))
           (type "btrfs")
           (options "compress=zstd,subvol=@shared"))
         (file-system
           (mount-point "/home")
           (device (uuid "c28531f4-8246-4f9b-bab1-05ec16fccf96"
                         'btrfs))
           (type "btrfs")
           (options "compress=zstd,subvol=@guix/@home"))
         (file-system
           (mount-point "/var")
           (device (uuid "c28531f4-8246-4f9b-bab1-05ec16fccf96"
                         'btrfs))
           (type "btrfs")
           (options "compress=zstd,subvol=@guix/@var"))
         (file-system
           (mount-point "/.snapshots")
           (device (uuid "c28531f4-8246-4f9b-bab1-05ec16fccf96"
                         'btrfs))
           (type "btrfs")
           (options "compress=zstd,subvol=@guix/@snapshots"))
         (file-system
           (mount-point "/swap")
           (device (uuid "c28531f4-8246-4f9b-bab1-05ec16fccf96"
                         'btrfs))
           (type "btrfs")
           (options "nodatacow,compress=no,subvol=@guix/@swap"))
         (file-system
           (mount-point "/boot/efi")
           (device (uuid "246C-4059"
                         'fat32))
           (type "vfat"))
         %base-file-systems))
