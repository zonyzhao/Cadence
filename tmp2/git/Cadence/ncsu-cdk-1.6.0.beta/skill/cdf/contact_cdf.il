;==========================================================================
;
; $Id: contact_cdf.il,v 1.1.1.1 2006/02/10 16:33:45 slipa Exp $
;
; Callbacks for the following pcell CDFs:
; 
;   m1_n, m1_p, m1_poly, m2_m1, m3_m2, m4_m3, ntap, ptap
;
;--------------------------------------------------------------------------

procedure( CheckRowsAndColumnsCB()

    if( cdfgData->_rows->value < 1 then
        hiGetAttention()
        warn( "\"Rows\" must be an integer >= 1, setting to 1..." )
        cdfgData->_rows->value = 1
    )

    if( cdfgData->_columns->value < 1 then
        hiGetAttention()
        warn( "\"Columns\" must be an integer >= 1, setting to 1..." )
        cdfgData->_columns->value = 1
    )

) ;---- End procedure CheckRowsAndColumnsCB  ----
