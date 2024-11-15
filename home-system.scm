(define-module (home-system)
	       #:use-module (gnu)
	       #:use-module (gnu home)
	       #:use-module (gnu home services)
	       #:use-module (gnu home services shells)
	       #:use-module (gnu packages)
	       #:use-module (gnu packages version-control))

(home-environment
  (packages (specifications->packages (list
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
	"ghcid" "cabal-install" "ghc-turtle" ))))

