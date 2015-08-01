(in-package :duang)


(defun time-to-string ()
  ;; get-universal-time
  (multiple-value-bind
    (second minute hour date month year day daylight-p zone)
    (get-decoded-time)
    (format nil "~d-~d-~d ~d:~d:~d(GMT~@d)" year month date hour minute second (- zone))))


(defun to-ascii (data)
  "
  ;; Print data to an ASCII string byte by byte.
  "
  (apply #'concatenate 'string
         (loop for byte-code across data
               collect (format nil "~c" (code-char byte-code)))))


(defun split-by-one-char (string &optional (separator #\Space))
  "
  ;; split string
  "
  (loop for i = 0 then (1+ j)
        as j = (position separator string :start i)
        collect (subseq string i j)
        while j))

(defun split-str (string &optional (separator " "))
  "
  ;; split string
  "
  (loop for i = 0 then (+ j (length separator))
        as j = (search separator string :start2 i)
        collect (subseq string i j)
        while j))

(defun trim-blank (string)
  "
  "
  (string-trim
    '(#\Space #\Newline #\Backspace #\Tab #\Linefeed #\Page #\Return #\Rubout)
    string))



(defmacro rn ()
  "
  ;; return string \r\n
  "
  `(format nil "~C~C" #\Return #\Linefeed))
