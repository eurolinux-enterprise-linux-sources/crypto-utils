
dnl Should generalize to cope with N libraries not just 2... 
AC_DEFUN([EXTRA_2LIB], [
e_main="-l$1"
e_func=$2
e_alpha="-l$3"
e_beta="-l$4"
e_found=0
AC_MSG_CHECKING(which libraries are needed to link in $e_func)
for f in "" $e_alpha $e_beta "$e_alpha $e_beta"; do
	oLIBS="$LIBS"
	LIBS="$LIBS $e_main $f"
	AC_TRY_LINK_FUNC([$e_func], [
		e_found=1
		CRYPTO_LIBS="$e_main $f"
		LIBS="$oLIBS"
		AC_MSG_RESULT([$e_main $f])
		break
	])
	LIBS="$oLIBS"
done
LIBS="$oLIBS"
if test "$e_found" = "0"; then
	AC_MSG_RESULT(none found)
	AC_MSG_ERROR([could not link against OpenSSL libraries])
fi
])

dnl 
dnl Macro to find OpenSSL crypto libraries, puts them in CRYTPO_LIBS.
dnl 
AC_DEFUN([OPENSSL_CRYPTO], [

AC_ARG_WITH(ssl,
[   --with-ssl=PATH        Specify location of OpenSSL headers and libraries],
[if test "$withval" != "no"; then
	INCLUDES="$INCLUDES -I$withval/include"
	CFLAGS="$CFLAGS -I$withval/include"
	LDFLAGS="$LDFLAGS -L$withval/lib"
fi], [AC_MSG_ERROR([OpenSSL location not given])])

# OpenSSL may or may not need -ldl, and may or may not need -lcrt (on
# Unixware 7)
EXTRA_2LIB(crypto, RSA_new, dl, crt)

AC_SUBST(CRYPTO_LIBS)

])
