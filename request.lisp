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
   (uri :accessor uri)
   (headers :accessor headers :initform (make-hash-table))
   (path :accessor path)

   (arguments :accessor arguments :initform (make-hash-table))
   (query :accessor query)
   (query-arguments :accessor query-arguments :initform (make-hash-table))

   (body :accessor body)
   (body-arguments :accessor body-arguments :initform (make-hash-table))
   ;; remote-ip host
   ;; files cookies
   ))


(defmethod parse-header ((req request) data)
  ;;
  ;; TODO: exception
  (let* ((index (search (rn) data))
         (first-line (split-by-one-char (subseq data 0 index)))
         (other-lines (split-str (subseq data (+ index 2)) (rn))))
    ;; TODO: header len
    (setf (req-method req) (first first-line))
    (setf (uri req) (second first-line))
    (setf (version req) (third first-line))
    (let ((path-query (partition (uri req) #\?)))
      (setf (path req) (first path-query))
      (setf (query req) (second path-query))
      (maphash #'(lambda (k v)
                   (setf (gethash k (query-arguments req)) v)
                   (setf (gethash k (arguments req)) v))
               (query-parse (second path-query))))

    (server-logger :debug (format nil "Method: ~A" (req-method req)))
    (server-logger :debug (format nil "Uri ~A" (uri req)))
    (server-logger :debug (format nil "Version: ~A" (version req)))
    (server-logger :debug (format nil "Path: ~A" (path req)))
    (server-logger :debug (format nil "Query: ~A" (query req)))
    ;; other
    (mapcar #'(lambda (line)
                (server-logger :debug (format nil "Line: ~A" line))
                (let ((k-v (partition line #\:)))
                  (setf (gethash (first k-v) (headers req)) (trim-blank (second k-v)))))
            other-lines)
    ;; (maphash #'(lambda (k v) (format t "~A~A" k v)) (headers req))

    ;; cookie

    ))


(defun query-parse (data)
  ;; parse a=1&b=2
  (let ((r (make-hash-table)))
    (mapcar #'(lambda (x)
                (mapcar #'(lambda (y)
                            (let ((k-v (partition y #\=)))
                              ;; TODO: value unquote and parse
                              (setf (gethash (first k-v) r) (second k-v))))
                        (split-by-one-char x #\&)))
            (split-by-one-char data #\;))
    r))


(defmethod parse-body ((req request) data)
  ;; "application/x-www-form-urlencoded"
  ;; TODO: "multipart/form-data"
  (setf (body req) data)
  (maphash #'(lambda (k v)
               (setf (gethash k (body-arguments req)) v)
               (setf (gethash k (arguments req)) v))
           (query-parse data)))


(defmethod parse ((req request) data)
  ;;
  (multiple-value-bind (header-data body-data) (split-header-body data)
    (server-logger :debug header-data)
    (parse-header req header-data)

    (server-logger :debug body-data)
    (parse-body req body-data))
    ;; (maphash #'(lambda (k v) (format t "~A~A" k v)) (query-arguments req))
)
