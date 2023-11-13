(eval-when (:compile-toplevel :load-toplevel)
  (defpackage simplr.templates
    (:use :cl :ten))
  (in-package simplr.templates)
  (ten:compile-template #p"src/index.html" :simplr.templates))

(defpackage simplr
  (:use :cl :iter)
  (:local-nicknames (:model simplr.model)
                    (:query simplr.query)
                    (:templates simplr.templates)
                    (:parse-md simplr.parse-md)))
(in-package simplr)

(defvar *app* (make-instance 'ningle:app))

(setf (ningle:route *app* "/" :method :GET)
  (lambda (params)
    (declare (ignore params))
    `(200 () (,(templates:index.html)))))

(defparameter *delimiter-regex* "[\\W,;]+")

(defun split-words (query)
  "Splits a query into multiple words.
e.g \"react express,  node\" => (\"react\" \"express\" \"node\")"
  (ppcre:split *delimiter-regex* query))

(setf (ningle:route *app* "/query" :method :GET)
  (lambda (params)
    (let* ((asked (split-words (cdr (assoc "stack" params :test #'string=))))
           (platform (iter (for (key . val) in params)
                           (declare (ignorable val))
                           (unless (string= key "stack")
                             (collect key)))))
    `(200 () (,(templates:search-results
                  (query:get-alternatives (append asked platform) asked)))))))

(setf (ningle:route *app* "/completion" :method :GET)
  (lambda (params)
    (let ((split (mapcar #'nreverse
                   (ppcre:split "(?=[\\W;,])"
                             (nreverse (cdr (assoc "stack" params :test #'string=)))
                             :limit 2))))
      (destructuring-bind (qword inputrest)
           (if (eq (length split) 2)
             split
             `(,@split ""))
        `(200 () (,(templates:completions inputrest (query:get-completions qword))))))))

(defun start-db ()
  (mito:connect-toplevel :sqlite3 :database-name #p"db.sqlite3")
  (dolist (tb model:*tables*)
    (mito:ensure-table-exists tb))
  (parse-md:add-markdown-tree (parse-md:load-markdown)))

(defun start (&rest opts)
  (start-db)

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
