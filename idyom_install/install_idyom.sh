#!/bin/sh

set -e

IDYOM_VERSION="1.7.1"


cd "$HOME"
mkdir -p idyom/ idyom/db/ idyom/data/cache/ idyom/data/models/ idyom/data/resampling/ quicklisp/

cd quicklisp && curl -O https://beta.quicklisp.org/quicklisp.lisp  # && sbcl --load quicklisp.lisp --eval '(quicklisp-quickstart:install)' --eval '(ql:add-to-init-file)' --eval '(ql:quickload "quicklisp-slime-helper")' --eval '(quit)' 

INSTAL_SCRIPT='(load (merge-pathnames "quicklisp/quicklisp.lisp" (user-homedir-pathname)))
(quicklisp-quickstart:install :path (merge-pathnames "quicklisp/" (user-homedir-pathname)))
(ql-util:without-prompting  (ql:add-to-init-file))
(ql:quickload "quicklisp-slime-helper")
(SB-EXT:EXIT)'
echo "$INSTAL_SCRIPT" > sbcl_instal.lisp
sbcl --non-interactive  --load sbcl_instal.lisp

# Define the content to be written
content="(load (expand-file-name \"~/quicklisp/slime-helper.el\"))
;; Replace \"sbcl\" with the path to your implementation
(setq inferior-lisp-program \"sbcl\")"

# Write the content to the ~/.emacs file
echo "$content" > ~/.emacs


IDYOM_ROOT_PATH="$HOME/idyom/"
IDYOM_DB_PATH="$HOME/idyom/db/database.sqlite"
echo ";;; Load CLSQL by default" >> ~/.sbclrc
echo "(ql:quickload \"clsql\")" >> ~/.sbclrc
echo ";;; IDyOM" >> ~/.sbclrc
echo "(defun start-idyom ()
   (defvar *idyom-root* \"$IDYOM_ROOT_PATH\")
   (defvar *idyom-message-detail-level* 1)
   (ql:quickload \"idyom\")
   (clsql:connect '(\"$IDYOM_DB_PATH\") :if-exists :old :database-type :sqlite3))" >> ~/.sbclrc

cd "$HOME"
mkdir -p quicklisp/local-projects/ && curl -L https://github.com/mtpearce/idyom/archive/refs/tags/v${IDYOM_VERSION}.tar.gz > idyom.tar.gz && tar -xzf idyom.tar.gz -C quicklisp/local-projects/ && rm idyom.tar.gz

sbcl --eval '(start-idyom)' --eval '(idyom-db:initialise-database)' --eval '(SB-EXT:EXIT)'