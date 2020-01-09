
dnl NEWT: add --with-newt parameter and look for newt/slang libraries.
dnl
dnl Usage:
dnl    NEWT([actions-if-with-newt], [actions-if-without-newt], [
dnl	    [actions-if-newt-not-found])
dnl If --with-newt is given, actions-if-with-newt are run.
dnl If --with-newt is NOT given, actions-if-without-newt are run.
dnl If --with-newt is given, and newt is NOT found, actions-if-newt-not-found
dnl are run.

AC_DEFUN([NEWT], [

AC_ARG_WITH(newt,
[  --with-newt=PATH        Specify location of newt/slang installation], [
CFLAGS="$CFLAGS -I$withval/include"
LDFLAGS="$LDFLAGS -L$withval/lib"
$1
found_newt=true
AC_CHECK_LIB(slang, SLang_getkey, LIBS="$LIBS -lslang", [found_newt=false])
MY_SEARCH_LIBS(newtInit, newt, -ltermcap, [found_newt=false])
if test "$found_newt" = "false"; then
    :
    $3
fi
],[
:
$2
])

])
