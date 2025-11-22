(define-module (prop4n services tailscale)
  #:use-module (gnu services)
  #:use-module (gnu services shepherd)
  #:use-module (guix gexp)
  #:use-module (guix records)
  #:use-module (prop4n packages tailscale)  ; Importe ton package
  #:export (tailscale-configuration
            tailscale-service-type))

;; Configuration du service
(define-record-type* <tailscale-configuration>
  tailscale-configuration make-tailscale-configuration
  tailscale-configuration?
  (tailscale tailscale-configuration-package
             (default tailscale))  ; Utilise le package importé
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
