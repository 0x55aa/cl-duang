(in-package :asdf-user)

(asdf:defsystem duang
  :description "A simple Web Framework."
  :author "0x55aa <admin@0x55aa.com>"
  :license "BSD"
  :version "0.0.1"
  :depends-on (#:cl-async
               #:blackbird)
  :components ((:file "package")
               (:file "util")
               (:file "logging")

               (:file "cookies")

               (:file "server")
               (:file "request")
               (:file "web")))
