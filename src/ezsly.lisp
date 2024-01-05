(in-package :ezsly)

(defmacro dp (pkg)
  "Set the package being developed."
  (defparameter *dev-package* pkg)
  `(rp)
  (in-package :ezsly))

(defmacro rp ()
  "Reload the package."
  (format t "Loading package: ~A~%" *dev-package*)
  `(ql:quickload ,*dev-package*))
