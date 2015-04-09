
procedure( pdkAppendTechfile( @key (libname "NCSU_TechLib_FreePDK15") )
  prog( (libID techFileID ret )
    printf("Begin pdkAppendTechfile\n")

    filename = strcat( getShellEnvVar( "PDK_DIR" ) "/cdslib/build/cds/FreePDK.tf")
    path = strcat( getShellEnvVar( "PDK_DIR" ) "/cdslib/" libname )
    printf("Loading %L into %L..." filename path )
    techFileID = techOpenTechFile( libname "tech.db" "a" )
    ret = tcLoadTechFile( techFileID filename )
    if( ret == t then
        techSaveTechFile( techFileID )
    else
        printf("ERROR: Aborting tech file compilation...\n" )
        return( nil )
    ) ;if
    printf("Techfile successfully appended.\n")

    ; Update the CDF for the NCSU_Devices_FreePDK45 library
    ;loadi( strcat( getShellEnvVar("PDK_DIR") "/ncsu_basekit/skill/cdf/loadSkill.il"))
    ;logf(LOG_INFO "CDF Data for Devices library successfully updated." )
   
    printf("Finished pdkAppendTechfile")
  ) ;prog
) ;procedure pdkAppendTechfile


