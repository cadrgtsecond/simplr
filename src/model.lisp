(defpackage simplr.model
  (:use :cl :iterate)
  (:export *tables*
           technology
           strength
           initial-strength
           platform))
(in-package :simplr.model)
#+nil
(mito:connect-toplevel :sqlite3 :database-name #p"db.sqlite3")

(defvar *tables* '(technology strength initial-strength platform))
(mito:deftable technology ()
  ((name :col-type (:varchar 64)
         :primary-key t)
   (stylized :col-type (:varchar 64))
   (desc :col-type :text))
(:documentation "Table for technology and descriptions"))

(mito:deftable strength ()
  ((tech :col-type technology)
   (with :col-type (:varchar 64))
   (strength :col-type :integer))
(:primary-key tech with)
(:documentation "Table for the strengths of a technology with other technologies"))

(mito:deftable initial-strength ()
  ((tech :col-type technology
         :primary-key t)
   (strength :col-type :integer))
(:documentation "Table for storing initial(`self`) scores"))

(mito:deftable platform ()
  ((tech :col-type technology)
   (platform :col-type (:varchar 64)))
(:primary-key tech platform)
(:documentation "Table for the platforms of a technology"))

#+nil
(dolist (tb *tables*)
  (mito:ensure-table-exists tb))

