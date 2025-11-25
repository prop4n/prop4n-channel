(define-module (prop4n packages bun)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages elf)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages base)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages linux)
  #:use-module (nonguix build-system binary))

(define-public bun
  (package
    (name "bun")
    (version "1.1.38")
    (source (origin
              (method url-fetch)
              (uri (string-append
                    "https://github.com/oven-sh/bun/releases/download/"
                    "bun-v" version "/bun-linux-x64.zip"))
              (sha256
               (base32
                "0cirql5winlkvp3hac456gma6kgzcbniz1flrizrgm18gqssa7d6"))))
    (build-system binary-build-system)
    (arguments
     `(#:validate-runpath? #f
       #:strip-binaries? #f
       #:patchelf-plan
       `(("bun" ("libc" "gcc" "zlib" "openssl" "liburing")))
       #:install-plan
       `(("bun" "bin/"))))
    (inputs
     (list zlib
           glibc
           openssl
           liburing
           `(,gcc "lib")))
    (native-inputs
     (list unzip patchelf))
    (supported-systems '("x86_64-linux"))
    (home-page "https://bun.sh")
    (synopsis "Fast JavaScript runtime, bundler, and package manager")
    (description
     "Bun is an all-in-one JavaScript runtime and toolkit designed for speed,
complete with a bundler, test runner, and Node.js-compatible package manager.
This package uses the precompiled binary.")
    (license license:expat)))
