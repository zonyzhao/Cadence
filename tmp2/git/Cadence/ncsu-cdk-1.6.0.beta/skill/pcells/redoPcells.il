;==========================================================================
;
; Re-create pcells in technology libraries
;
; $Id: redoPcells.il,v 1.1.1.1 2006/02/10 16:33:46 slipa Exp $
; 
;--------------------------------------------------------------------------

procedure( redoPcells( @optional libs )
    let( (libList pcellList cell)

        if( libs then 
            libList = libs
        else
            libList = list( "NCSU_TechLib_ami06"
                            "NCSU_TechLib_ami16" 
                            "NCSU_TechLib_hp06"
                            "NCSU_TechLib_tsmc03"
			    "NCSU_TechLib_tsmc03d"
			    "NCSU_TechLib_tsmc02d"
                            "NCSU_TechLib_tsmc04_4M2P"
                            "NCSU_TechLib_tsmc04_4M"
                            
                      )
        )
        pcellList = list( "ntap" 
                          "ptap" 
                          "m1_n" 
                          "m1_p" 
                          "m1_poly" 
                          "m1_elec" 
                          "m2_m1" 
                          "m3_m2" 
                          "m4_m3" 
                          "m5_m4" 
                          "m6_m5" 
                          "nmos"
                          "pmos"
                          "nmos_hv"
                          "pmos_hv"
                          "cap"
                    )

        foreach( l libList
            printf( "* Doing pcells in library \"%s\"...\n" l )
            foreach( p pcellList
                when( cell = ddGetObj( l p )
                    ddDeleteObj( cell )
                )
            )
            createPcells( l )
        )

    t
    )
)
