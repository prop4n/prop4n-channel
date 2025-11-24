(define-module (prop4n packages kubens)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system copy)
  #:use-module (gnu packages base)
  #:use-module (gnu packages compression)
  #:use-module ((guix licenses) #:prefix license:))

(define-public kubens
  (package
    (name "kubens")
    (version "0.9.5")
    (source (origin
              (method url-fetch)
              (uri (string-append
                    "https://github.com/ahmetb/kubectx/releases/download/v"
                    version "/kubens_v" version "_linux_x86_64.tar.gz"))
              (sha256
               (base32
                "1ficf219wqlnp554373b8cc5scx7hkkx0pfjzbjzn8mpyv3skhdc"))))
    (build-system copy-build-system)
    (arguments
     '(#:install-plan
       '(("kubens" "bin/"))
       #:phases
       (modify-phases %standard-phases
         (add-after 'install 'make-executable
           (lambda* (#:key outputs #:allow-other-keys)
             (let ((bin (string-append (assoc-ref outputs "out") "/bin")))
               (chmod (string-append bin "/kubens") #o755)))))))
    (native-inputs (list tar gzip))
    (home-page "https://github.com/ahmetb/kubectx")
    (synopsis "Fast way to switch between Kubernetes namespaces")
    (description "kubens helps you switch between Kubernetes namespaces.")
    (license license:asl2.0)))

kubens
