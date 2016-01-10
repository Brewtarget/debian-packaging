#!/bin/bash

REPODIR=""
NAME="brewtarget"
VERSION="2.3.0"
TARFILE="${NAME}_${VERSION}.orig.tar.xz"
BTDIR="${NAME}-${VERSION}"

if [ -n "$1" ]
then
   REPODIR="$1"
fi

# Create tar file
# The -C option first cds into the REPODIR.
# The --exclude-vcs gits rid of git shit.
# The --transform puts everything in the root dir brewtarget-2.3.0/, for
# example.
tar -cJf ${TARFILE} -C ${REPODIR} . --exclude-vcs --transform "s|^[.]|$BTDIR|"

# Extract to BTDIR
tar -xJf ${TARFILE}

# Move debian/ inside
cp -r debian ${BTDIR}

