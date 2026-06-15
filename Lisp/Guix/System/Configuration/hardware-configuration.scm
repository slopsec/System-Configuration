(define-module (Configuration hardware-configuration)
  #:use-module (gnu)
  #:use-module (guix)
  #:export (system-swap
            swap-arguments
            the-file-systems))

  ;; The list of file systems that get "mounted".  The unique
  ;; file system identifiers there ("UUIDs") can be obtained
  ;; by running 'blkid' in a terminal.
  (define the-file-systems (cons* (file-system
                                    (mount-point "/")
                                    (device (uuid
                                            "58e043e1-c58a-4d6d-9d7d-e41baf92dc7f"
                                            'btrfs))
                                    (type "btrfs")
                                    (options "compress=zstd,subvol=@guix/@"))
                                   (file-system
                                    (mount-point "/media/shared")
                                    (device (uuid
                                            "58e043e1-c58a-4d6d-9d7d-e41baf92dc7f"
                                            'btrfs))
                                    (type "btrfs")
                                    (options "compress=zstd,subvol=@shared"))
                                   (file-system
                                    (mount-point "/home")
                                    (device (uuid
                                            "58e043e1-c58a-4d6d-9d7d-e41baf92dc7f"
                                            'btrfs))
                                    (type "btrfs")
                                    (options "compress=zstd,subvol=@guix/@home"))
                                   (file-system
                                    (mount-point "/var")
                                    (device (uuid
                                            "58e043e1-c58a-4d6d-9d7d-e41baf92dc7f"
                                            'btrfs))
                                    (type "btrfs")
                                    (options "compress=zstd,subvol=@guix/@var"))
                                   (file-system
                                    (mount-point "/.snapshots")
                                    (device (uuid
                                            "58e043e1-c58a-4d6d-9d7d-e41baf92dc7f"
                                            'btrfs))
                                    (type "btrfs")
                                    (options "compress=zstd,subvol=@guix/@snapshots"))
                                   (file-system
                                    (mount-point "/swap")
                                    (device (uuid
                                            "58e043e1-c58a-4d6d-9d7d-e41baf92dc7f"
                                            'btrfs))
                                    (type "btrfs")
                                    (options "nodatacow,subvol=@guix/@swap"))
                                    (file-system
                                     (mount-point "/boot/efi")
                                     (device (uuid "2211-E5D1"
                                             'fat32))
                                     (type "vfat")) %base-file-systems))

  (define system-swap (list (swap-space
                              (target "/swap/swapfile"))))

  (define swap-arguments
    (cons* "resume=/dev/nvme0n1p2"   ;device that holds /swapfile
           "resume_offset=12640968"  ;offset of /swapfile on device
           %default-kernel-arguments))
