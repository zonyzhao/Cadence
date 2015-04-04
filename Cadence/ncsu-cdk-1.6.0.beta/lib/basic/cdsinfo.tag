#
# This is a cdsinfo.tag file.
#
# Setting entries in this file makes them effective for this
# directory and any subdirectories which do not in turn have
# cdsinfo.tag files in them.
#
# The `#' character denotes a comment. Remove the leading `#'
# characters from the entries below to activate them.
#
# CDSLIBRARY entry - add this entry if the directory containing
# this cdsinfo.tag file is a Cadence library.
# CDSLIBRARY
#
# CDSLIBCHECK - set this entry to require that libraries have
# a cdsinfo.tag file with a CDSLIBRARY entry. Legal values are
# ON and OFF. By default (OFF), any directory named in a cds.lib
# file is a library.
# CDSLIBCHECK OFF
#
# LOCKHOST - set this entry to define the lock host for a directory
# and its contents. Legal values are any unique host name (without
# the angle brackets). `localhost' is NOT legal.
# LOCKHOST <lockhostname>
#
# LOCKPATH - set this entry if you set the LOCKHOST entry. This
# entry defines a unique path that is used in lock requests so that
# mounting this directory on another machine won't generate conflicting
# lock requests. A good example is any network-unique path, such as
# /net/hostname/<path to dir>
# LOCKPATH <unique path>
#
# DMTYPE - set this entry to define the DM system for Cadence's
# Generic DM facility. Values will be shifted to lower case.
# DMTYPE tdm
#
# NAMESPACE - set this entry to define the library namespace according
# to this type of machine on which the data is stored. Legal values are
# `LibraryNT' and
# `LibraryUnix'.
# NAMESPACE LibraryUnix
#
# Current Settings:
#
CDSLIBRARY
