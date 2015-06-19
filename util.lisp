(in-package :duang)


(defun time-to-string ()
  ;; get-universal-time
  (multiple-value-bind
    (second minute hour date month year day daylight-p zone)
    (get-decoded-time)
    (format nil "~d-~d-~d ~d:~d:~d(GMT~@d)" year month date hour minute second (- zone))))


(defun to-ascii (data)
  "
  ;; Print data to an ASCII string byte by byte.
  "
  (apply #'concatenate 'string
         (loop for byte-code across data
               collect (format nil "~c" (code-char byte-code)))))
