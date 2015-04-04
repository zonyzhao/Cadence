#!/usr/local/bin/perl
#
# This program reads in a run parameter report from MOSIS
# and makes spice model files (nmos & pmos) from the parameters (HSPICE
# level 13). The output is placed in spiceN.m and spiceN.m in 
# the current directory. The model name is <model_name_prefix>N or
# <model_name_prefix>P.
#
# prm2spice <model_name_prefix> <mosis_run_report_file>
#
# Revision History
#
# $Log: prm2spice.pl,v $
# Revision 1.1.1.1  2006/02/10 16:32:40  slipa
# starting CDK v1.5.0rc1 source file
#
# Revision 1.2  1998/01/27 17:51:55  jtschaff
# work with different prm file formats, changed [np]mos to [NP]
#
# Revision 1.1  1997/02/12 23:15:42  astanas
# Initial revision
#
#
#--------------------------------------------------------------------------

if( @ARGV != 2 )
	{
	print( "USAGE: $0 model_name_prefix mosis_run_report_file\n" );
	exit;
	}
	
open(PRMFILE, $ARGV[1])  		|| die "$0: Could not open \"$ARGV[1]\" for input\n";
open(NMOSFILE, ">spiceN.m")	|| die "$0: Could not open \"spiceN.m\" for output\n";
open(PMOSFILE, ">spiceP.m")	|| die "$0: Could not open \"spiceP.m\" for output\n";


#--------------------------------------------------------------------------
# nfet parameter name list (from run n56s)
#--------------------------------------------------------------------------

@nfetParameters = (
"vfb0=",
"lvfb=",
"wvfb=",
"phi0=",
"lphi=",
"wphi=",
"k1=",
"lk1=",
"wk1=",
"k2=",
"lk2=",
"wk2=",
"eta0=",
"leta=",
"weta=",
"muz=",
"dl0=",
"dw0=",
"u00=",
"lu0=",
"wu0=",
"u1=",
"lu1=",
"wu1=",
"x2m=",
"lx2m=",
"wx2m=",
"x2e=",
"lx2e=",
"wx2e=",
"x3e=",
"lx3e=",
"wx3e=",
"x2u0=",
"lx2u0=",
"wx2u0=",
"x2u1=",
"lx2u1=",
"wx2u1=",
"mus=",
"lms=",
"wms=",
"x2ms=",
"lx2ms=",
"wx2ms=",
"x3ms=",
"lx3ms=",
"wx3ms=",
"x3u1=",
"lx3u1=",
"wx3u1=",
"tox=",
"tempm=",
"vddm=",
"cgdom=",
"cgsom=",
"cgbom=",
"xpart=",
"dum1=",
"dum2=",
"n0=",
"ln0=",
"wn0=",
"nb0=",
"lnb=",
"wnb=",
"nd0=",
"lnd=",
"wnd=",
"rsh=",
"cj=",
"cjw=",
"ijs=",
"pj=",
"pjw=",
"mj0=",
"mjw=",
"wdf=",
"ds="
);

#--------------------------------------------------------------------------
# pfet parameter name list (run n56s)
#--------------------------------------------------------------------------

@pfetParameters = (
"vfb0=",
"lvfb=",
"wvfb=",
"phi0=",
"lphi=",
"wphi=",
"k1=",
"lk1=",
"wk1=",
"k2=",
"lk2=",
"wk2=",
"eta0=",
"leta=",
"weta=",
"muz=",
"dl0=",
"dw0=",
"u00=",
"lu0=",
"wu0=",
"u1=",
"lu1=",
"wu1=",
"x2m=",
"lx2m=",
"wx2m=",
"x2e=",
"lx2e=",
"wx2e=",
"x3e=",
"lx3e=",
"wx3e=",
"x2u0=",
"lx2u0=",
"wx2u0=",
"x2u1=",
"lx2u1=",
"wx2u1=",
"mus=",
"lms=",
"wms=",
"x2ms=",
"lx2ms=",
"wx2ms=",
"x3ms=",
"lx3ms=",
"wx3ms=",
"x3u1=",
"lx3u1=",
"wx3u1=",
"tox=",
"tempm=",
"vddm=",
"cgdom=",
"cgsom=",
"cgbom=",
"xpart=",
"dum1=",
"dum2=",
"n0=",
"ln0=",
"wn0=",
"nb0=",
"lnb=",
"wnb=",
"nd0=",
"lnd=",
"wnd=",
"rsh=",
"cj=",
"cjw=",
"ijs=",
"pj=",
"pjw=",
"mj0=",
"mjw=",
"wdf=",
"ds="
);

