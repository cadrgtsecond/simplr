(defpackage simplr.model
  (:use :cl :iterate))
(in-package :simplr.model)
#+nil
(mito:connect-toplevel :sqlite3 :database-name #p"db.sqlite3")

(mito:deftable software ()
  ((name :col-type (:varchar 64)
         :primary-key t)
   (desc :col-type :text))
(:documentation "Table for software and descriptions"))

(mito:deftable strength ()
  ((software :col-type software)
   (with :col-type (:varchar 64))
   (strength :col-type :integer))
(:primary-key software with)
(:documentation "Table for the strengths of a technology with other technologies"))

(mito:deftable initial-strength ()
  ((software :col-type software
             :primary-key t)
   (strength :col-type :integer))
(:documentation "Table for storing initial(`self`) scores"))

(mito:deftable platform ()
  ((software :col-type software)
   (platform :col-type (:varchar 64)))
(:primary-key software platform)
(:documentation "Table for the platforms of a technology"))

#+nil
(progn
  (mito:ensure-table-exists 'software)
  (mito:ensure-table-exists 'strength)
  (mito:ensure-table-exists 'initial-strength)
  (mito:ensure-table-exists 'platform))

(defun add-software (&key name desc opts)
  "Adds a single technology to the database"
  ;; TODO: Mixing of different abstraction levels...
  (dbi:execute (dbi:prepare mito:*connection* "begin transaction"))

