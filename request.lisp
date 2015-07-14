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
  ((app :accessor app :initarg :app :initform (error "Must have an app"))
   (req-method :accessor req-method)
   (version :accessor version)
   (path :accessor path)
   (uri :accessor uri)
   (query :accessor query)
   (headers :accessor headers)
   (body :accessor body)
   ;; remote-ip host
   ;; arguments query-arguments body-arguments files cookies
   ))


(defmethod parse-header ((req request) data)
  ;;
  ;; TODO: exception
  (let* ((index (search (format nil "~C~C" #\Return #\Linefeed)
                       data))
         (header-result (split-by-one-space (subseq data 0 index))))
    ;; TODO: header-result len
    (setf (req-method req) (first header-result))
    (setf (path req) (second header-result))
    (setf (version req) (third header-result))

    (server-logger :debug (format nil "method: ~A" (req-method req)))
    (server-logger :debug (format nil "path: ~A" (path req)))
    (server-logger :debug (format nil "version: ~A" (version req)))
    ;; (split-by-one-space (subseq data (+ index 2)))

    ))


(defmethod parse-body ((req request) data)
  ;;

  )


(defmethod parse ((req request) data)
  ;;
  (multiple-value-bind (header-data body-data) (split-header-body data)
  (server-logger :debug header-data)
  (parse-header req header-data)
  (server-logger :debug body-data)
  (parse-body req body-data)
  ))
