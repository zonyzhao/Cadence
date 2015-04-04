;==========================================================================
;
; $Id: runBitgen.il,v 1.1.1.1 2006/02/10 16:33:45 slipa Exp $
; 
;--------------------------------------------------------------------------

; for running Bitgen (from Analog Artist)
procedure( runBitgen()
    printf( "starting BitGen...\n" )
    sh( strcat( prependNCSUCDKInstallPath( "bin/" ) "bitgen.pl &" ) )
)
