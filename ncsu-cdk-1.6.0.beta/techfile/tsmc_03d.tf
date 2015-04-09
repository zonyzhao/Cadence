; ==========================================================================
;
; $Id: tsmc_03d.tf,v 1.1.1.1 2006/02/10 16:32:39 slipa Exp $
; 
; --------------------------------------------------------------------------

; TSMC 0.25u

controls(
    techParams(
        ( lambda               0.12 )
        ( technology           "TSMC_CMOS025_DEEP" )
        ( metal3Available      t )
        ( metal4Available      t )
        ( metal5Available      t )
        ( metalcapAvailable    t )
        ( sblockAvailable      t )
        ( hvAvailable          t )
    )
)
