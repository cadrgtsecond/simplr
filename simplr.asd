(in-package :asdf-user)

(defsystem "simplr"
  :description "A website to simplify your tech stack"
  :version "0.0.1"
  :author "Abhinav Krishna"
  :homepage "https://github.com/cadrgtsecond/simplr"

  :depends-on (mito clack ningle ten)
  :components
  ((:module "src"
    :components
    ((:file "main")))))
