#!/bin/bash

REPODIR=""
NAME="brewtarget"
VERSION="2.0.0"
TARDIR="$NAME-$VERSION"
TARFILE="${NAME}_${VERSION}.orig.tar"

if [ -n "$1" ]
then
   REPODIR="$1"
fi

# Copy REPODIR to TARDIR
cp -r ${REPODIR} ${TARDIR}

# Clean the source dir of extraneous files/dirs
cd ${TARDIR}
cd ..
rm -rf $(find ${TARDIR} | grep '.git') # Remove git files.

# Create tar file
tar -cf ${TARFILE} ${TARDIR}

# Zip tar file
gzip --best ${TARFILE}

# Move debian/ inside
mv debian ${TARDIR}

