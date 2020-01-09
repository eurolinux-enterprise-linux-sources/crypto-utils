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
