#!/bin/bash
#
# createorig.sh is part of Brewtarget, and is Copyright the following
# authors 2016-2022
#  - Matt Young <mfsy@yahoo.com>
#  - Mik Firestone <mikfire@gmail.com>
#  - Philip Greggory Lee <rocketman768@gmail.com>
#
# Brewtarget is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Brewtarget is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

#-----------------------------------------------------------------------------------------------------------------------
# Get a y/n confirmation from the user.  On "n" abort the script; on "y" continue
#
# Params: $1 - Message to display eg "File exists. Overwrite?"  The function will add [y/n] etc.
#-----------------------------------------------------------------------------------------------------------------------
function confirmOrAbort {
   echo -n "$1 [y/n]  "
   response=""
   while [[ ${response} != "y" && ${response} != "n" ]]
   do
      echo -en "\b \b"
      read -N 1 -r response
      response=${response,,}    # tolower
      if [[ "$response" = "n" ]]
      then
         echo
         echo "Aborting"
         exit 1
      fi
   done
   echo
   return
}

#-----------------------------------------------------------------------------------------------------------------------
# Main code starts here
#-----------------------------------------------------------------------------------------------------------------------
if [[ $# -ne 2 ]]
then
   echo "Usage: $(basename $(readlink -nf $0)) <repo directory> <version string>"
   echo "Eg: $(basename $(readlink -nf $0)) brewtarget-release 2.4.0"
   exit 2
fi

REPODIR="$1"
VERSION="$2"

NAME="brewtarget"
TARFILE="${NAME}_${VERSION}.orig.tar.xz"
BTDIR="${NAME}-${VERSION}"

# Make sure there are no build artifacts in the tree we are packaging up
if [[ -d "${REPODIR}/build" ]]
then
   # If the build directory exists, just ensure no compilation output in it
   echo "Ensuring no build artifacts in ${REPODIR}/build"
   cd "${REPODIR}/build"
   make clean
   cd -
else
   # If the build directory does not exist then it's usually because the source tree was checked out but build didn't
   # get configured
   echo "Configuring build directory in ${REPODIR}"
   if [[ -f "${REPODIR}/configure" ]]
   then
      cd "${REPODIR}"
      ./configure
      cd -
   else
      echo "Could not find ${REPODIR}/configure script"
      exit 2
   fi
fi

# Create tar file
# The -C option first cds into the REPODIR.
# The --exclude-vcs gits rid of git shit.
# The --transform puts everything in the root dir brewtarget-2.3.0/, for
# example.
echo "Creating ${TARFILE} from ${REPODIR} (with folder renamed to ${BTDIR})"
if [[ -f ${TARFILE} ]]
then
   confirmOrAbort "${TARFILE} exits.  Overwrite?"
   rm -f ${TARFILE}
fi
tar -cJf ${TARFILE} -C ${REPODIR} --exclude-vcs --transform "s|^[.]|$BTDIR|" .

# Extract to BTDIR
echo "Extracting ${TARFILE}"
if [[ -d ${BTDIR} ]]
then
   confirmOrAbort "${BTDIR} exits.  Overwrite?"
   rm -rf ${BTDIR}
fi
tar -xJf ${TARFILE}

# Move debian/ inside
echo "Copying debian folder into ${BTDIR}"
cp -r debian ${BTDIR}

echo "Done"
