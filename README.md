# Brewtarget Debian Packaging

This project contains all files and scripts required to generate a Debian
package for Brewtarget.

See https://github.com/Brewtarget/brewtarget/wiki/Uploading-and-Releasing for more details.

## Example

Assuming `brewtarget` contains the source we want to package, `2.3.0` is
the current version, and `debian-packaging` is this repo.

    $ cd debian-packaging
    $ ./createorig.sh ../brewtarget 2.3.0
    $ cd brewtarget-2.3.0
    $ dpkg-buildpackage -us -uc
    $ lintian --pedantic *.changes | less
    $ dupload -t mentors *.changes
