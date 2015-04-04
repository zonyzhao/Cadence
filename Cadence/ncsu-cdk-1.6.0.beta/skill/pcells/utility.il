;==========================================================================
;
; utility.il - common functions for pcells
;
; $Id: utility.il,v 1.1.1.1 2006/02/10 16:33:46 slipa Exp $
; 
;--------------------------------------------------------------------------

/*
 * create pcells in library "libName"
 */
procedure( createPcells( libName )
    prog( (libId catId tf elecAvailable metal3Available metal4Available
           metal5Available metal6Available cwellAvailable hvAvailable 
           ncsuMosCDF ncsuMos mos cdf)

        libId = ddGetObj( libName )
        if( libId == nil then
            warn( "Can't find library \"%s\"" libName )
            return( nil )
        )

        /*
         * check what optional layers are available
         */
        tf = techGetTechFile( libId )
        if( tf == nil then
            warn( "Can't get tech file for library \"%s\"" libName )
            return( nil )
        )
        elecAvailable   = techGetLayerNum( tf "elec" )
        metal3Available = techGetLayerNum( tf "metal3" )
        metal4Available = techGetLayerNum( tf "metal4" )
        metal5Available = techGetLayerNum( tf "metal5" )
        metal6Available = techGetLayerNum( tf "metal6" )
        cwellAvailable  = techGetLayerNum( tf "cwell" )
        hvAvailable     = techGetLayerNum( tf "tactive" )

        /*
         * create the pcells
         */
        createM1_Npcell( libName )
        createM1_Ppcell( libName )
        createM1_POLYpcell( libName )
        createM2_M1pcell( libName )
        createNMOSpcell( libName )
        createPMOSpcell( libName )
        createNTAPpcell( libName )
        createPTAPpcell( libName )
        if( elecAvailable then
            createM1_ELECpcell( libName )
        )
        if( metal3Available then
            createM3_M2pcell( libName )
        )
        if( metal4Available then
            createM4_M3pcell( libName )
        )
        if( metal5Available then
            createM5_M4pcell( libName )
        )
        /* comment out metal6 until we get m6 design rules
        if( metal6Available then
            createM6_M5pcell( libName )
        )
        */
        if( cwellAvailable then
            createCAPpcell( libName )
        )
        if( hvAvailable then
            createNMOS_HVpcell( libName )
            createPMOS_HVpcell( libName )
        )
        /*
         * finishing touches:
         * - create CDFs
         * - create a pcells category and put 'em all in there
         */
        makeCDF( libName "m1_n" "contact" )
        makeCDF( libName "m1_p" "contact" )
        makeCDF( libName "m1_poly" "contact" )
        makeCDF( libName "m2_m1" "contact" )
        makeCDF( libName "ntap" "contact" )
        makeCDF( libName "ptap" "contact" )
        if( elecAvailable then
            makeCDF( libName "m1_elec" "contact" )
        )
        if( metal3Available then 
            makeCDF( libName "m3_m2" "contact" )
        )
        if( metal4Available then
            makeCDF( libName "m4_m3" "contact" )
        )
        if( metal5Available then
            makeCDF( libName "m5_m4" "contact" )
        )
        /*
        if( metal6Available then
            makeCDF( libName "m6_m5" "contact" )
        )
        */
        if( cwellAvailable then
            makeCDF( libName "cap" "cap" )
        )

        /*
         * copy CDFs from NCSU_Analog_Parts to [np]mos transistors
         */
        ncsuMos = ddGetObj( "NCSU_Analog_Parts" "nmos" )
        unless( ncsuMos == nil
            ncsuMosCDF = cdfGetBaseCellCDF( ncsuMos )
            unless( ncsuMosCDF == nil
                mos = ddGetObj( libName "nmos" )
                when( cdf = cdfGetBaseCellCDF( mos )
                    cdfDeleteCDF( cdf )
                )
                cdf = cdfCopyCDF( mos "baseCellData" ncsuMosCDF )
                cdfSaveCDF( cdf )
            )
        )

        ncsuMos = ddGetObj( "NCSU_Analog_Parts" "pmos" )
        unless( ncsuMos == nil
            ncsuMosCDF = cdfGetBaseCellCDF( ncsuMos )
            unless( ncsuMosCDF == nil
                mos = ddGetObj( libName "pmos" )
                when( cdf = cdfGetBaseCellCDF( mos )
                    cdfDeleteCDF( cdf )
                )
                cdf = cdfCopyCDF( mos "baseCellData" ncsuMosCDF )
                cdfSaveCDF( cdf )
            )
        )

        if( hvAvailable then
            ncsuMos = ddGetObj( "NCSU_Analog_Parts" "nmos_hv" )
            unless( ncsuMos == nil
                ncsuMosCDF = cdfGetBaseCellCDF( ncsuMos )
                unless( ncsuMosCDF == nil
                    mos = ddGetObj( libName "nmos_hv" )
                    when( cdf = cdfGetBaseCellCDF( mos )
                        cdfDeleteCDF( cdf )
                    )
                    cdf = cdfCopyCDF( mos "baseCellData" ncsuMosCDF )
                    cdfSaveCDF( cdf )
                )
            )

            ncsuMos = ddGetObj( "NCSU_Analog_Parts" "pmos_hv" )
            unless( ncsuMos == nil
                ncsuMosCDF = cdfGetBaseCellCDF( ncsuMos )
                unless( ncsuMosCDF == nil
                    mos = ddGetObj( libName "pmos_hv" )
                    when( cdf = cdfGetBaseCellCDF( mos )
                        cdfDeleteCDF( cdf )
                    )
                    cdf = cdfCopyCDF( mos "baseCellData" ncsuMosCDF )
                    cdfSaveCDF( cdf )
                )
            )
        )


        /*
         * first, open the category for read to see if it exists. if it
         * doesn't, open it for writing otherwise do an append. this is
         * mainly useful for when you have to redoPcells().
         */
        catId = ddCatOpen( libId "layout_macros" "r" )
        if( catId == nil then
            catId = ddCatOpen( libId "layout_macros" "w" )
        else
            catId = ddCatOpen( libId "layout_macros" "a" )
        )
        unless( catId == nil 
            ddCatAddItem( catId "nmos" "cell" )
            ddCatAddItem( catId "pmos" "cell" )
            ddCatAddItem( catId "m1_n" "cell" )
            ddCatAddItem( catId "m1_p" "cell" )
            ddCatAddItem( catId "m1_poly" "cell" )
            ddCatAddItem( catId "m2_m1" "cell" )
            ddCatAddItem( catId "ntap" "cell" )
            ddCatAddItem( catId "ptap" "cell" )
            if( elecAvailable then
                ddCatAddItem( catId "m1_elec" "cell" )
            )
            if( metal3Available then 
                ddCatAddItem( catId "m3_m2" "cell" )
            )
            if( metal4Available 
                ddCatAddItem( catId "m4_m3" "cell" )
            )
            if( metal5Available 
                ddCatAddItem( catId "m5_m4" "cell" )
            )
            /*
            if( metal6Available 
                ddCatAddItem( catId "m6_m5" "cell" )
            )
            */
            if( cwellAvailable then
                ddCatAddItem( catId "cap" "cell" )
            )
            if( hvAvailable then
                ddCatAddItem( catId "nmos_hv" "cell" )
                ddCatAddItem( catId "pmos_hv" "cell" )
            )

            ddCatSave( catId )
            ddCatClose( catId )
        )

        return( t )
    )
)


