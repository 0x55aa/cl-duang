(in-package :duang)


(defun time-to-string ()
  ;; get-universal-time
  (multiple-value-bind
    (second minute hour date month year day daylight-p zone)
    (get-decoded-time)
    (format nil "~d-~d-~d ~d:~d:~d(GMT~@d)" year month date hour minute second (- zone))))
