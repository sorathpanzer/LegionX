(define-module (config home home-config)
	       #:use-module (gnu)
	       #:use-module (gnu home)
	       #:use-module (gnu home services)
	       #:use-module (gnu home services shells)
	       #:use-module (gnu packages)
	       #:use-module (gnu packages version-control))

(home-environment
  (packages (specifications->packages (list
					"git"
					"kitty"
					"swayfx"
					"curl"))))

