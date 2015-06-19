(in-package :duang)


(defmacro get-read-callback (app)
  ;;
  `(lambda (socket data)
     (defparameter h (make-hash-table))
     (setf (gethash '|Server| h) "SBCL-Duang/0.1")
     (setf (gethash '|Content-Length| h) "11")
     (write-headers socket h 200 "OK")
     (defparameter body-data "Hello World")
     (write-body socket body-data)))


(defclass application ()
  ;; web app
  ;; name - web app name
  ;; handlers - (url-pattern handler name)
  ((name :initarg :name :initform (error "Must have an app name"))
   (handlers :initarg :handlers :initform nil)))


(defmethod start-app-server ((application application) &optional (address "0.0.0.0") (port 8000))
  ;;
  (start-server (get-read-callback application) port address))
