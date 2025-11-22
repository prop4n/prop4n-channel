(define-module (prop4n services tailscale)
  #:use-module (gnu services)
  #:use-module (gnu services shepherd)
  #:use-module (gnu packages)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system copy)
  #:use-module (guix records)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages base)
  #:use-module ((guix licenses) #:prefix license:)
  #:export (tailscale
            tailscale-service-type))

;; Package tailscale
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

;; Configuration du service
(define-record-type* <tailscale-configuration>
  tailscale-configuration make-tailscale-configuration
  tailscale-configuration?
  (tailscale tailscale-configuration-package
             (default tailscale))
  (log-file tailscale-configuration-log-file
            (default "/var/log/tailscaled.log")))

;; Service Shepherd
(define (tailscale-shepherd-service config)
  (list (shepherd-service
         (documentation "Tailscale VPN daemon")
         (provision '(tailscaled))
         (requirement '(networking))
         (start #~(make-forkexec-constructor
                   (list #$(file-append (tailscale-configuration-package config)
                                       "/bin/tailscaled"))
                   #:log-file #$(tailscale-configuration-log-file config)))
         (stop #~(make-kill-destructor)))))

;; Définition du service type
(define-public tailscale-service-type
  (service-type
   (name 'tailscale)
   (description "Run the Tailscale VPN daemon.")
   (extensions
    (list (service-extension shepherd-root-service-type
                             tailscale-shepherd-service)
          (service-extension profile-service-type
                             (lambda (config)
                               (list (tailscale-configuration-package config))))))
   (default-value (tailscale-configuration))))
