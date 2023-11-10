(defpackage simplr.model
  (:use :cl :iterate))
(in-package :simplr.model)

;;; Taken from the docs for cl-cmark
(defun print-node (node &optional (level 0))
  "Recursively print each node and its children at progressively deeper
  levels. Useful for debugging"
  (format t "~&~A~A"
          (make-string (* 2 level) :initial-element #\Space)
          (class-name (class-of node)))
  (dolist (child (cmark:node-children node))
    (print-node child (1+ level))))

(defun load-markdown (&optional (path #p"data/ALTERNATIVES.md"))
  (with-open-file (s path :direction :input)
    (cmark:parse-stream s)))

#+nil
(mito:connect-toplevel :sqlite3 :database-name #p"db.sqlite3")

(mito:deftable software ()
  ((name :col-type (:varchar 64)
         :primary-key t)
   (desc :col-type :text)))

(mito:deftable software-strength ()
  ((software :col-type software)
   (with :col-type (:varchar 64))
   (strength :col-type :integer))
(:primary-key software with))

(mito:deftable software-platform ()
  ((software :col-type software)
   (platform :col-type (:varchar 64)))
(:primary-key software platform))

(defun add-software (&key name desc opts)
  "Adds a single technology to the database"
  (dbi:execute (dbi:prepare mito:*connection* "begin transaction"))
  (handler-bind ((t (lambda (e)
                      (format t "~a" e)
                      (dbi:execute (dbi:prepare mito:*connection* "rollback transaction")))))

    (iter (with id = (mito:create-dao 'software :name name :desc desc))

          (for (key . value) in opts)
          (if (string= value "only")
            (mito:create-dao 'software-platform
              :software id
              :platform key)

            (mito:create-dao 'software-strength
              :software id
              :with key
              :strength (parse-integer value))))
    (dbi:execute (dbi:prepare mito:*connection* "commit transaction"))))

(defun node-text (node)
  "Gets the text value stored at a node. Quite useful"
  (if (typep node 'cmark:text-node)
    (cmark:node-literal node)
    (node-text (car (cmark:node-children node)))))

(defun parse-opts (s)
  (iter (for part in (str:split " " s :omit-nulls t))
        (for (key value) = (str:split ":" part))
        (collect (cons key value))))

(defun add-markdown-tree (tree)
  "Adds a whole tree of markdown to the database"
  (iter (for parts on (cmark:node-children tree))
        (for curr = (first parts))
        (when (and (typep curr 'cmark:heading-node) (eql 2 (cmark:node-heading-level curr)))
          (add-software
              :name (node-text curr)
              :opts (parse-opts (node-text (second parts)))
              :desc (node-text (third parts))))))
#+nil
(add-markdown-tree (load-markdown))