procedure( makeCDF( libName cell type )
    prog( (cellId cdf)

        cellId = ddGetObj( libName cell )
        if( cellId == nil then
            warn( "can't create CDF for cell %s" cell )
            return( nil )
        )

        when( cdf = cdfGetBaseCellCDF( cellId )
            cdfDeleteCDF( cdf )
        )

        cdf = cdfCreateBaseCellCDF( cellId )
        if( cdf == nil then
            warn( "can't create CDF for cell %s" cell )
            return( nil )
        )

        unless( cdf == nil 
            case( type
                ( "contact"
                    /*
                     * we have to use "_rows" instead of "rows" for the
                     * name so we don't get a conflict with the standard
                     * "rows" that's present (for arrays) in the "Create
                     * Instance" form, and the same for "_columns"
                     */
                    cdfCreateParam( cdf
                        ?name           "_rows"
                        ?prompt         "Rows of contacts"
                        ?defValue       1
                        ?type           "int"
                        ?display        "t"
                        ?editable       "t"
                        ?callback       "CheckRowsAndColumnsCB()"
                    )
                    cdfCreateParam( cdf
                        ?name           "_columns"
                        ?prompt         "Columns of contacts"
                        ?defValue       1
                        ?type           "int"
                        ?display        "t"
                        ?editable       "t"
                        ?callback       "CheckRowsAndColumnsCB()"
                    )
                )
                ( "cap"
                    cdfCreateParam( cdf
                        ?name "redoWhich" 
                        ?type "radio" 
                        ?choices list( "width" "height" )
                        ?defValue "width" 
                        ?prompt "Resize:" 
                        ?display "t" 
                        ?editable nil 
                    )
                    cdfCreateParam( cdf
                        ?name "pcRows" 
                        ?type "int" 
                        ?defValue 1 
                        ?prompt "Rows of poly contacts" 
                        ?display "t" 
                        ?editable "t" 
                        ?callback "pcRowsCB()" 
                    )
                    cdfCreateParam( cdf 
                        ?name "caRows" 
                        ?type "int" 
                        ?defValue 1 
                        ?prompt "Rows of active contacts"
                        ?display "t" 
                        ?editable "t" 
                        ?callback "caRowsCB()" 
                    )
                    cdfCreateParam( cdf 
                      ?name "w_microns" 
                      ?type "float" 
                      ?defValue 1.8 
                      ?prompt "Width(um)" 
                      ?display "nil" 
                      ?editable "nil" 
                    )
                    cdfCreateParam( cdf 
                      ?name "width" 
                      ?type "string" 
                      ?defValue "1.8u" 
                      ?prompt "Width" 
                      ?parseAsNumber "yes" 
                      ?units "lengthMetric" 
                      ?display "t" 
                      ?editable "t" 
                      ?callback "modifyCapValue()" 
                    )
                    cdfCreateParam( cdf 
                      ?name "h_microns" 
                      ?type "float" 
                      ?defValue 2.85 
                      ?prompt "Height(um)" 
                      ?display "nil" 
                      ?editable "nil" 
                    )
                    cdfCreateParam( cdf
                      ?name "height" 
                      ?type "string" 
                      ?defValue "2.85u" 
                      ?prompt "Height" 
                      ?parseAsNumber "yes"
                      ?units "lengthMetric" 
                      ?display "t" 
                      ?editable "t" 
                      ?callback "modifyCapValue()" 
                    )
                    cdfCreateParam( cdf
                      ?name "c" 
                      ?type "string" 
                      ?defValue "1.18f" 
                      ?prompt "Capacitance" 
                      ?parseAsNumber "yes"
                      ?units "capacitance" 
                      ?display "t" 
                      ?editable "t" 
                      ?callback "capChange()" 
                    )
                    cdfCreateParam( cdf 
                      ?name "capPerSquareMicron" 
                      ?type "string" 
                      ?defValue "2.3e-15" 
                      ?prompt "F/um^2" 
                      ?parseAsNumber "yes"
                      ?display "t" 
                      ?editable "nil" 
                      ?dontSave nil 
                      ?callback "modifyCapValue()" 
                    )
                )
            )

            cdfSaveCDF( cdf )
        )

        return( t )
    )
)

/* vim:set ts=4: */
