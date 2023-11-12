(eval-when (:compile-toplevel :load-toplevel)
  (defpackage simplr.templates
    (:use :cl :ten))
  (in-package simplr.templates)
  (ten:compile-template #p"src/index.html" :simplr.templates))

(defpackage simplr
  (:use :cl :iter)
  (:local-nicknames (:model simplr.model)
                    (:query simplr.query)
                    (:templates simplr.templates)))
(in-package simplr)

(defvar *app* (make-instance 'ningle:app))

(setf (ningle:route *app* "/" :method :GET)
  (lambda (params)
    (declare (ignore params))
    `(200 () (,(templates:index.html)))))

(setf (ningle:route *app* "/query" :method :GET)
  (lambda (params)
    (let* ((asked (str:split " " (cdr (assoc "stack" params :test #'string=)) :omit-nulls t))
           (platform (iter (for (key . val) in params)
                           (declare (ignorable val))
                           (unless (string= key "stack")
                             (collect key)))))
    `(200 () (,(templates:search-results
                  (query:get-alternatives (append asked platform) asked)))))))

(setf (ningle:route *app* "/completion" :method :GET)
  (lambda (params)
    (let* ((stack (cdr (assoc "stack" params :test #'string=)))
           (qword (car (or
                         (last (str:split " " stack :omit-nulls t))
                         '("")))))
      `(200 () (,(templates:completions (query:get-completions qword)))))))

(defun start (&rest opts)
  (mito:connect-toplevel :sqlite3 :database-name #p"db.sqlite3")
  (dolist (tb model:*tables*)
    (mito:ensure-table-exists tb))
  (simplr.parse-md::add-markdown-tree (simplr.parse-md::load-markdown))

  (apply #'clack:clackup
    (lack:builder
      (:static :path "/static/"
               :root #p"static/")
      :backtrace
      *app*)
    opts))

#+nil
(progn
  (defvar *handle* nil)
  (when *handle* (clack:stop *handle*))
  (setf *handle* (start)))
