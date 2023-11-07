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
  (dolist (child (cmark::node-children node))
    (print-node child (1+ level))))

(defun load-markdown (&optional (path #p"data/ALTERNATIVES.md"))
  (with-open-file (s path :direction :input)
    (cmark:parse-stream s)))

;;; TODO: Replace with a real db
(defvar *db* '())

(defclass alternative ()
  ((name :initarg :name
         :accessor alternative-name)
   (opts :initarg :opts
         :accessor alternative-opts)
   (desc :initarg :desc
         :accessor alternative-desc)))

(defun add-alternative (&rest initargs &key name &allow-other-keys)
  "Adds a single node to the \"database\""
  (setf (getf *db* name) (apply #'make-instance 'alternative initargs)))

(defun node-text (node)
  "Gets the text value stored at a node. Quite useful"
  (if (typep node 'cmark:text-node)
    (cmark:node-literal node)
    (node-actual-literal (car (cmark:node-children node)))))

(defun parse-opts (s)
  (iter (for part in (str:split " " s :omit-nulls t))
        (for (key value) = (str:split ":" part))
        (collect (cons key value))))

(defun add-markdown-tree (tree)
  "Adds a whole tree of markdown to the \"database\""
  (iter (for parts on (cmark:node-children tree))
        (for curr = (car parts))
        (when (and (typep curr 'cmark:heading-node) (eql 2 (cmark:node-heading-level curr)))
          (add-alternative
            ;; FIXME: This is a HORRIBLE, HORRIBLE idea, interning symbols from outside sources
            ;; can cause memory leaks. However, we will replace "the database" with a real
            ;; database anyways so....
            :name (intern (node-text curr))
            :opts (parse-opts (node-text (cadr parts)))
            :desc (node-text (caddr parts))))))
#+nil
(add-markdown-tree (load-markdown))
