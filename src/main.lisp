(eval-when (:compile-toplevel :load-toplevel)
  (defpackage simplr.templates
    (:use :cl :ten))
  (in-package simplr.templates)
  (ten:compile-template #p"src/index.html" :simplr.templates))

(defpackage simplr
  (:use :cl :iter)
  (:local-nicknames (:templates simplr.templates)
                    (:query simplr.query)))
(in-package simplr)

(defvar *app* (make-instance 'ningle:app))

(setf (ningle:route *app* "/" :method :GET)
  (lambda (params)
    (declare (ignore params))
    `(200 () (,(templates:index.html)))))

(setf (ningle:route *app* "/query" :method :GET)
  (lambda (params)
    (let* ((asked (str:split " " (cdr (assoc "stack" params :test #'string=)) :omit-nulls t))
           (query (iter (for (key . val) in params)
                        (declare (ignorable val))
                        (unless (string= key "stack")
                          (collect key))))
           ;; TODO: Avoid n+1 query
           ;; Actually not THAT bad since we use Sqlite
           (res (iter (for q in asked)
                      (collect (cons q (mito:retrieve-by-sql
                                         (query:get-alternatives (append asked query) q)))))))
    `(200 () (,(templates:search-results res))))))

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
