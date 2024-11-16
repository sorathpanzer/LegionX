;; This is an operating system configuration generated
;; by the graphical installer.
;;
;; Once installation is complete, you can learn and modify
;; this file to tweak the system configuration, and pass it
;; to the 'guix system reconfigure' command to effect your
;; changes.


;; Indicate which modules to import to access the variables
;; used in this configuration.
;; (use-modules (gnu))

(use-modules (gnu)
             (guix)
             (gnu packages shells))

(use-service-modules desktop networking)

(operating-system
  (environment-variables
   (list
    (environment-variable
     "PATH"
     (string-append (getenv "HOME") "/.config/guix/current/bin/guix:"
                    (getenv "PATH")))))
  (locale "pt_PT.utf8")
  (timezone "Europe/Lisbon")
  (keyboard-layout (keyboard-layout "pt"))
  (host-name "PanzerX")
	
  ;;(groups (cons* (user-group (name "seat"))
;;		 %base-groups))

  ;; The list of user accounts ('root' is implicit).
  (users (cons* (user-account
                  (name "sorath")
                  (comment "Sorath")
                  (group "users")
                  (home-directory "/home/sorath")
                  (shell (file-append nushell "/bin/nu"))
                  (supplementary-groups '("wheel" "netdev" "audio" "video" "seat")))
                %base-user-accounts))

  ;; Packages installed system-wide.  Users can also install packages
  ;; under their own account: use 'guix search KEYWORD' to search
  ;; for packages and 'guix install PACKAGE' to install a package.
  (packages (append (specifications->packages (list 
	  "age" "bat" "bridge-utils" "btrfs-progs" 
	  "calibre" ;;"chezmoi"
	  "delta"
	  "elogind" "entr"
	  "fd" "ffmpeg" "ffmpegthumbnailer" "file" "fzf"
	  "glibc-locales"
	  "imagemagick" "imv" "kdenlive" "keepassxc" "kitty"
	  "light" "libmtp" "libreoffice" "libvirt" "lm-sensors"
	  "ntfs-3g" "nushell"
	  "oath-toolkit" "ovmf"
	  "pandoc" "poppler" "rust-adblock" "pulseaudio"
	  "password-store" "pass-otp"
	  "qrencode"
	  "ripgrep" "rofi"
	  "seatd" "skim" "spice" "swaybg" "swayfx"
	  "telegram-desktop" "tofi" "tree"
	  "udiskie" "usbutils" "unzip" 
	  "virt-manager"
	  "wl-clipboard" "wtype"
	  "xdg-user-dirs" "xdg-utils" "xdg-desktop-portal"
	  "yt-dlp"
	  "zip"
	  "rust" "rust-cargo" "rust-analyzer" "rust-clippy"
	  "ghcid" "cabal-install" "ghc-turtle"
	))
                    %base-packages))

  ;; Below is the list of system services.  To search for available
  ;; services, run 'guix system search KEYWORD' in a terminal.
  (services
   (append (list (service network-manager-service-type)
                 (service wpa-supplicant-service-type)
		             (service seatd-service-type)
                 (service ntp-service-type)
                 (service mingetty-service-type
                 (mingetty-configuration
                   (tty "tty3")   ; Enable autologin on tty3
                   (auto-login "sorath"))))
                 

           ;; This is the default list of services we
           ;; are appending to.
           %base-services))
  (bootloader (bootloader-configuration
                (bootloader grub-efi-bootloader)
                (targets (list "/boot/efi"))
                (keyboard-layout keyboard-layout)))
  (swap-devices (list (swap-space
                        (target (uuid
                                 "282cfd29-c616-449c-8622-ea346ac650b9")))))

  ;; (environment-variables
  ;; '(("XDG_RUNTIME_DIR" . ,(string-append "/tmp/" (getpw (getuid) "name") "-runtime-dir"))))

  ;; The list of file systems that get "mounted".  The unique
  ;; file system identifiers there ("UUIDs") can be obtained
  ;; by running 'blkid' in a terminal.
  (file-systems (cons* (file-system
                         (mount-point "/boot/efi")
                         (device (uuid "09C5-28ED"
                                       'fat32))
                         (type "vfat"))
                       (file-system
                         (mount-point "/")
                         (device (uuid
                                  "c38345d0-e691-42d5-be14-d18f8056e87d"
                                  'ext4))
                         (type "ext4")) %base-file-systems)))
