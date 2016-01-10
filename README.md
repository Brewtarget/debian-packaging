# Brewtarget Debian Packaging

This project contains all files and scripts required to generate a Debian
package for Brewtarget

## Example

Assuming `brewtarget` contains the source we want to package, `2.3.0` is
the current version, and `debian-packaging` is this repo.

    $ cd debian-packaging
    $ ./createorig.sh ../brewtarget
    $ cd brewtarget-2.3.0
    $ dpkg-buildpackage -us -uc
    $ lintian --pedantic *.changes | less
    $ dupload -t mentors *.changes
