#!/bin/sh


SCRIPTPATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
USR_HOME_PATH=$HOME



echo ";;; Load CLSQL by default" > ${SCRIPTPATH}/install_pt3.lisp
echo "(ql:quickload \"clsql\")" >> ${SCRIPTPATH}/install_pt3.lisp

IDYOM_ROOT_PATH="$USR_HOME_PATH/idyom/"
IDYOM_DB_PATH="$USR_HOME_PATH/idyom/db/database.sqlite"

echo ";;; IDyOM" >> ${SCRIPTPATH}/install_pt3.lisp
echo "(defun start-idyom ()
   (defvar *idyom-root* \"$IDYOM_ROOT_PATH\")
   (ql:quickload \"idyom\")
   (clsql:connect '(\"$IDYOM_DB_PATH\") :if-exists :old :database-type :sqlite3))" >> ${SCRIPTPATH}/install_pt3.lisp


INSTALL3_PATH=${SCRIPTPATH}/install_pt3.lisp
cat $INSTALL3_PATH >> ~/.sbclrc


INSTALL4_PATH=${SCRIPTPATH}/install_pt4.lisp
cd ~ || exit
sbcl --load $INSTALL4_PATH