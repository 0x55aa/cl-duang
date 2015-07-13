(in-package :duang)

(defun parse-request (app data)
  ;; return a request
  (let ((req (make-instance 'request :app app))
        (data-str (to-ascii data)))
    (server-logger :debug data-str)
    (parse req data-str)))

(defun split-header-body (data)
  ;;
  ;; TODO: exception
  (let ((index (search (format nil "~C~C~C~C" #\Return #\Linefeed #\Return #\Linefeed)
                       data)))
    (values (subseq data 0 index) (subseq data (+ index 4)))))


(defclass request ()
  ;; a HTTP request
  ((app :initarg :app :initform (error "Must have an app"))
    method uri path query headers body remote-ip host
    arguments query-arguments body-arguments files cookies
   ))


(defmethod parse ((request request) data)
  ;;
  (multiple-value-bind (header-data body-data) (split-header-body data)
  (server-logger :debug header-data)
  (server-logger :debug body-data)
  ))
