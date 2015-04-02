;==========================================================================
;
; $Id: divaMultiLevel.il,v 1.3 2006/04/26 23:24:31 amsule Exp $
; 
;--------------------------------------------------------------------------

/********************************************************************************
 *                                                                              *
 *                                                                              *
 *                       Parasitic Capacitance Extraction                       *
 *                                                                              *
 *                                                                              *
 ********************************************************************************/

        ;--------------------------------------------------------------------------------
        ;
        ; Metal 5 Capacitances
        ;
        ;--------------------------------------------------------------------------------

        if( metal5Available then
            let( (  capacitance tempCap
                (areaCap_5D 0)  (perimeterCap_5D 0)
                (areaCap_5A 0)  (perimeterCap_5A 0)
                (areaCap_5P 0)  (perimeterCap_5P 0)
                (areaCap_51 0)  (perimeterCap_51 0)
                (areaCap_52 0)  (perimeterCap_52 0)
                (areaCap_53 0)  (perimeterCap_53 0)
                (areaCap_54 0)  (perimeterCap_54 0) )

                tempCap = techGetTwoLayerProp( techfile                   
                                               list( "metal5" "drawing" ) 
                                               list( "default" "drawing" )
                                               "areaCap" )                
                when( tempCap
                    areaCap_5D = 1.0e-18 * tempCap )


                tempCap = techGetTwoLayerProp( techfile                   
                                               list( "metal5" "drawing" ) 
                                               list( "default" "drawing" )
                                               "perimeterCap" )           
                when( tempCap
                    perimeterCap_5D = 1.0e-18 * tempCap )


                tempCap = techGetTwoLayerProp( techfile                  
                                               list( "metal5" "drawing" )
                                               list( "active" "drawing" )
                                               "areaCap" )               
                when( tempCap
                    areaCap_5A = 1.0e-18 * tempCap )


                tempCap = techGetTwoLayerProp( techfile                  
                                               list( "metal5" "drawing" )
                                               list( "active" "drawing" )
                                               "perimeterCap" )          
                when( tempCap
                    perimeterCap_5A = 1.0e-18 * tempCap )


                tempCap = techGetTwoLayerProp( techfile                  
                                               list( "metal5" "drawing" )
                                               list( "poly" "drawing" )  
                                               "areaCap" )               
                when( tempCap
                    areaCap_5P = 1.0e-18 * tempCap )


                tempCap = techGetTwoLayerProp( techfile                  
                                               list( "metal5" "drawing" )
                                               list( "poly" "drawing" )  
                                               "perimeterCap" )          
                when( tempCap
                    perimeterCap_5P = 1.0e-18 * tempCap )


                tempCap = techGetTwoLayerProp( techfile                  
                                               list( "metal5" "drawing" )
                                               list( "metal1" "drawing" )
                                               "areaCap" )               
                when( tempCap
                    areaCap_51 = 1.0e-18 * tempCap )


                tempCap = techGetTwoLayerProp( techfile                  
                                               list( "metal5" "drawing" )
                                               list( "metal1" "drawing" )
                                               "perimeterCap" )          
                when( tempCap
                    perimeterCap_51 = 1.0e-18 * tempCap )


                tempCap = techGetTwoLayerProp( techfile                  
                                               list( "metal5" "drawing" )
                                               list( "metal2" "drawing" )
                                               "areaCap" )               
                when( tempCap
                    areaCap_52 = 1.0e-18 * tempCap )


                tempCap = techGetTwoLayerProp( techfile                  
                                               list( "metal5" "drawing" )
                                               list( "metal2" "drawing" )
                                               "perimeterCap" )          
                when( tempCap
                    perimeterCap_52 = 1.0e-18 * tempCap )


                tempCap = techGetTwoLayerProp( techfile                  
                                               list( "metal5" "drawing" )
                                               list( "metal3" "drawing" )
                                               "areaCap" )               
                when( tempCap
                    areaCap_53 = 1.0e-18 * tempCap )


                tempCap = techGetTwoLayerProp( techfile                  
                                               list( "metal5" "drawing" )
                                               list( "metal3" "drawing" )
                                               "perimeterCap" )          
                when( tempCap
                    perimeterCap_53 = 1.0e-18 * tempCap )


                tempCap = techGetTwoLayerProp( techfile                  
                                               list( "metal5" "drawing" )
                                               list( "metal4" "drawing" )
                                               "areaCap" )               
                when( tempCap
                    areaCap_54 = 1.0e-18 * tempCap )


                tempCap = techGetTwoLayerProp( techfile                  
                                               list( "metal5" "drawing" )
                                               list( "metal4" "drawing" )
                                               "perimeterCap" )          
                when( tempCap
                    perimeterCap_54 = 1.0e-18 * tempCap )

				when( areaCap_5D && perimeterCap_5D && areaCap_5A && perimeterCap_5A &&
					  areaCap_5P && perimeterCap_5P && areaCap_51 && perimeterCap_51 &&
					  areaCap_52 && perimeterCap_52 && areaCap_53 && perimeterCap_53 &&
					  areaCap_54 && perimeterCap_54
                capacitance = multiLevelParasitic(
                                    layers( pBulk_ext nBulk_ext pNotOhmic_ext nNotOhmic_ext pOhmic_ext nOhmic_ext
                                            pDiff_ext nDiff_ext poly_ext
                                            metal1_ext metal2_ext metal3_ext metal4_ext metal5_ext )

                                    ; Metal5-Bulk Capacitances
                                    cap( pBulk_ext  metal5_ext  areaCap_5D  perimeterCap_5D  perimeterCap_5D  perimeterCap_5D )
                                    cap( nBulk_ext  metal5_ext  areaCap_5D  perimeterCap_5D  perimeterCap_5D  perimeterCap_5D )
                                    ; Metal5-Active Capacitances
                                    cap( pDiff_ext  metal5_ext  areaCap_5A  perimeterCap_5A  perimeterCap_5A  perimeterCap_5A )
                                    cap( nDiff_ext  metal5_ext  areaCap_5A  perimeterCap_5A  perimeterCap_5A  perimeterCap_5A )
                                    cap( pOhmic_ext  metal5_ext  areaCap_5A  perimeterCap_5A  perimeterCap_5A  perimeterCap_5A )
                                    cap( nOhmic_ext  metal5_ext  areaCap_5A  perimeterCap_5A  perimeterCap_5A  perimeterCap_5A )
                                    ; Metal5-Poly Capacitances
                                    cap( poly_ext  metal5_ext  areaCap_5P  perimeterCap_5P  perimeterCap_5P  perimeterCap_5P )
                                    ; Metal5-Metal1 Capacitances
                                    cap( metal1_ext  metal5_ext  areaCap_51  perimeterCap_51  perimeterCap_51  perimeterCap_51 )
                                    ; Metal5-Metal2 Capacitances
                                    cap( metal2_ext  metal5_ext  areaCap_52  perimeterCap_52  perimeterCap_52  perimeterCap_52 )
                                    ; Metal5-Metal3 Capacitances
                                    cap( metal3_ext  metal5_ext  areaCap_53  perimeterCap_53  perimeterCap_53  perimeterCap_53 )
                                    ; Metal5-Metal4 Capacitances
                                    cap( metal4_ext  metal5_ext  areaCap_54  perimeterCap_54  perimeterCap_54  perimeterCap_54 )

                                    ignore < NCSU_parasiticCapIgnoreThreshold )

                if( useCapIVPcell then
                    saveParasitic( capacitance "PLUS" "MINUS" "c" "cap ivpcell NCSU_Analog_Parts" )
                else
                    saveParasitic( capacitance "PLUS" "MINUS" "c" "pcapacitor ivpcell NCSU_Analog_Parts" )
                )
			) ; when( areaCap_5A
            ) /* let */

        ) /* metal5Available */



        ;--------------------------------------------------------------------------------
        ;
        ; Metal 4 Capacitances
        ;
        ;--------------------------------------------------------------------------------

        if( metal4Available then
            let( (  capacitance tempCap
                (areaCap_4D 0)  (perimeterCap_4D 0)
                (areaCap_4A 0)  (perimeterCap_4A 0)
                (areaCap_4P 0)  (perimeterCap_4P 0)
                (areaCap_41 0)  (perimeterCap_41 0)
                (areaCap_42 0)  (perimeterCap_42 0)
                (areaCap_43 0)  (perimeterCap_43 0) )

                tempCap = techGetTwoLayerProp( techfile                    
                                               list( "metal4" "drawing" ) 
                                               list( "default" "drawing" )
                                               "areaCap" )                
                when( tempCap
                    areaCap_4D = 1.0e-18 * tempCap ) 


                tempCap = techGetTwoLayerProp( techfile                    
                                               list( "metal4" "drawing" ) 
                                               list( "default" "drawing" )
                                               "perimeterCap" )           
                when( tempCap
                    perimeterCap_4D = 1.0e-18 * tempCap ) 
                                            

                tempCap = techGetTwoLayerProp( techfile                  
                                               list( "metal4" "drawing" )
                                               list( "active" "drawing" )
                                               "areaCap" )               
                when( tempCap
                    areaCap_4A = 1.0e-18 * tempCap )


                tempCap = techGetTwoLayerProp( techfile                  
                                               list( "metal4" "drawing" )
                                               list( "active" "drawing" )
                                               "perimeterCap" )          
                when( tempCap
                    perimeterCap_4A = 1.0e-18 * tempCap )


                tempCap = techGetTwoLayerProp( techfile                  
                                               list( "metal4" "drawing" )
                                               list( "poly" "drawing" )  
                                               "areaCap" )               
                when( tempCap
                    areaCap_4P = 1.0e-18 * tempCap )


                tempCap = techGetTwoLayerProp( techfile                  
                                               list( "metal4" "drawing" )
                                               list( "poly" "drawing" )  
                                               "perimeterCap" )          
                when( tempCap
                    perimeterCap_4P = 1.0e-18 * tempCap )


                tempCap = techGetTwoLayerProp( techfile                  
                                               list( "metal4" "drawing" )
                                               list( "metal1" "drawing" )
                                               "areaCap" )               
                when( tempCap
                    areaCap_41 = 1.0e-18 * tempCap )


                tempCap = techGetTwoLayerProp( techfile                  
                                               list( "metal4" "drawing" )
                                               list( "metal1" "drawing" )
                                               "perimeterCap" )          
                when( tempCap
                    perimeterCap_41 = 1.0e-18 * tempCap )


                tempCap = techGetTwoLayerProp( techfile                  
                                               list( "metal4" "drawing" )
                                               list( "metal2" "drawing" )
                                               "areaCap" )               
                when( tempCap
                    areaCap_42 = 1.0e-18 * tempCap )


                tempCap = techGetTwoLayerProp( techfile                  
                                               list( "metal4" "drawing" )
                                               list( "metal2" "drawing" )
                                               "perimeterCap" )          
                when( tempCap
                    perimeterCap_42 = 1.0e-18 * tempCap )


                tempCap = techGetTwoLayerProp( techfile                  
                                               list( "metal4" "drawing" )
                                               list( "metal3" "drawing" )
                                               "areaCap" )               
                when( tempCap
                    areaCap_43 = 1.0e-18 * tempCap )


                tempCap = techGetTwoLayerProp( techfile                  
                                               list( "metal4" "drawing" )
                                               list( "metal3" "drawing" )
                                               "perimeterCap" )          
                when( tempCap
                    perimeterCap_43 = 1.0e-18 * tempCap )
				
				when( areaCap_4D && perimeterCap_4D && areaCap_4A && perimeterCap_4A &&
					  areaCap_4P && perimeterCap_4P && areaCap_41 && perimeterCap_41 &&
					  areaCap_42 && perimeterCap_42 && areaCap_43 && perimeterCap_43
                capacitance = multiLevelParasitic(
                                    layers( pBulk_ext nBulk_ext pNotOhmic_ext nNotOhmic_ext pOhmic_ext nOhmic_ext
                                            pDiff_ext nDiff_ext poly_ext
                                            metal1_ext metal2_ext metal3_ext metal4_ext )

                                    ; Metal4-Bulk Capacitances
                                    cap( pBulk_ext  metal4_ext  areaCap_4D  perimeterCap_4D  perimeterCap_4D  perimeterCap_4D )
                                    cap( nBulk_ext  metal4_ext  areaCap_4D  perimeterCap_4D  perimeterCap_4D  perimeterCap_4D )
                                    ; Metal4-Active Capacitances
                                    cap( pDiff_ext  metal4_ext  areaCap_4A  perimeterCap_4A  perimeterCap_4A  perimeterCap_4A )
                                    cap( nDiff_ext  metal4_ext  areaCap_4A  perimeterCap_4A  perimeterCap_4A  perimeterCap_4A )
                                    cap( pOhmic_ext  metal4_ext  areaCap_4A  perimeterCap_4A  perimeterCap_4A  perimeterCap_4A )
                                    cap( nOhmic_ext  metal4_ext  areaCap_4A  perimeterCap_4A  perimeterCap_4A  perimeterCap_4A )
                                    ; Metal4-Poly Capacitances
                                    cap( poly_ext  metal4_ext  areaCap_4P  perimeterCap_4P  perimeterCap_4P  perimeterCap_4P )
                                    ; Metal4-Metal1 Capacitances
                                    cap( metal1_ext  metal4_ext  areaCap_41  perimeterCap_41  perimeterCap_41  perimeterCap_41 )
                                    ; Metal4-Metal2 Capacitances
                                    cap( metal2_ext  metal4_ext  areaCap_42  perimeterCap_42  perimeterCap_42  perimeterCap_42 )
                                    ; Metal4-Metal3 Capacitances
                                    cap( metal3_ext  metal4_ext  areaCap_43  perimeterCap_43  perimeterCap_43  perimeterCap_43 )

                                    ignore < NCSU_parasiticCapIgnoreThreshold )

                if( useCapIVPcell then
                    saveParasitic( capacitance "PLUS" "MINUS" "c" "cap ivpcell NCSU_Analog_Parts" )
                else
                    saveParasitic( capacitance "PLUS" "MINUS" "c" "pcapacitor ivpcell NCSU_Analog_Parts" )
                )
				) ; when( areaCap_4A

            ) /* let */

        ) /* metal4Available */



        ;--------------------------------------------------------------------------------
        ;
        ; Metal 3 Capacitances
        ;
        ;--------------------------------------------------------------------------------

        if( metal3Available then
            let( (  capacitance tempCap
                (areaCap_3D 0)  (perimeterCap_3D 0)
                (areaCap_3A 0)  (perimeterCap_3A 0)
                (areaCap_3P 0)  (perimeterCap_3P 0)
                (areaCap_31 0)  (perimeterCap_31 0)
                (areaCap_32 0)  (perimeterCap_32 0) )

                tempCap = techGetTwoLayerProp( techfile                   
                                               list( "metal3" "drawing" ) 
                                               list( "default" "drawing" )
                                               "areaCap" )                
                when( tempCap
                    areaCap_3D = 1.0e-18 * tempCap )


                tempCap = techGetTwoLayerProp( techfile                   
                                               list( "metal3" "drawing" ) 
                                               list( "default" "drawing" )
                                               "perimeterCap" )           
                when( tempCap
                    perimeterCap_3D = 1.0e-18 * tempCap )


                tempCap = techGetTwoLayerProp( techfile                  
                                               list( "metal3" "drawing" )
                                               list( "active" "drawing" )
                                               "areaCap" )               
                when( tempCap
                    areaCap_3A = 1.0e-18 * tempCap )


                tempCap = techGetTwoLayerProp( techfile                  
                                               list( "metal3" "drawing" )
                                               list( "active" "drawing" )
                                               "perimeterCap" )          
                when( tempCap
                    perimeterCap_3A = 1.0e-18 * tempCap )


                tempCap = techGetTwoLayerProp( techfile                  
                                               list( "metal3" "drawing" )
                                               list( "poly" "drawing" )  
                                               "areaCap" )               
                when( tempCap
                    areaCap_3P = 1.0e-18 * tempCap )


                tempCap = techGetTwoLayerProp( techfile                  
                                               list( "metal3" "drawing" )
                                               list( "poly" "drawing" )  
                                               "perimeterCap" )          
                when( tempCap
                    perimeterCap_3P = 1.0e-18 * tempCap )


                tempCap = techGetTwoLayerProp( techfile                  
                                               list( "metal3" "drawing" )
                                               list( "metal1" "drawing" )
                                               "areaCap" )               
                when( tempCap
                    areaCap_31 = 1.0e-18 * tempCap )


                tempCap = techGetTwoLayerProp( techfile                  
                                               list( "metal3" "drawing" )
                                               list( "metal1" "drawing" )
                                               "perimeterCap" )          
                when( tempCap
                    perimeterCap_31 = 1.0e-18 * tempCap )


                tempCap = techGetTwoLayerProp( techfile                  
                                               list( "metal3" "drawing" )
                                               list( "metal2" "drawing" )
                                               "areaCap" )               
                when( tempCap
                    areaCap_32 = 1.0e-18 * tempCap )


                tempCap = techGetTwoLayerProp( techfile                  
                                               list( "metal3" "drawing" )
                                               list( "metal2" "drawing" )
                                               "perimeterCap" )          
                when( tempCap
                    perimeterCap_32 = 1.0e-18 * tempCap )

				when( areaCap_3D && perimeterCap_3D && areaCap_3A && perimeterCap_3A &&
					  areaCap_3P && perimeterCap_3P && areaCap_31 && perimeterCap_31 &&
					  areaCap_32 && perimeterCap_32
                capacitance = multiLevelParasitic(
                                    layers( pBulk_ext nBulk_ext pNotOhmic_ext nNotOhmic_ext pOhmic_ext nOhmic_ext
                                            pDiff_ext nDiff_ext poly_ext
                                            metal1_ext metal2_ext metal3_ext )

                                    ; Metal3-Bulk Capacitances
                                    cap( pBulk_ext  metal3_ext  areaCap_3D  perimeterCap_3D  perimeterCap_3D  perimeterCap_3D )
                                    cap( nBulk_ext  metal3_ext  areaCap_3D  perimeterCap_3D  perimeterCap_3D  perimeterCap_3D )
                                    ; Metal3-Active Capacitances
                                    cap( pDiff_ext  metal3_ext  areaCap_3A  perimeterCap_3A  perimeterCap_3A  perimeterCap_3A )
                                    cap( nDiff_ext  metal3_ext  areaCap_3A  perimeterCap_3A  perimeterCap_3A  perimeterCap_3A )
                                    cap( pOhmic_ext  metal3_ext  areaCap_3A  perimeterCap_3A  perimeterCap_3A  perimeterCap_3A )
                                    cap( nOhmic_ext  metal3_ext  areaCap_3A  perimeterCap_3A  perimeterCap_3A  perimeterCap_3A )
                                    ; Metal3-Poly Capacitances
                                    cap( poly_ext  metal3_ext  areaCap_3P  perimeterCap_3P  perimeterCap_3P  perimeterCap_3P )
                                    ; Metal3-Metal1 Capacitances
                                    cap( metal1_ext  metal3_ext  areaCap_31  perimeterCap_31  perimeterCap_31  perimeterCap_31 )
                                    ; Metal3-Metal2 Capacitances
                                    cap( metal2_ext  metal3_ext  areaCap_32  perimeterCap_32  perimeterCap_32  perimeterCap_32 )

                                    ignore < NCSU_parasiticCapIgnoreThreshold )

                if( useCapIVPcell then
                    saveParasitic( capacitance "PLUS" "MINUS" "c" "cap ivpcell NCSU_Analog_Parts" )
                else
                    saveParasitic( capacitance "PLUS" "MINUS" "c" "pcapacitor ivpcell NCSU_Analog_Parts" )
                )
				); when( areaCap_3A
            ) /* let */

        ) /* metal3Available */



        ;--------------------------------------------------------------------------------
        ;
        ; Metal 2 Capacitances
        ;
        ;--------------------------------------------------------------------------------

        let( (  capacitance tempCap
            (areaCap_2D 0)  (perimeterCap_2D 0)
            (areaCap_2A 0)  (perimeterCap_2A 0)
            (areaCap_2P 0)  (perimeterCap_2P 0)
            (areaCap_21 0)  (perimeterCap_21 0) )

            tempCap = techGetTwoLayerProp( techfile                   
                                           list( "metal2" "drawing" ) 
                                           list( "default" "drawing" )
                                           "areaCap" )                
            when( tempCap
                areaCap_2D = 1.0e-18 * tempCap )


            tempCap = techGetTwoLayerProp( techfile                   
                                           list( "metal2" "drawing" ) 
                                           list( "default" "drawing" )
                                           "perimeterCap" )           
            when( tempCap
                perimeterCap_2D = 1.0e-18 * tempCap )


            tempCap = techGetTwoLayerProp( techfile                  
                                           list( "metal2" "drawing" )
                                           list( "active" "drawing" )
                                           "areaCap" )               
            when( tempCap
                areaCap_2A = 1.0e-18 * tempCap )


            tempCap = techGetTwoLayerProp( techfile                  
                                           list( "metal2" "drawing" )
                                           list( "active" "drawing" )
                                           "perimeterCap" )          
            when( tempCap
                perimeterCap_2A = 1.0e-18 * tempCap )


            tempCap = techGetTwoLayerProp( techfile                  
                                           list( "metal2" "drawing" )
                                           list( "poly" "drawing" )  
                                           "areaCap" )               
            when( tempCap
                areaCap_2P = 1.0e-18 * tempCap )


            tempCap = techGetTwoLayerProp( techfile                  
                                           list( "metal2" "drawing" )
                                           list( "poly" "drawing" )  
                                           "perimeterCap" )          
            when( tempCap
                perimeterCap_2P = 1.0e-18 * tempCap )


            tempCap = techGetTwoLayerProp( techfile                  
                                           list( "metal2" "drawing" )
                                           list( "metal1" "drawing" )
                                           "areaCap" )               
            when( tempCap
                areaCap_21 = 1.0e-18 * tempCap )


            tempCap = techGetTwoLayerProp( techfile                  
                                           list( "metal2" "drawing" )
                                           list( "metal1" "drawing" )
                                           "perimeterCap" )          
            when( tempCap
                perimeterCap_21 = 1.0e-18 * tempCap )

			when( areaCap_2D && perimeterCap_2D && areaCap_2A && perimeterCap_2A &&
				  areaCap_2P && perimeterCap_2P && areaCap_21 && perimeterCap_21
            capacitance = multiLevelParasitic(
                                layers( pBulk_ext nBulk_ext pNotOhmic_ext nNotOhmic_ext pOhmic_ext nOhmic_ext
                                        pDiff_ext nDiff_ext poly_ext
                                        metal1_ext metal2_ext )

                                ; Metal2-Bulk Capacitances
                                cap( pBulk_ext  metal2_ext  areaCap_2D  perimeterCap_2D  perimeterCap_2D  perimeterCap_2D )
                                cap( nBulk_ext  metal2_ext  areaCap_2D  perimeterCap_2D  perimeterCap_2D  perimeterCap_2D )
                                ; Metal2-Active Capacitances
                                cap( pDiff_ext  metal2_ext  areaCap_2A  perimeterCap_2A  perimeterCap_2A  perimeterCap_2A )
                                cap( nDiff_ext  metal2_ext  areaCap_2A  perimeterCap_2A  perimeterCap_2A  perimeterCap_2A )
                                cap( pOhmic_ext  metal2_ext  areaCap_2A  perimeterCap_2A  perimeterCap_2A  perimeterCap_2A )
                                cap( nOhmic_ext  metal2_ext  areaCap_2A  perimeterCap_2A  perimeterCap_2A  perimeterCap_2A )
                                ; Metal2-Poly Capacitances
                                cap( poly_ext  metal2_ext  areaCap_2P  perimeterCap_2P  perimeterCap_2P  perimeterCap_2P )
                                ; Metal2-Metal1 Capacitances
                                cap( metal1_ext  metal2_ext  areaCap_21  perimeterCap_21 perimeterCap_21 perimeterCap_21 )

                                ignore < NCSU_parasiticCapIgnoreThreshold )

            if( useCapIVPcell then
                saveParasitic( capacitance "PLUS" "MINUS" "c" "cap ivpcell NCSU_Analog_Parts" )
            else
                saveParasitic( capacitance "PLUS" "MINUS" "c" "pcapacitor ivpcell NCSU_Analog_Parts" )
            )
			);when( areaCap_2A
        ) /* let */

        /*
         * separate check for elec option 
         */

        if( elecAvailable then
            let( (  capacitance tempCap
                areaCap_2E perimeterCap_2E )

                tempCap = techGetTwoLayerProp( techfile                  
                                               list( "metal2" "drawing" )
                                               list( "elec" "drawing" )  
                                               "areaCap" )               
                when( tempCap
                    areaCap_2E = 1.0e-18 * tempCap )


                tempCap = techGetTwoLayerProp( techfile                  
                                               list( "metal2" "drawing" )
                                               list( "elec" "drawing" )  
                                               "perimeterCap" )          
                when( tempCap
                    perimeterCap_2E = 1.0e-18 * tempCap )

				when( areaCap_2E && perimeterCap_2E
                	capacitance = multiLevelParasitic(
                                    layers( pBulk_ext nBulk_ext pNotOhmic_ext nNotOhmic_ext pOhmic_ext nOhmic_ext
                                            pDiff_ext nDiff_ext poly_ext
                                            elec_ext metal1_ext metal2_ext )

                                    ; Metal2-Elec Capacitances
                                    cap( elec_ext  metal2_ext  areaCap_2E  perimeterCap_2E  perimeterCap_2E  perimeterCap_2E )
                                    cap( elec_ext  metal2_ext  areaCap_2E  perimeterCap_2E  perimeterCap_2E  perimeterCap_2E )

                                    ignore < NCSU_parasiticCapIgnoreThreshold )

                	if( useCapIVPcell then
                    	saveParasitic( capacitance "PLUS" "MINUS" "c" "cap ivpcell NCSU_Analog_Parts" )
                	else
                    	saveParasitic( capacitance "PLUS" "MINUS" "c" "pcapacitor ivpcell NCSU_Analog_Parts" )
                	)
				) ; when( areaCap_2E
            ) /* let */

        ) /* elecAvailable */



        ;--------------------------------------------------------------------------------
        ;
        ; Metal 1 Capacitances
        ;
        ;--------------------------------------------------------------------------------

        let( (  capacitance tempCap
            (areaCap_1D 0)  (perimeterCap_1D 0)
            (areaCap_1A 0)  (perimeterCap_1A 0)
            (areaCap_1P 0)  (perimeterCap_1P 0) )

            tempCap = techGetTwoLayerProp( techfile
                                           list( "metal1" "drawing" )
                                           list( "default" "drawing" )
                                           "areaCap" )
            when( tempCap
                areaCap_1D = 1.0e-18 * tempCap )


            tempCap = techGetTwoLayerProp( techfile                   
                                           list( "metal1" "drawing" ) 
                                           list( "default" "drawing" )
                                           "perimeterCap" )           
            when( tempCap
                perimeterCap_1D = 1.0e-18 * tempCap )


            tempCap = techGetTwoLayerProp( techfile                  
                                           list( "metal1" "drawing" )
                                           list( "active" "drawing" )
                                           "areaCap" )               
            when( tempCap
                areaCap_1A = 1.0e-18 * tempCap )


            tempCap = techGetTwoLayerProp( techfile                  
                                           list( "metal1" "drawing" )
                                           list( "active" "drawing" )
                                           "perimeterCap" )          
            when( tempCap
                perimeterCap_1A = 1.0e-18 * tempCap )


            tempCap = techGetTwoLayerProp( techfile                  
                                           list( "metal1" "drawing" )
                                           list( "poly" "drawing" )  
                                           "areaCap" )               
            when( tempCap
                areaCap_1P = 1.0e-18 * tempCap )


            tempCap = techGetTwoLayerProp( techfile                  
                                           list( "metal1" "drawing" )
                                           list( "poly" "drawing" )  
                                           "perimeterCap" )          
            when( tempCap
                perimeterCap_1P = 1.0e-18 * tempCap )

			when( areaCap_1D && perimeterCap_1D && areaCap_1A && perimeterCap_1A &&
				  areaCap_1P && perimeterCap_1P
            capacitance = multiLevelParasitic(
                                layers( pBulk_ext nBulk_ext pNotOhmic_ext nNotOhmic_ext pOhmic_ext nOhmic_ext
                                        pDiff_ext nDiff_ext poly_ext
                                        metal1_ext )

                                ; Metal1-Bulk Capacitances
                                cap( pBulk_ext  metal1_ext  areaCap_1D  perimeterCap_1D  perimeterCap_1D  perimeterCap_1D )
                                cap( nBulk_ext  metal1_ext  areaCap_1D  perimeterCap_1D  perimeterCap_1D  perimeterCap_1D )
                                ; Metal1-Active Capacitances
                                cap( pDiff_ext  metal1_ext  areaCap_1A  perimeterCap_1A  perimeterCap_1A  perimeterCap_1A )
                                cap( nDiff_ext  metal1_ext  areaCap_1A  perimeterCap_1A  perimeterCap_1A  perimeterCap_1A )
                                cap( pOhmic_ext  metal1_ext  areaCap_1A  perimeterCap_1A  perimeterCap_1A  perimeterCap_1A )
                                cap( nOhmic_ext  metal1_ext  areaCap_1A  perimeterCap_1A  perimeterCap_1A  perimeterCap_1A )
                                ; Metal1-Poly Capacitances
                                cap( poly_ext  metal1_ext  areaCap_1P  perimeterCap_1P  perimeterCap_1P  perimeterCap_1P )

                                ignore < NCSU_parasiticCapIgnoreThreshold )

            if( useCapIVPcell then
                saveParasitic( capacitance "PLUS" "MINUS" "c" "cap ivpcell NCSU_Analog_Parts" )
            else
                saveParasitic( capacitance "PLUS" "MINUS" "c" "pcapacitor ivpcell NCSU_Analog_Parts" )
            )
			); when( areaCap_1A
        ) /* let */

        /*
         * separate check for elec option 
         */

        if( elecAvailable then
            let( (  capacitance tempCap
                areaCap_1E perimeterCap_1E  )

                tempCap = techGetTwoLayerProp( techfile                  
                                               list( "metal1" "drawing" )
                                               list( "elec" "drawing" )  
                                               "areaCap" )               
                when( tempCap
                    areaCap_1E = 1.0e-18 * tempCap )


                tempCap = techGetTwoLayerProp( techfile                  
                                               list( "metal1" "drawing" )
                                               list( "elec" "drawing" )  
                                               "perimeterCap" )          
                when( tempCap
                    perimeterCap_1E = 1.0e-18 * tempCap )

				when( areaCap_1E && perimeterCap_1E
                	capacitance = multiLevelParasitic(
                                    layers( pBulk_ext nBulk_ext pNotOhmic_ext nNotOhmic_ext pOhmic_ext nOhmic_ext
                                            pDiff_ext nDiff_ext poly_ext
                                            elec_ext metal1_ext )

                                    ; Metal1-Elec Capacitances
                                    cap( elec_ext  metal1_ext  areaCap_1E  perimeterCap_1E  perimeterCap_1E  perimeterCap_1E )
                                    cap( elec_ext  metal1_ext  areaCap_1E  perimeterCap_1E  perimeterCap_1E  perimeterCap_1E )

                                    ignore < NCSU_parasiticCapIgnoreThreshold )

                	if( useCapIVPcell then
                    	saveParasitic( capacitance "PLUS" "MINUS" "c" "cap ivpcell NCSU_Analog_Parts" )
                	else
                    	saveParasitic( capacitance "PLUS" "MINUS" "c" "pcapacitor ivpcell NCSU_Analog_Parts" )
                	)
				) ;when( areaCap_1E
            ) /* let */

        ) /* elecAvailable */



        ;--------------------------------------------------------------------------------
        ;
        ; Elec Capacitances
        ;
        ;--------------------------------------------------------------------------------


        if( elecAvailable then
            let( (  capacitance tempCap
                areaCap_ED perimeterCap_ED
                (areaCap_EA 0)  (perimeterCap_EA 0)
                (areaCap_EP 0)  (perimeterCap_EP 0) )

                tempCap = techGetTwoLayerProp( techfile                   
                                               list( "elec" "drawing" )   
                                               list( "default" "drawing" )
                                               "areaCap" )                
                when( tempCap
                    areaCap_ED = 1.0e-18 * tempCap )


                tempCap = techGetTwoLayerProp( techfile                   
                                               list( "elec" "drawing" )   
                                               list( "default" "drawing" )
                                               "perimeterCap" )           
                when( tempCap
                    perimeterCap_ED = 1.0e-18 * tempCap )

				when( areaCap_ED && perimeterCap_ED
                	capacitance = multiLevelParasitic(
                                    layers( pBulk_ext nBulk_ext pNotOhmic_ext nNotOhmic_ext pOhmic_ext nOhmic_ext
                                            pDiff_ext nDiff_ext poly_ext
                                            elec_ext )

                                    ; Elec-Bulk Capacitances
                                    cap( pBulk_ext  elec_ext  areaCap_ED  perimeterCap_ED  perimeterCap_ED  perimeterCap_ED )
                                    cap( nBulk_ext  elec_ext  areaCap_ED  perimeterCap_ED  perimeterCap_ED  perimeterCap_ED )

                                    ignore < NCSU_parasiticCapIgnoreThreshold )

                	if( useCapIVPcell then
                    	saveParasitic( capacitance "PLUS" "MINUS" "c" "cap ivpcell NCSU_Analog_Parts" )
                	else
                    	saveParasitic( capacitance "PLUS" "MINUS" "c" "pcapacitor ivpcell NCSU_Analog_Parts" )
                	)
				); when( areaCap_ED
            ) /* let */

        ) /* elecAvailable */



        ;--------------------------------------------------------------------------------
        ;
        ; Poly Capacitances
        ;
        ;--------------------------------------------------------------------------------


        let( (  capacitance tempCap
            (areaCap_PD 0)  (perimeterCap_PD 0) )

            tempCap = techGetTwoLayerProp( techfile
                                           list( "poly" "drawing" )
                                           list( "default" "drawing" )
                                           "areaCap" )
            when( tempCap
                areaCap_PD = 1.0e-18 * tempCap )


            tempCap = techGetTwoLayerProp( techfile
                                           list( "poly" "drawing" )
                                           list( "default" "drawing" )
                                           "perimeterCap" )
            when( tempCap
                perimeterCap_PD = 1.0e-18 * tempCap )

			when( areaCap_PD && perimeterCap_PD
            capacitance = multiLevelParasitic(
                                layers( pBulk_ext nBulk_ext pNotOhmic_ext nNotOhmic_ext pOhmic_ext nOhmic_ext
                                        pDiff_ext nDiff_ext poly_ext )

                                ; Poly-Bulk Capacitances
                                cap( pBulk_ext  poly_ext  areaCap_PD  perimeterCap_PD  perimeterCap_PD  perimeterCap_PD )
                                cap( nBulk_ext  poly_ext  areaCap_PD  perimeterCap_PD  perimeterCap_PD  perimeterCap_PD )

                                ignore < NCSU_parasiticCapIgnoreThreshold )

            if( useCapIVPcell then
                saveParasitic( capacitance "PLUS" "MINUS" "c" "cap ivpcell NCSU_Analog_Parts" )
            else
                saveParasitic( capacitance "PLUS" "MINUS" "c" "pcapacitor ivpcell NCSU_Analog_Parts" )
            )
			) ; when( areaCap_PD
        ) /* let */



; vim:ts=4:columns=132:set tw=0:
