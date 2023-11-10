(defpackage simplr.query
  (:use :cl :sxql)
  (:export get-alternatives))
(in-package simplr.query)

;;; Gods of Prolog, Save us
(defun get-alternatives (stack q)
  (select ((:as :software.name :alt)
           (:as :software.desc :desc)
           (:as (:sum :strength.strength) :total_strength))
    (from :software)
    (inner-join (:as :software_strength :strength)
                :on (:and (:= :strength.software_name :alt)
                          (:in :strength.with stack)))
    (inner-join (:as :software_platform :platform)
                :on (:= :alt :platform.software_name))

    (where (:in :platform.platform
                (select :platform
                  (from :software_platform)
                  (where (:= :software_name q)))))
    (group-by :alt)
    (order-by (:desc :total_strength))
    (limit 10)))

#+nil
(mito:retrieve-by-sql (get-alternatives '("react" "graphql") "react"))
