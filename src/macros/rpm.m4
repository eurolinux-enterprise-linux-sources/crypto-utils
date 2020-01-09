
dnl Get the dependency libraries out of a libtool ".la" file
AC_DEFUN([GET_LIBTOOL_DEPLIBS], 
[`env RPMROOT=$rpmroot $SHELL -c '. $RPMROOT/$1; echo $dependency_libs'`]dnl
)


dnl Adds --with-rpm argument, and defines RPMLIBS to contain RPM libraries
AC_DEFUN([RPM_CHECK], [

AC_MSG_CHECKING(for RPM location)

AC_ARG_WITH(rpm, 
[  --with-rpm=PATH         Specify location of RPM libraries and headers], [
# Need to have both .../include and .../include/rpm in the include
# path, since the rpm headers include popt as "popt.h" and
# other rpm headers as "rpmblah.h" 
if test "$withval" = "yes"; then
  AC_MSG_ERROR(must specify full location)
else 
  CFLAGS="$CFLAGS -I$withval/include -I$withval/include/rpm"
  LDFLAGS="$LDFLAGS -L$withval/lib"
  rpmroot=$withval
  AC_MSG_RESULT($withval)
fi], [
AC_MSG_RESULT(not given)
AC_MSG_ERROR([use --with-rpm to specify RPM location])
])

AC_MSG_CHECKING(for RPM libraries)
RPMLIBS="-L$rpmroot/lib -lrpm -lpopt GET_LIBTOOL_DEPLIBS(lib/librpm.la)"
AC_MSG_RESULT($RPMLIBS)

AC_SUBST(RPMLIBS)

### Check for thread libraries which we might need to link against DB3
if test -r $rpmroot/lib/librpmdb.la; then
	AC_MSG_CHECKING(for RPM database libraries)
	RPMDBLIBS="GET_LIBTOOL_DEPLIBS(lib/librpmdb.la)"
	AC_MSG_RESULT([$RPMDBLIBS])
	RPMLIBS="$RPMLIBS $RPMDBLIBS"
else

AC_CHECK_LIB(pthread, pthread_mutex_trylock,thrlib="-lpthread",
	AC_CHECK_LIB(pthread, __pthread_mutex_trylock, thrlib="-lpthread",
		AC_CHECK_LIB(thread, mutex_trylock, thrlib="-lthread")))

### Try linking db3.

MY_SEARCH_LIBS(db_create, db3 db-3.1, $thrlib, 
	AC_MSG_ERROR([db3 library not found]))

fi

AC_CHECK_LIB(bz2, BZ2_bzCompress)

AC_CHECK_LIB(z, gzopen)

# RPM uses socket etc, so we need these too.
AC_SEARCH_LIBS(socket, socket inet)
AC_SEARCH_LIBS(gethostbyname, nsl)

AC_SUBST(RPMLIBS)

])

AC_DEFUN([RPM_VERSION], [
### Check whether we're using RPM 4.0 or 4.0.1-onwards

AC_MSG_CHECKING(for rpm version)

AC_TRY_COMPILE([#include <rpmlib.h>],[
#ifdef _ALL_REQUIRES_MASK
only-if-rpm-401-or-later
#endif
], [
AC_MSG_RESULT(4.0 or earlier)
],[
AC_DEFINE(HAVE_RPM_401, 1, [Define if you have RPM 4.0.1 or later])

dnl Now check for 4.0.3 or later
AC_TRY_COMPILE([#include <rpmlib.h>],[
#ifdef RPMFILE_ALL
only-if-rpm-403-or-later
#endif
], [
AC_MSG_RESULT(4.0.1 or thereabouts)
], [
AC_MSG_RESULT(4.0.3 or later)
AC_DEFINE(HAVE_RPM_403, 1, [Define if you have RPM 4.0.3 or later])
])])

])
