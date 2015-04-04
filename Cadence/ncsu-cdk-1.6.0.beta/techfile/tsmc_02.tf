; ==========================================================================
;
; $Id: tsmc_02.tf,v 1.1.1.1 2006/02/10 16:32:39 slipa Exp $
; 
; --------------------------------------------------------------------------

; TSMC 0.18u (0.20u drawn)

controls(
    techParams(
        ( lambda               0.10 )
        ( technology           "TSMC_CMOS020" )
        ( metal3Available      t )
        ( metal4Available      t )
        ( metal5Available      t )
        ( metal6Available      t )
        ( metalcapAvailable    t )
        ( hvAvailable          t )
        ( sblockAvailable      t )
    )
)
