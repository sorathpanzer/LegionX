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

(define-module (base-system)
  #:use-module (gnu)
  #:use-module (guix)
  #:export (base-system))

(use-service-modules desktop networking)

(operating-system
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
                  (supplementary-groups '("wheel" "netdev" "audio" "video" "seat")))
                %base-user-accounts))

  ;; Packages installed system-wide.  Users can also install packages
  ;; under their own account: use 'guix search KEYWORD' to search
  ;; for packages and 'guix install PACKAGE' to install a package.
  (packages (append (specifications->packages (list 

	))
                    %base-packages))

  ;; Below is the list of system services.  To search for available
  ;; services, run 'guix system search KEYWORD' in a terminal.
  (services
   (append (list (service network-manager-service-type)
                 (service wpa-supplicant-service-type)
		 (service seatd-service-type)
                 (service ntp-service-type))

           ;; This is the default list of services we
           ;; are appending to.
           %base-services))
  (bootloader (bootloader-configuration
                (bootloader grub-efi-bootloader)
                (targets (list "/boot/efi"))
                (keyboard-layout keyboard-layout)))
  (swap-devices (list (swap-space
                        (target (uuid
                                 "9e157485-9e34-4ff5-8251-d9e97faf6bff")))))

  ;; (environment-variables
  ;; '(("XDG_RUNTIME_DIR" . ,(string-append "/tmp/" (getpw (getuid) "name") "-runtime-dir"))))

  ;; The list of file systems that get "mounted".  The unique
  ;; file system identifiers there ("UUIDs") can be obtained
  ;; by running 'blkid' in a terminal.
  (file-systems (cons* (file-system
                         (mount-point "/boot/efi")
                         (device (uuid "C8A6-DE12"
                                       'fat32))
                         (type "vfat"))
                       (file-system
                         (mount-point "/")
                         (device (uuid
                                  "eb3ab329-cae1-40cd-beae-7f89d95887c2"
                                  'ext4))
                         (type "ext4")) %base-file-systems)))
