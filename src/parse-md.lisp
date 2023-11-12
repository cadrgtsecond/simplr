(defpackage simplr.parse-md
  (:use :cl :iter)
  (:export load-markdown add-markdown-tree)
  (:local-nicknames (:model simplr.model)))
(in-package simplr.parse-md)

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
  "Load a markdown file as a tree"
  (with-open-file (s path :direction :input)
    (cmark:parse-stream s)))

(defun parse-technology-body (desc)
  (multiple-value-bind (start end) (ppcre:scan "\\s*:\\s*" desc)
    (values
      (subseq desc 0 start)
      (subseq desc end))))
#+nil
(parse-technology-body "HTMX : A hypermedia ....")

(defun add-technology (&key name body opts)
  "Adds a single technology to the database"
  ;; TODO: Mixing of different abstraction levels...
  (dbi:execute (dbi:prepare mito:*connection* "begin transaction"))

  (handler-bind ((t (lambda (e)
                      (declare (ignore e))
                      (dbi:execute (dbi:prepare mito:*connection* "rollback transaction")))))
    (iter (with id =
            (mito:create-dao 'model:technology
                             :name (string-downcase name)
                             :stylized name
                             :desc body))

          (for (key . value) in opts)
          (cond
            ((string= value "only")
              (mito:create-dao 'model:platform
                :tech id
                :platform key))
            ((string= key "self")
              (mito:create-dao 'model:initial-strength
                :tech id
                :strength (parse-integer value)))
            (t
              (mito:create-dao 'model:strength
                :tech id
                :with key
                :strength (parse-integer value)))))
    (dbi:execute (dbi:prepare mito:*connection* "commit transaction"))))

(defun node-text (node)
  "Gets the text value stored at a node. Quite useful"
  (if (typep node 'cmark:text-node)
    (cmark:node-literal node)
    (node-text (car (cmark:node-children node)))))

(defun parse-opts (s)
  "Parse options of the form `key1:val1 key2:val2` as `((\"key1\" . \"val1\") (\"key2\" . \"val2\"))`"
  (iter (for part in (str:split " " s :omit-nulls t))
        (for (key value) = (str:split ":" part))
        (collect (cons key value))))

(defun add-markdown-tree (tree)
  "Adds a whole tree of markdown to the database"
  (iter (for parts on (cmark:node-children tree))
        (for curr = (first parts))
        (when (and (typep curr 'cmark:heading-node) (eql 2 (cmark:node-heading-level curr)))
          (add-technology
              :name (node-text curr)
              :opts (parse-opts (node-text (second parts)))
              :body (node-text (third parts))))))
#+nil
(add-markdown-tree (load-markdown))
