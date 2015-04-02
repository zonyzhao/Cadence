#!/usr/local/bin/perl -w

# $Id: dsmwrapper.pl,v 1.1.1.1 2006/02/10 16:33:46 slipa Exp $
#
# wrapper script for cadence tools
# 
# this script fixes (hopefully) the errors you get when trying to run
# HSPICE via Analog Artist after doing something like
#
#   % add cadence
#   % add hspice
#   % msfb              (or whatever cadence exe you like)
#
# then trying AA with HSPICE. the error you get looks something like
# 
#    *Warning* Wave2 is not a waveform object that can be displayed and
#              will be turned OFF automatically.
#              name: "/out"
#              expr: "VT(\"/out\"
#              \"/tmp/cadence.awglaser/simulation/2inv/hspiceS/schematic\")"
# 
# the error occurs because AA (for whatever reason) doesn't use the full
# path to the <cds_dir>/tools/dfII/bin/hspice script, just calls it with
# "hspice". so the "add hspice" screws up PATH, and points it to the 98.2
# version of hspice, which is known to exhibit the above bug. whew.
# 
# the script simply removes the hspice98.2 directories from PATH, then
# removes its own directory, so PATH points to the real cadence exe,
# then fires up the cadence executable
#
# (note that the script uses $0 -- the name the script was invoked
# with -- to determine which cadence exe to run. so call the script
# "foo.pl" or whatever, and make a bunch of symlinks with the same name
# as the cadence executables that point to it.)

use strict;

# get the basename of how we were called, e.g. msfb

my @progname = split( /\//, $0 );
my $progname = pop( @progname );

# get the cadence base dir

my $cds_dir = $ENV{"CDS"};

# now strip out the paths

$ENV{"PATH"} =~ s|/afs/eos.ncsu.edu/dist/hspice982/bin:||;
$ENV{"PATH"} =~ s|/afs/eos.ncsu.edu/dist/hspice982/sol4:||;
$ENV{"PATH"} =~ s|/ncsu/hspice/bin:||;
$ENV{"PATH"} =~ s|$cds_dir/bin:||;

# my $path = $ENV{"PATH"};
# print "PATH = $path\n";
# print "starting $progname @ARGV\n";

exec( "$progname @ARGV" );
exit( 0 );
