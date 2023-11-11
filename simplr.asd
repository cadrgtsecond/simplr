(in-package :asdf-user)

(defsystem "simplr"
  :description "A website to simplify your tech stack"
  :version "0.1.0"
  :author "Abhinav Krishna"
  :homepage "https://github.com/cadrgtsecond/simplr"

  :depends-on (mito clack ningle ten cmark iterate str)
  :components
  ((:module "src"
    :components
    ((:file "model")
     (:file "query")
     (:file "main")))))
