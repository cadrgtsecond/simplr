(eval-when (:compile-toplevel :load-toplevel)
  (defpackage simplr.templates
    (:use :cl :ten))
  (in-package simplr.templates)
  (ten:compile-template #p"src/index.html" :simplr.templates))

(defpackage simplr
  (:use :cl)
  (:local-nicknames (:templates simplr.templates)))
(in-package simplr)

(defvar *app* (make-instance 'ningle:app))

(setf (ningle:route *app* "/" :method :GET)
  (lambda (params)
    (declare (ignore params))
    `(200 () (,(templates:index.html)))))

(defun start ()
  (clack:clackup
    (lack:builder
      (:static :path "/static/"
               :root #p"static/")
      :backtrace
      *app*)))

#+nil
(progn
  (defvar *handle* nil)
  (when *handle* (clack:stop *handle*))
  (setf *handle* (start)))
