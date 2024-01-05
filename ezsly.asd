(in-package :asdf-user)

(defsystem "ezsly"
	   :author "Ambery Rabbit <amberyrabbit@airmail.cc>"
	   :version "1"
	   :description "Simple macros and functions to automate various operations when developing in CL with Sly."
	   :homepage ""
	   :bug-tracker ""
	   :source-control (:git "")
	   
	   ;; Dependencies.
	   :depends-on ()
	   
	   ;; Project stucture.
	   :serial t
	   :components ((:module "src"
				 :serial t
				 :components ((:file "packages")
					      (:file "ezsly")))))
