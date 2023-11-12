(defpackage simplr.query
  (:use :cl :sxql)
  (:export get-alternatives))
(in-package simplr.query)

;;; Gods of Prolog, Save us
(defun get-alternatives (stack q)
  "Returns a query of the list of alternatives"
  (select ((:as :software.name :alt)
           (:as :software.desc :desc)
           (:as (:+ (:coalesce (:sum :strength.strength) 0) :initial_strength.strength) :score))
    (from :software)
    (left-join :strength
                :on (:and (:= :strength.software_name :alt)
                          (:in :strength.with stack)))
    (inner-join :platform
                :on (:= :platform.software_name :alt))
    (inner-join :initial_strength
                :on (:= :initial_strength.software_name :alt))

    (where (:in :platform.platform
             (select :platform
               (from :platform)
               (where (:= :software_name q)))))
    (group-by :alt)
    (order-by (:desc :score))
    (limit 10)
    (having (:> :score 0))))

#+nil
(mito:retrieve-by-sql (get-alternatives '("react" "graphql") "react"))
