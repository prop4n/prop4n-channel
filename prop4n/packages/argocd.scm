(define-module (prop4n packages argocd)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix build-system copy)
  #:use-module (gnu packages base)
  #:use-module ((guix licenses) #:prefix license:))

(define-public argocd
  (package
    (name "argocd")
    (version "3.2.0")
    (source (origin
              (method url-fetch)
              (uri (string-append
                    "https://github.com/argoproj/argo-cd/releases/download/v"
                    version "/argocd-linux-amd64"))
              (sha256
               (base32
                "0l9000v1c532yfmirk70cpvsdwnjjhwgxm0k14d1x7f5xmxwjvmp"))))
    (build-system copy-build-system)
    (arguments
     '(#:install-plan
       '(("argocd-linux-amd64" "bin/argocd"))
       #:phases
       (modify-phases %standard-phases
         (add-after 'install 'make-executable
           (lambda* (#:key outputs #:allow-other-keys)
             (chmod (string-append (assoc-ref outputs "out") "/bin/argocd") #o755))))))
    (home-page "https://argo-cd.readthedocs.io/")
    (synopsis "Declarative GitOps CD for Kubernetes")
    (description "Argo CD is a declarative, GitOps continuous delivery tool for Kubernetes.")
    (supported-systems '("x86_64-linux"))
    (license license:asl2.0)))

argocd