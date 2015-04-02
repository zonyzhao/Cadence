; ==========================================================================
;
; $Id: tsmc_04_4m.tf,v 1.1.1.1 2006/02/10 16:32:38 slipa Exp $
; 
; --------------------------------------------------------------------------

; TSMC 0.35u (4m, silicide block variant)

controls(
    techParams(
        ( lambda               0.2 )
        ( technology           "TSMC_CMOS035_4M" )
        ( metal3Available      t )
        ( metal4Available      t )
        ( sblockAvailable      t )
        ( hvAvailable          t )
    )
)
