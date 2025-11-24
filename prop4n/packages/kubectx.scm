(define-module (prop4n packages kubectx)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system copy)
  #:use-module (gnu packages base)
  #:use-module (gnu packages compression)
  #:use-module ((guix licenses) #:prefix license:))

(define-public kubectx
  (package
    (name "kubectx")
    (version "0.9.5")
    (source (origin
              (method url-fetch)
              (uri (string-append
                    "https://github.com/ahmetb/kubectx/releases/download/v"
                    version "/kubectx_v" version "_linux_x86_64.tar.gz"))
              (sha256
               (base32
                "0j06sq6lx0nk6sckrxm308gm2wkiklvp708fvnmqk7z74gypy952"))))
    (build-system copy-build-system)
    (arguments
     '(#:install-plan
       '(("kubectx" "bin/"))
       #:phases
       (modify-phases %standard-phases
         (add-after 'install 'make-executable
           (lambda* (#:key outputs #:allow-other-keys)
             (let ((bin (string-append (assoc-ref outputs "out") "/bin")))
               (chmod (string-append bin "/kubectx") #o755)))))))
    (native-inputs (list tar gzip))
    (home-page "https://github.com/ahmetb/kubectx")
    (synopsis "Fast way to switch between Kubernetes clusters")
    (description "kubectx helps you switch between Kubernetes clusters.")
    (license license:asl2.0)))

kubectx
