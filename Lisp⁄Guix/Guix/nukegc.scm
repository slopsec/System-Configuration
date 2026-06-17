;;; guix gc --list-roots | sort | uniq  | grep guix-profile | cut -d/ -f6   | sort | uniq | while read user; do echo UPGRADING $user; sudo -u $user guix package -u ; done

(define-module (scripts NukingGC))
(use-modules (ice-9 regex)
             (ice-9 popen)
             (ice-9 rdelim)
             (ice-9 match)
             (srfi srfi-1)
             (guix store)
             (guix store roots)
             (srfi srfi-11)
             )
(define (categorize-path path)
  "Parse the given path into a (user category path) tuple."
  (cond
   ((string-match "/var/guix/profiles/per-user/([^/]+)/current-guix.*" path)
    => (lambda (m) (list (match:substring m 1) "current-guix" path)))
   ((string-match "/var/guix/profiles/per-user/([^/]+)/guix-profile.*" path)
    => (lambda (m) (list (match:substring m 1) "guix-profile" path)))
   ((string-match "/home/([^/]+)/.cache/guix/" path)
    => (lambda (m) (list (match:substring m 1) "cached" path)))
   ((string-match ".*/.cache/guix/" path)
    => (lambda (m) (list "root" "cached" path)))
   ((string-match "/home/([^/]+)/.*/profile-.*" path)
    => (lambda (m) (list (match:substring m 1) "custom" path)))
   ((string-match "/var/guix/profiles/system-.*" path)
    => (lambda (m) (list "root" "system" path)))
   ((string-match "/run/current-system" path)
    => (lambda (m) (list "root" "system" path)))
   ((string-match "/run/booted-system" path)
    => (lambda (m) (list "root" "system" path)))
   ((string-match "/var/guix/gcroots/bootcfg" path)
    => (lambda (m) (list "root" "system" path)))
   ((string-match "/var/guix/profiles" path)
    => (lambda (m) (list "root" "system" path)))
   (else (list "" "" path))))



(define (organize-roots)
  "Sorts the list of path triples by user, then by type, then by path."
  (delete-duplicates
   (sort (map categorize-path (gc-roots))
         (lambda (x y)
           (or (string<? (car x) (car y))
               (and (string=? (car x) (car y))
                    (or (string<? (cadr x) (cadr y))
                        (and (string=? (cadr x) (cadr y))
                             (string<? (caddr x) (caddr y))))))))))

(define (run-and-print command)
  (let ((process (apply open-pipe* OPEN_BOTH command)))
    (let loop ((line (read-line process)))
      (if (eof-object? line)  ; Check if line is the end-of-file object
          (close-pipe process)
          (begin
            (display line)
            (newline)
            (loop (read-line process)))))))

(define (store-size)
  (run-and-print '("du" "-s" "--block-size=1M" "/gnu/store")))

(define (nukegc)
  (for-each (lambda (triple) (format #t "~a~%" triple)) (organize-roots))
  ;; guix deploy, reboot => Aligns all the special profiles, makes sure the current generation is bootable
  (store-size)
  ;; Delete old system generations
  (run-and-print '("/run/current-system/profile/bin/guix" "system" "delete-generations"))
  ;; Delete cached profiles
  (for-each (lambda (triple)
              (match triple
                     ((_ "cached" dir) (begin
                                         (format #t "Deleting ~a~%" dir)
                                         (run-and-print `("rm" "-r" ,dir))))
                     (_ #f)))  ; Ignore non-cached entries
            (organize-roots))
  ;; Delete previous profiles generations
  (run-and-print '("/run/current-system/profile/bin/guix" "gc" "--delete-generations"))
  (store-size)
  ;; Update the default profiles
  (for-each (lambda (triple)
              (match triple
                     (("root" "guix-profile" dir) (begin
                                                    (format #t "Updating ~a~%" dir)
                                                    (run-and-print '("/run/current-system/profile/bin/guix" "package" "-u"))))
                     ((user "guix-profile" dir) (begin
                                                  (format #t "Updating ~a~%" dir)
                                                  (run-and-print `("sudo" "-i" "-u" ,user "/run/current-system/profile/bin/guix" "package" "-u"))))
                     (_ #f)))  ; Ignore others
            (organize-roots))
  (store-size)
  ;; Delete previous generations
  (run-and-print '("/run/current-system/profile/bin/guix" "gc" "--delete-generations"))
  (store-size)
  ;; Update the custom profiles
  (for-each (lambda (triple)
              (match triple
                     (("root" "custom" dir)
                      (begin
                        (format #t "Updating ~a~%" dir)
                        (run-and-print `("/run/current-system/profile/bin/guix" "package" ,(string-append "--profile=" dir) "-u"))))
                     ((user "custom" dir)
                      (begin
                        (format #t "Updating ~a~%" dir)
                        (run-and-print `("sudo" "-i" "-u" ,user "/run/current-system/profile/bin/guix" "package" ,(string-append "--profile=" dir) "-u"))))
                     (_ #f)))  ; Ignore others
            (organize-roots))
  (store-size)
  ;; Delete previous generations
  (run-and-print '("/run/current-system/profile/bin/guix" "gc" "--delete-generations"))
  (store-size)
  (for-each (lambda (triple) (format #t "~a~%" triple)) (organize-roots)))

(when (equal? (current-module) (resolve-module '(guile-user)))
    (nukegc))
