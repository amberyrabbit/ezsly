LISP ?= sbcl
EMACS_PKG_INSTALL='(progn \
	(package-initialize) \
	(package-refresh-contents) \
	(package-install-file "./ezsly.el"))'

install: quicklisp emacs

quicklisp:
	$(LISP)	--non-interactive \
		--load ezsly.asd \
		--eval '(ql:quickload :ezsly)'

emacs:
	emacs --batch --eval $(EMACS_PKG_INSTALL)
	printf "\n(require 'ezsly)" >> ~/.emacs
