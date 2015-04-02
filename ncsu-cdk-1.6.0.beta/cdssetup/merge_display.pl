#!/usr/local/bin/perl

#==========================================================================
#
# $Id: merge_display.pl,v 1.1.1.1 2006/02/10 16:32:38 slipa Exp $
# 
# This script is used to compare the current master display.drf file with
# a new one to determine the differences. These differences can then be
# manually merged into the master file.
#
# Revision History
#
# $Log: merge_display.pl,v $
# Revision 1.1.1.1  2006/02/10 16:32:38  slipa
# starting CDK v1.5.0rc1 source file
#
# Revision 1.1  1997/12/18 19:59:24  astanas
# Initial revision
#
#
#--------------------------------------------------------------------------

open(NCSU, "display.drf")        || die "\nCannot open ncsu\n";
open(NEW,  "display.drf.new")    || die "\nCannot open new\n";
open(DIFF, ">display.drf.diff")  || die "\nCannot open diff\n";

while( <NEW> )  #-- Get the next line of input from the new file --
	{
	chop($_);   #-- remove the \n --
	$new = $_;
	
	#----------------------------------------------------------------------
	# Look for lines like ( display       white       255    255    255  )
	# in the new file. Next parse the line so that each piece can be
	# addressed. The stuff of interest is the "display       white" part, 
	# which are items 2 and 3 of the parsed line array.
	#----------------------------------------------------------------------	
	if ( $new =~ /^ \(/   ) 
		{
		$neww = $new;
		$neww =~ s/\ +/:/g;
		@neww = split(/:/, $neww);
		$found = 0;
		
		#------------------------------------------------------------------
		# Now look in the current ncsu display.drf file with the same parsing
		# and see if there is a match for items 2 and 3. If there is a match
		# then the part can be ignored.
		#------------------------------------------------------------------
	 	while( <NCSU> ) #-- Get the next line of input from the ncsu file --
 			{
 			chop($_);
 			$ncsu = $_;
 			if ( $ncsu =~ /^ \(/   )
 				{
 				$ncsu =~ s/\ +/:/g;
 				@ncsu = split(/:/, $ncsu);
 				if ( ($ncsu[2] eq $neww[2]) &&
 					 ($ncsu[3] eq $neww[3])   )
 					{ 
 					$found = 1; 
 					last;
 					}
 				}
 			}
 		if ($found != 1) {print DIFF "$new\n";}
 		seek(NCSU, 0, 0) || die "could not seek";	#-- Rewind the ncsu file.
		}


	#----------------------------------------------------------------------
	# If the input line is not of the form above look to see if it is part
	# of a stipple pattern. These look like one of the following:
	#                              (1 0 0 0 1 0 0 0 1 0 0 0 1 0 0 0)
	#                             ) )
	# If it is one of these, only print the line if the stipple identifier 
	# did not match. The identifier would be of the form tested in the 
	# previous section.
	#----------------------------------------------------------------------
	elsif ( $new =~ /^ +\([01]/  ||  $new =~ /^ +\) \)/ )
		{
		if ( $found != 1 ) {print DIFF "$new\n";}
		}

		
	#----------------------------------------------------------------------
	# If the line is not any of the above it is either a comment or a 
	# SKILL function call (section head). Print these so the output looks
	# like a .drf file. 
	#----------------------------------------------------------------------
	else  {print DIFF "$new\n";}
	
	}

close( NCSU );
close( NEW  );
close( DIFF );
