;==========================================================================
;
; $Id: runBitgen.il 3 2007-01-10 22:50:03Z wdavis $
; 
;--------------------------------------------------------------------------

; for running Bitgen (from Analog Artist)
procedure( runBitgen()
    printf( "starting BitGen...\n" )
    sh( strcat( prependNCSUCDKInstallPath( "bin/" ) "bitgen.pl &" ) )
)
