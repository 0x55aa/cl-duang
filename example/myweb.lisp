(require :duang)
(defpackage :myweb (:use :cl :duang))
(in-package :myweb)

(defparameter app (make-instance 'application :name "web" ))
(duang:start-app-server app)
