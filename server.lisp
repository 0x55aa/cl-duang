(in-package :duang)

(duang:get-logger server-logger)


(defun write-headers ()
  ;; 
  )


(defun write-body ()
  ;;
  )


(defun read-callback (socket data)
  ;; 
  (format t "data: ~a~%" data)
  (as:write-socket-data socket (format nil "HTTP/1.1 200 OK~C~CServer: SBCL-Dung/0.1~C~C~C~CHello World!" #\Return #\Linefeed #\Return #\Linefeed #\Return #\Linefeed)
                        :write-cb (lambda (socket)
                                    (as:close-socket socket))))


(defun event-callback (ev)
  ;;
  (format t "ev: ~a~%" ev))


(defun connect-callback (socket)
  ;;
  (format t "connect: ~a~%" socket))


(defun start-server (&optional (port 8000) (address "0.0.0.0"))
  ;; start server
  (format t "Starting server at ~a:~a~%Quit the server with CONTROL-C.~%" address port)
  (server-logger :info "~%starting~%")
  (as:with-event-loop ()
    (as:tcp-server address port
                   'read-callback
                   :event-cb 'event-callback
                   :connect-cb 'connect-callback)))
