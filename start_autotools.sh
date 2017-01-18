#!/bin/bash

#--[FILE: start_autotools.sh]--------------------#
#
# Start a GNU Autotools project in an empty directory
#
# Copyright (c) 2017 Bryan Michael Baldwin
#

#--[COPYING]-------------------------------------#
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#--[END COPYING]---------------------------------#

SCRIPT_DIR="`dirname $(readlink -f $0)`"

#--[INCLUDES]------------------------------------#
#

. $SCRIPT_DIR/glyphs

#
#--[END INCLUDES]--------------------------------#

#--[FUNCTION: help]------------------------------#
#
# Show a helpful message
function help {
echo "
         ╔════════╗
         ║┌──────┐║░
         ║│ HELP │║░
         ║└──────┘║░
         ╚════════╝░
          ░░░░░░░░░░

USAGE: start_autotools.sh [OPTIONS]
"
#-a | --<unused>
#-A | --<unused>
#-b | --<unused>
#-B | --<unused>
#-c | --<unused>
#-C | --<unused>
#-d | --<unused>
#-D | --<unused>
#-e | --<unused>
#-E | --<unused>
#-f | --<unused>
#-F | --<unused>
#-g | --<unused>
#-G | --<unused>
echo -n "-h | --help            "
echo "Show a helpful message just like this one, then exit"
#-H | --<unused>
#-i | --<unused>
#-I | --<unused>
#-j | --<unused>
#-J | --<unused>
#-g | --<unused>
#-k | --<unused>
#-K | --<unused>
#-l | --<unused>
#-L | --<unused>
#-m | --<unused>
#-M | --<unused>
echo "-n | --name            Project name"
#-N | --<unused>
#-o | --<unused>
#-O | --<unused>
echo "-p | --prefix          Path to Project directiory"
#-P | --<unused>
#-q | --<unused>
#-Q | --<unused>
#-r | --<unused>
#-R | --<unused>
#-s | --<unused>
#-S | --<unused>
#-t | --<unused>
#-T | --<unused>
#-u | --<unused>
#-U | --<unused>
#-v | --<unused>
#-V | --<unused>
#-w | --<unused>
#-W | --<unused>
#-x | --<unused>
#-X | --<unused>
#-y | --<unused>
#-Y | --<unused>
#-z | --<unused>
#-Z | --<unused>
echo

} #--[END FUNCTION: help]------------------------#

#--[MAIN]----------------------------------------#
#

# declarations

#TODO: put graphics drawings in a function.
echo
echo -n $CR_TDBL_LDBL
for i in `seq 27`; do echo -n $HORZ_DBL_DBL; done
echo $CR_TDBL_RDBL
echo -n $VERT_DBL_DBL$CR_TNRM_LNRM
for i in `seq 25`; do echo -n $HRZ_SLD_NORM; done
echo $CR_TNRM_RNRM$VERT_DBL_DBL$BLOCK_LIGHT
echo -n $VERT_DBL_DBL$VRT_SLD_NORM Start Autotools Project" "
echo $VRT_SLD_NORM$VERT_DBL_DBL$BLOCK_LIGHT
echo -n $VERT_DBL_DBL$CR_BNRM_LNRM
for i in `seq 25`; do echo -n $HRZ_SLD_NORM; done
echo $CR_BNRM_RNRM$VERT_DBL_DBL$BLOCK_LIGHT
echo -n $CR_BDBL_LDBL
for i in `seq 27`; do echo -n $HORZ_DBL_DBL; done
echo $CR_BDBL_RDBL$BLOCK_LIGHT
echo -n " "
for i in `seq 29`; do echo -n $BLOCK_LIGHT; done

ARGC=0          # number of command arguments
ARGV=()         # array of command arguments
CURRENT=""      # single member focus
INDEX=0         # counter to traverse array index
P="${0##*\/}"   # capture progam invocation (without path)
ARGC="${#@}"    # capture number of command arguments
ARGV=("${@}")   # capture command arguments as an array

# parse command line arguments
INDEX=0
CURRENT=${ARGV[$INDEX]}
while test "${CURRENT}"; do
        case "${CURRENT}" in

                -p | --prefix)
                        (( INDEX+=1 ))
                        PROJECT_PREFIX="${ARGV[INDEX]}"
                        ;;

                -h | --help)
                        help
                        exit 0
                        ;;

                -n | --name)
                        (( INDEX+=1 ))
                        PROJECT_NAME="${ARGV[INDEX]}"
                        ;;

                *)
                        echo "WTF is ${CURRENT}??"
                        help
                        exit 1
                        ;;
        esac

        (( INDEX+=1 ))
        CURRENT="${ARGV[$INDEX]}"
done

echo
echo

# Test project settings and set defaults where apropos
if test -z $PROJECT_PREFIX ; then PROJECT_PREFIX=$PWD ; fi
if test -z $PROJECT_NAME   ; then PROJECT_NAME="foo"  ; fi

PROJECT_DIR=$PROJECT_PREFIX/$PROJECT_NAME

# Test if project directory exists; else make it
if test ! -d $PROJECT_DIR; then
        mkdir -pv ${PROJECT_DIR}/src
fi

cat << EOF > $PROJECT_DIR/src/main.c
/**
 * FILE: main.c
 *
 * This file is part of ${PROJECT_NAME}
 *
 */

#include <stdio.h>

int main()
{
        printf("Hello, %s\n", "${PROJECT_NAME}");
}
EOF

cat << EOF > $PROJECT_DIR/Makefile.am
ACLOCAL_AMFLAGS = -I m4
SUBDIRS = src
EOF

cat << EOF > $PROJECT_DIR/src/Makefile.am
bin_PROGRAMS = ${PROJECT_NAME}
${PROJECT_NAME}_SOURCES = main.c
#${PROJECT_NAME}_CPPFLAGS =
#${PROJECT_NAME}_LDADD =
EOF

cd $PROJECT_DIR
autoscan
sed -e "s/FULL-PACKAGE-NAME/${PROJECT_NAME}/" \
    -e "s/VERSION/0.0.1/" \
    -e "s|BUG-REPORT-ADDRESS|/dev/null|" \
    -e "10i\
AM_INIT_AUTOMAKE" \
    < configure.scan > configure.ac

touch NEWS README AUTHORS ChangeLog

autoreconf -iv
./configure
make
src/${PROJECT_NAME}
