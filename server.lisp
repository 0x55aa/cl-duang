(in-package :duang)

(get-logger server-logger)


(defmacro write-socket-new-line (socket str &rest args)
  ;;
  `(as:write-socket-data socket (format nil (concatenate 'string ,str "~C~C")
                                        ,@args #\Return #\Linefeed)))


(defun write-headers (socket headers status-code status-text)
  "
  ;; write HTTP headers
  ;; socket - connection
  ;; headers - hash table
  "
  (write-socket-new-line socket "HTTP/1.1 ~A ~A"
                         status-code status-text)
  (maphash #'(lambda (k v)
               (write-socket-new-line socket "~A: ~A" k v))
           headers)
  (write-socket-new-line socket ""))


(defun write-body (socket data)
  ;;
  (as:write-socket-data socket data))


(defun event-callback (ev)
  ;;
  (format t "ev: ~a~%" ev))


(defun connect-callback (socket)
  ;;
  (format t "connect: ~a~%" socket))


(defun start-server (read-callback-func &optional (port 8000) (address "0.0.0.0"))
  ;; start server
  (format t "Starting server at ~a:~a~%Quit the server with CONTROL-C.~%" address port)
  (server-logger :info "starting server")
  (as:with-event-loop ()
    (as:tcp-server address port
                   read-callback-func
                   :event-cb 'event-callback
                   :connect-cb 'connect-callback)))
