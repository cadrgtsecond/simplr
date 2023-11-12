(defpackage simplr.query
  (:use :cl :sxql)
  (:export get-alternatives))
(in-package simplr.query)

;;; Gods of Prolog, Save us
(defun get-alternatives (stack q)
  "Returns a query of the list of alternatives"
  (select ((:as :technology.name :alt)
           (:as :technology.desc :desc)
           (:as (:+ (:coalesce (:sum :strength.strength) 0) :initial_strength.strength) :score))
    (from :technology)
    (left-join :strength
                :on (:and (:= :strength.tech_name :alt)
                          (:in :strength.with stack)))
    (inner-join :platform
                :on (:= :platform.tech_name :alt))
    (inner-join :initial_strength
                :on (:= :initial_strength.tech_name :alt))

    (where (:in :platform.platform
             (select :platform
               (from :platform)
               (where (:= :tech_name q)))))
    (group-by :alt)
    (order-by (:desc :score))
    (limit 10)
    (having (:> :score 0))))

#+nil
(mito:retrieve-by-sql (get-alternatives '("react" "graphql") "react"))
