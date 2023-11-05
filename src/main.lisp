(defpackage simplr
  (:use :cl))
(in-package :simplr)

(defvar *app* (make-instance 'ningle:app))

(setf (ningle:route *app* "/" :method :GET)
  (lambda (params)
    (declare (ignore params))
    '(200 () ())))

(defun start ()
  (clack:clackup
    (lack:builder
      :backtrace
      *app*)))

#+nil
(progn
  (defvar *handle* nil)
  (when *handle* (clack:stop *handle*))
  (setf *handle* (start)))
