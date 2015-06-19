(in-package :duang)

(defun parse-request (app data)
  ;; return a request
  (make-instance 'request :app app))


(defclass request ()
  ;; a HTTP request
  ((app :initarg :app :initform (error "Must have an app"))
   (method uri path query headers body remote-ip host
    arguments query-arguments body-arguments files cookies)))
