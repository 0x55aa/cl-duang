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
           (svref +levels+ ,msg-level)
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
     (let ((msg-level-num (gensym)))
       `(let ((,msg-level-num ,(position msg-level +levels+)))
         (if ,msg-level-num
           (if (<= ,msg-level-num ,(position ,level +levels+))
             (write-log ,msg-level-num ,msg ,,output))
           (error "level must in ~A~%" +levels+))))))
