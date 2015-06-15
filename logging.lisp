(in-package :duang)

;; TODO:
;; format string
;; output
;; msg list

;; defconstant error
(defparameter +levels+ (vector :error :warning :info :debug))


(defmacro write-log (msg-level msg output)
  ;;
  `(format ,output "[~A][~A][~A] ~A~%" (get-universal-time)
           (bt:thread-name (bt:current-thread))
           ,msg-level
           ,msg))


(defmacro get-logger (name &key (level :debug) (output t))
  "
  ;; return log macro
  ;; name: log macro name
  ;; level: output level
  ;; output: default T, log write to *STANDARD-OUTPUT*;
  ;;         string, write to file.
  "
  `(defmacro ,name (&optional (msg-level :debug) (msg "nil"))
     (if (handler-case (<= (position msg-level +levels+) (position ,level +levels+))
           (TYPE-ERROR () (error "level must in ~A~%" +levels+)))
       `(write-log ,msg-level ,msg ,,output))))
