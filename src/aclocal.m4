# generated automatically by aclocal 1.8.2 -*- Autoconf -*-

# Copyright (C) 1996, 1997, 1998, 1999, 2000, 2001, 2002, 2003, 2004
# Free Software Foundation, Inc.
# This file is free software; the Free Software Foundation
# gives unlimited permission to copy and/or distribute it,
# with or without modifications, as long as this notice is preserved.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY, to the extent permitted by law; without
# even the implied warranty of MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE.

dnl
dnl The 'MY_SEARCH_LIBS' is a slightly different version of
dnl AC_SEARCH_LIBS: it's used like:
dnl
dnl    MY_SEARCH_LIBS (FUNCTION, SEARCH-LIBS, OTHER-LIBS,
dnl		[actions-if-not-found])
dnl
dnl It searches each of SEARCH-LIBS for FUNCTION.  For each
dnl of SEARCH-LIBS, if the link fails, it will try the same
dnl link with OTHER-LIBS again.
dnl
dnl If a successful link is never made, actions-if-not-found are run,
dnl if specified.  If a successful link is made, the required libraries 
dnl are added to the front of $LIBS.

AC_DEFUN([MY_SEARCH_LIBS], [
# function is $1
# libs are $2
# otherlibs is $3
oLIBS=$LIBS

AC_MSG_CHECKING(for library containing $1)
my_res="none found"

for l in $2; do
	LIBS="-l$l $oLIBS"
	AC_TRY_LINK_FUNC($1, [
		my_res="-l$l"
		break
		], [
		LIBS="$LIBS $3"
		AC_TRY_LINK_FUNC($1, [my_res="-l$l $3"; break])
	])
	LIBS="$oLIBS"
done

if test "$my_res" = "none found"; then
	$4
	:
fi

AC_MSG_RESULT($my_res)

])


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

