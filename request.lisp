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
   (headers :accessor headers :initform (make-hash-table))
   (body :accessor body)
   ;; remote-ip host
   ;; arguments query-arguments body-arguments files cookies
   ))


(defmethod parse-header ((req request) data)
  ;;
  ;; TODO: exception
  (let* ((index (search (rn) data))
         (first-line (split-by-one-char (subseq data 0 index)))
         (other-lines (split-str (subseq data (+ index 2)) (rn))))
    ;; TODO: header len
    (setf (req-method req) (first first-line))
    (setf (path req) (second first-line))
    (setf (version req) (third first-line))

    (server-logger :debug (format nil "Method: ~A" (req-method req)))
    (server-logger :debug (format nil "Path: ~A" (path req)))
    (server-logger :debug (format nil "Version: ~A" (version req)))
    ;; other
    (mapcar #'(lambda (line)
                (server-logger :debug (format nil "Line: ~A" line))
                (let* ((k-v (split-by-one-char line #\:)))
                  (setf (gethash (first k-v) (headers req)) (trim-blank (second k-v)))))
            other-lines)
    (maphash #'(lambda (k v) (format t "~A~A" k v)) (headers req))

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
