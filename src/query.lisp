(defpackage simplr.query
  (:use :cl :sxql)
  (:export get-alternatives get-completions)
  (:local-nicknames (:model simplr.model)))
(in-package simplr.query)

;;; Gods of Prolog, Save us
(defun select-alternatives (stack q)
  "Returns a query of the list of alternatives"
  (select ((:as :technology.name :alt)
           (:as :technology.desc :desc)
           (:as :technology.stylized :stylized)
           (:as (:+ (:coalesce (:sum :strength.strength) 0) :initial_strength.strength) :score))
    (from :technology)
    (left-join :strength
                :on (:and (:= :strength.tech_name :alt)
                          (:in :strength.with stack)))
    (inner-join :platform
                :on (:= :platform.tech_name :alt))
    (inner-join :initial_strength
                :on (:= :initial_strength.tech_name :alt))

    (where (:and (:in :platform.platform
                   (select :platform
                     (from :platform)
                     (where (:= :tech_name (string-downcase q)))))
                (:!= :alt (string-downcase q))))
    (group-by :alt)
    (order-by (:desc :score))
    (limit 10)
    (having (:> :score 0))))

(defun get-alternatives (stack query)
  ;; TODO: Avoid n query
  ;; Actually not THAT bad since we use Sqlite
  (mapcar (lambda (q)
            (cons q (mito:retrieve-by-sql
                      (select-alternatives stack q))))
           query))

#+nil
(mito:retrieve-by-sql (get-alternatives '("react" "graphql") "react"))

(defun get-completions (w)
  (mito:select-dao 'model:technology
    (where (:like :name (:concat (string-downcase w) "%")))
    (limit 10)))

#+nil
(get-completions "graph")
