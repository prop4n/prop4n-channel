(define-module (prop4n packages tailscale)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system copy)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages base)
  #:use-module ((guix licenses) #:prefix license:)
  #:export (tailscale))

(define-public tailscale
  (package
    (name "tailscale")
    (version "1.90.8")
    (source (origin
              (method url-fetch)
              (uri (string-append
                    "https://pkgs.tailscale.com/stable/tailscale_"
                    version "_amd64.tgz"))
              (sha256
               (base32
                "0pqv2dgkqwlpnigsjgacp5j68db66a64a4h6y5gza3yc86y7qkwm"))))
    (build-system copy-build-system)
    (arguments
     '(#:install-plan
       '(("tailscale" "bin/")
         ("tailscaled" "bin/"))
       #:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'fix-permissions
           (lambda _
             (chmod "tailscale" #o755)
             (chmod "tailscaled" #o755))))))
    (native-inputs (list tar gzip))
    (home-page "https://tailscale.com")
    (synopsis "Mesh VPN built on WireGuard")
    (description "Tailscale creates a secure network between your servers,
computers, and cloud instances.")
    (license license:bsd-3)))
