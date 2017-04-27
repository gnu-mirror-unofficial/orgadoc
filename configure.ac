# This file is part of GNU OrgaDoc.
#
# GNU package is free software: you can redistribute it
# and/or modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation, either version 3
# of the License, or (at your option) any later version.
#
# GNU package is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see http://www.gnu.org/licenses/.

#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ(2.69)
AC_INIT(GNU OrgaDoc, 0.9)
AC_CONFIG_SRCDIR([src/orgadoc.e])

# Auxiliary files.
AC_CONFIG_AUX_DIR(config)
AC_CONFIG_FILES(config/Makefile)

AM_INIT_AUTOMAKE

#
# Checks for programs.
#
AC_PROG_INSTALL
AC_PROG_CC
AC_C_CONST

#
# Checks for Eiffel compiler
AC_ARG_WITH(compiler,
 [  --with-compiler=compiler What compiler do you use? ise, se or ve (lowercase!)],
 GOBO_EIFFEL=$withval, GOBO_EIFFEL=se)

# default path for GOBO and ORGADOC
if test x$GOBO = x; then
  export GOBO=/usr/lib/gobo
fi
if test x$ORGADOC = x; then
  export CURRENT_DIR=`pwd`/src
  export ORGADOC=`pwd`
else
  export CURRENT_DIR=$ORGADOC/src
fi

# Expat directory
AC_ARG_WITH(expat, dnl
[  --with-expat            Specify expat path (default /usr)],
            [with_expat=$withval], [with_expat=yes])

if test "$with_expat" = "yes"; then 
  for ac_dir in / /usr; do
    if test -f "$ac_dir/lib/libexpat.so"; then
      with_expat=$ac_dir
      break;
    fi
  done
fi

#set expat path
EXPAT=$with_expat

# We need Gobo as well.
AC_PROG_GOBO
AC_CHECK_RQRD_CLUSTER(GOBO)
AC_CHECK_RQRD_XACE(ORGADOC, src, orgadoc)
AC_CHECK_RQRD_XACE(ORGADOC, src, cgi)
if test x$GOBO_EIFFEL = xse; then
  AC_CHECK_RQRD_CLUSTER2(SmartEiffel)
fi

# enable/disable debug
AC_ARG_ENABLE(debug,
[  --enable-debug          Turn on eiffel debug (not recommended)],
[case "${enableval}" in
   yes|no) ;;
   *) AC_MSG_ERROR([bad value ${enableval} for debug option]) ;;
 esac],
              [enableval=no])
if test "${enableval}" = yes; then
  DEBUG=" DEBUG"
else
  EC="$EC -no_warning"
fi

# Set vars in Makefile(s)
AC_SUBST(EXPAT)
AC_SUBST(GOBO)
AC_SUBST(GOBO_EIFFEL)
AC_SUBST(CURRENT_DIR)
AC_SUBST(DEBUG)

# update version informations in config.e
echo "   VERSION : STRING is \"$VERSION\"" > config.e

AC_CONFIG_FILES([Makefile src/Makefile utils/Makefile])

# Intantiate the output files.
AC_OUTPUT