#-----------------------------------------------------------------------------
# Open the parameter file and look for the header lines from the BSIM section.
# These will go at the top of each model file as a comment.
#-----------------------------------------------------------------------------

while( <PRMFILE> )
    {
    if( /SPICE BSIM1/ )
    	{
    	$i=0;
    	$header[$i]="*".substr($_, 2);
    	while( <PRMFILE> )
    		{
    		if( /^\*/ )
    			{
    			$i++;
    			$header[$i]=$_;
    			last if /^\*DATE/;
    			}
    		}
    	}

    #--------------------------------------------------------------------------
	# Now look for the NMOS section. Pair the values with the parameter names.
	#--------------------------------------------------------------------------

    elsif( (/^\*NMOS PARAMETERS/ or /^\*N\+ diffusion/) and 
           ($nParam < @nfetParameters) ) #-- avoid duplicating diff parameters
        {
        <PRMFILE>;   #-- Eat next star --
        while( <PRMFILE> )
            {
            next if( /^\.model/i ); #-- skip optional .MODEL line --
            last if /^\*/;
            chop;
            s/^\+//; #-- remove optional leading "+" --
            @params = split( /,/, $_ );
            for( $i=0; $i<@params; $i++ )
                {
                $params[$i]=~s/ //g; #-- remove white space --
                
                #---- HSpice tox is in um, change to m ----
                if( $nfetParameters[$nParam] eq "tox=" )
                	{
                	$params[$i] = $params[$i] * 1E-6;
                	$nfetParameters[$nParam++] .= sprintf("%E &", $params[$i]);
                	}
                #---- The last line does not need a continuation ----
                elsif($nfetParameters[$nParam] eq "ds=")
                	{
                	$nfetParameters[$nParam++] .= $params[$i];
                	}
                #---- All the normal lines ----
                else
                	{
                	$nfetParameters[$nParam++] .= $params[$i]." &";
                	}
                }
            }
        }

    #--------------------------------------------------------------------------
	# Now look for the PMOS section. Pair the values with the parameter names.
	#--------------------------------------------------------------------------

    elsif( (/^\*PMOS PARAMETERS/ or /^\*P\+ diffusion/) and
           ($pParam < @pfetParameters) ) #-- avoid duplicating diff parameters
        {
        <PRMFILE>;   #-- Eat next star --
        while( <PRMFILE> )
            {
            next if( /^\.model/i ); #-- skip optional .MODEL line --
            last if /^\*/;
            chop;
            s/^\+//; #-- remove optional leading "+" --
            @params = split( /,/, $_ );
            for( $i=0; $i<@params; $i++ )
                {
                $params[$i]=~s/ //g; #-- remove white space --

                #---- HSpice tox is in um, change to m ----
                if( $pfetParameters[$pParam] eq "tox=" )
                	{
                	$params[$i] = $params[$i] * 1E-6;
                	$pfetParameters[$pParam++] .= sprintf("%E &", $params[$i]);
                	}
                #---- The last line does not need a continuation ----
                elsif($pfetParameters[$pParam] eq "ds=")
                	{
                	$pfetParameters[$pParam++] .= $params[$i];
                	}
                #---- All the normal lines ----
                else
                	{
                	$pfetParameters[$pParam++] .= $params[$i]." &";
                	}
                }
            }
        }
    }

#--------------------------------------------------------------------------
# Print the output files.
#--------------------------------------------------------------------------

print( NMOSFILE "* Model file automatically generated by prm2spice.pl\n\n" );
print( NMOSFILE @header,"\n");
print( NMOSFILE ".MODEL $ARGV[0]N NMOS level=4 &\n" );
foreach $param (@nfetParameters)
    {
    print( NMOSFILE $param,"\n" );
    }
#print( "\n" );
print( PMOSFILE "* Model file automatically generated by prm2spice.pl\n\n" );
print( PMOSFILE @header,"\n");
print( PMOSFILE ".MODEL $ARGV[0]P PMOS level=4 &\n" );
foreach $param (@pfetParameters)
    {
    print( PMOSFILE $param,"\n" );
    }

close(PRMFILE, NMOSFILE, PMOSFILE);
