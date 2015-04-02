;==========================================================================
;
; $Id: divaLayerDef.il,v 1.2 2006/02/10 19:00:40 slipa Exp $
; 
;--------------------------------------------------------------------------

/********************************************************************************
 *                                                                              *
 *                                                                              *
 *                        Diva Derived Layer Definitions                        *
 *                                                                              *
 *                                                                              *
 ********************************************************************************/


    /* 
     * Note that some of these variables are set here and some are set
     * above. The ones below are set here because any variable with the
     * value nil becomes unbound when you enter the drcExtractRules()
     * function. Some have to be set above because functions like
     * error() can't be called inside drcExtractRules(). Weird. 
     */

    wellType = substring( NCSU_techData[ techdesc ]->mosisCode 3 1 )
    submicronAvailable = NCSU_techData[ techdesc ]->submicronRules
    deepAvailable = NCSU_techData[ techdesc ]->deepRules
    stackedViasAvailable = NCSU_techData[ techdesc ]->stackedVias
    lambda = atof( NCSU_techData[ techdesc ]->lambda )
    gridRes = NCSU_techData[ techdesc ]->gridRes
    modelPrefix = NCSU_techData[ techdesc ]->fetModelPrefix 

    /*
     * we can't use getTechParam here, so do it another way.
     * i know, this is a major kludge...
     */

    techfile = techGetTechFile( geGetEditCellView() )
    cwellAvailable    = techGetLayerNum( techfile "cwell" )
    polycapAvailable  = techGetLayerNum( techfile "polycap" )
    npnAvailable      = techGetLayerNum( techfile "pbase" )
    ccdAvailable      = techGetLayerNum( techfile "ccd" )
    metal3Available   = techGetLayerNum( techfile "metal3" )
    metal4Available   = techGetLayerNum( techfile "metal4" )
    metal5Available   = techGetLayerNum( techfile "metal5" )
    metal6Available   = techGetLayerNum( techfile "metal6" )
    metalcapAvailable = techGetLayerNum( techfile "metalcap" )
    hvAvailable       = techGetLayerNum( techfile "tactive" )
    elecAvailable     = techGetLayerNum( techfile "elec" )
    memsAvailable     = techGetLayerNum( techfile "pstop" )
    sblockAvailable   = techGetLayerNum( techfile "sblock" )
    highresAvailable  = techGetLayerNum( techfile "highres" )

    /***************************
     ***************************

     DERIVED LAYER DEFINITIONS

     ***************************
     ***************************/


    ivIf( switch("drc?") then
        nodrc   = geomOr( "nodrc" )
    )

    ivIf( switch("extract?") then
       ; nodrc   = geomAndNot( "nodrc" "nodrc" )
         nodrc   = geomEmpty()  ;changed from above because
                                ;5.10.41_USR3.27.30 complained
                                ;about duplicate layers....
                                ;slipa 1.5.0rc2 2006-02-10
    )


    bkgnd   = geomBkgnd()
    gwell   = geomOr( geomAndNot( ( "gwell" "drawing" ) nodrc )   )
    nwell   = geomOr( geomAndNot( ( "nwell" "drawing" ) nodrc )   )
    pwell   = geomOr( geomAndNot( ( "pwell" "drawing" ) nodrc )   )
    nactive = geomOr( geomAndNot( ( "nactive" "drawing" ) nodrc ) )
    pactive = geomOr( geomAndNot( ( "pactive" "drawing" ) nodrc ) )
    active  = geomOr( geomAndNot( ( "active" "drawing" ) nodrc ) nactive pactive )
    gselect = geomOr( geomAndNot( ( "gselect" "drawing" ) nodrc ) )
    nselect = geomOr( geomAndNot( ( "nselect" "drawing" ) nodrc ) )
    pselect = geomOr( geomAndNot( ( "pselect" "drawing" ) nodrc ) )
    poly    = geomOr( geomAndNot( ( "poly" "drawing" ) nodrc )    )
    metal1  = geomOr( geomAndNot( ( "metal1" "drawing" ) nodrc )  )
    cc      = geomOr( geomAndNot( ( "cc" "drawing" ) nodrc )      )
    metal2  = geomOr( geomAndNot( ( "metal2" "drawing" ) nodrc )  )
    via     = geomOr( geomAndNot( ( "via" "drawing" ) nodrc )     )
    glass   = geomOr( geomAndNot( ( "glass" "drawing" ) nodrc )   )
    pad     = geomOr( geomAndNot( ( "pad" "drawing" ) nodrc )     )
    nolpe   = geomOr( "nolpe"   )
    cap_id  = geomOr( "cap_id"  )
    res_id  = geomOr( "res_id"  )
    dio_id  = geomOr( "dio_id"  )
    if( metal3Available then
        metal3 = geomOr( geomAndNot( ( "metal3" "drawing" ) nodrc ) )
        via2   = geomOr( geomAndNot( ( "via2" "drawing" ) nodrc )   )
    )
    if( metal4Available then
        metal4 = geomOr( geomAndNot( ( "metal4" "drawing" ) nodrc ) )
        via3   = geomOr( geomAndNot( ( "via3" "drawing" ) nodrc )   )
    )
    if( metal5Available then
        metal5 = geomOr( geomAndNot( ( "metal5" "drawing" ) nodrc ) )
        via4   = geomOr( geomAndNot( ( "via4" "drawing" ) nodrc )   )
    )
    if( metal6Available then
        metal6 = geomOr( geomAndNot( ( "metal6" "drawing" ) nodrc ) )
        via5   = geomOr( geomAndNot( ( "via5" "drawing" ) nodrc )   )
    )
    if( metalcapAvailable then
        metalcap = geomOr( geomAndNot( ( "metalcap" "drawing" ) nodrc ) )
    )
    if( ccdAvailable then
        ccd = geomOr( geomAndNot( ( "ccd" "drawing" ) nodrc ) )
    )
    if( cwellAvailable then
        cwell = geomOr( geomAndNot( ( "cwell" "drawing" ) nodrc ) )
    )
    if( polycapAvailable then
        polycap  = geomOr( geomAndNot( ( "polycap" "drawing" ) nodrc ) )
        cpolycap = geomAnd( polycap geomOr( cc cp ) )
    )
    if( sblockAvailable then
        sblock  = geomOr( geomAndNot( ( "sblock" "drawing" ) nodrc ) )
    )
    if( highresAvailable then
        highres = geomOr( geomAndNot( ( "highres" "drawing" ) nodrc ) )
    )
    if( memsAvailable then
        pstop = geomOr( geomAndNot( ( "pstop" "drawing" ) nodrc ) )
        open = geomOr( geomAndNot( ( "open" "drawing" ) nodrc ) )
    )
    /* 
     * deriving specific contacts (ie, ce, cp, ca) from generic contact (cc) is a pain.
     * make sure you account for multiple overlaps, eg, in case of poly-elec cap, suppose you use
     * cc for the elec contact. this needs to be extracted as "ce" only, not "cp".
     *
     * the order of the rules below is important - ie, it goes top-down (elec -> poly -> active).
     */
    if( elecAvailable then
        elec = geomOr( geomAndNot( ( "elec" "drawing" ) nodrc ) )
        ce   = geomOr( geomOr( geomAndNot( ( "ce" "drawing" ) nodrc ) ) geomAnd( cc elec ) )
        cp   = geomOr( geomOr( geomAndNot( ( "cp" "drawing" ) nodrc ) ) geomAnd( cc geomAndNot( poly ce ) ) )
        ca   = geomOr( geomOr( geomAndNot( ( "ca" "drawing" ) nodrc ) ) geomAnd( cc geomAndNot( active geomOr( ce cp ) ) ) )
    else
        cp   = geomOr( geomOr( geomAndNot( ( "cp" "drawing" ) nodrc ) ) geomAnd( cc poly ) )
        ca   = geomOr( geomOr( geomAndNot( ( "ca" "drawing" ) nodrc ) ) geomAnd( cc geomAndNot( active cp ) ) )
    )
    if( npnAvailable then
        pbase = geomOr( geomAndNot( ( "pbase" "drawing" ) nodrc ) )
        cactive = geomOr( geomAndNot( ( "cactive" "drawing" ) nodrc ) )
        ca = geomOr( ca geomAnd( cc cactive ) )
    )

    nActive = geomAnd( active nselect )
    pActive = geomAnd( active pselect )
    if( ccdAvailable then
        nActive = geomAndNot( nActive ccd )
        pActive = geomAndNot( pActive ccd )
    )
    if( cwellAvailable then
        nActive = geomAndNot( nActive cwell )
        pActive = geomAndNot( pActive cwell )
    )
    if( hvAvailable then
        tactive = geomOr( geomAndNot( ( "tactive" "drawing" ) nodrc ) )
    )

    /*
     * This next section basically sets how the well enclosure of
     * source/drain active, substrate/well contact and capacitor
     * electrode are interpreted. In a pwell process, everything that
     * doesn't have the "pwell" layer drawn on it is assumed to be
     * N-type bulk. Similarly, in an nwell process, everything that
     * doesn't have the "nwell" layer drawn on it is assumed to be
     * P-type bulk. If it's an "either-well" process, only the areas
     * with drawn "pwell" and "nwell" are assumed to be P-type bulk or
     * N-type bulk, respectively.
     *
     * Since MOSIS only has N-type processes for now, this is assumed to
     * be the default.
     */

    case( wellType
        ( "P"
            nBulk = geomOr( geomNot( pwell ) geomAndNot( nwell pwell ) )
            pBulk = geomOr( pwell )
            nOhmic = geomAndNot( nActive pwell )
            pOhmic = geomAnd( pActive pwell )
            nNotOhmic = geomAnd( nActive pwell )
            pNotOhmic = geomAndNot( pActive pwell)
        )
        ( "E"
            nBulk = geomOr( nwell )
            pBulk = geomOr( pwell )
            nOhmic = geomAnd( nActive nwell )
            pOhmic = geomAnd( pActive pwell )
            nNotOhmic = geomAnd( nActive pwell )
            pNotOhmic = geomAnd( pActive nwell)
        )
        ( t
            if( npnAvailable then
                nBulk = geomOutside( nwell cactive )
            else
                nBulk = geomOr( nwell )
            )
            pBulk = geomOr( geomNot( nwell ) geomAndNot( pwell nwell ) )
            nOhmic = geomAnd( nActive nwell )
            pOhmic = geomAndNot( pActive nwell )
            nNotOhmic = geomAndNot( nActive nwell )
            pNotOhmic = geomAnd( pActive nwell)
        )
    )

    if( elecAvailable then
        nDiff = geomAndNot( nNotOhmic geomOr( poly elec ) )
        pDiff = geomAndNot( pNotOhmic geomOr( poly elec ) )
        nChannel = geomOutside( geomAnd( nNotOhmic poly ) elec )
        pChannel = geomOutside( geomAnd( pNotOhmic poly ) elec )
        nElecChannel = geomOutside( geomAnd( nNotOhmic elec ) poly )
        pElecChannel = geomOutside( geomAnd( pNotOhmic elec ) poly )
        nElecChannelTran = geomButting( nElecChannel nDiff keep == 2 )
        pElecChannelTran = geomButting( pElecChannel pDiff keep == 2 )
        nElecChannelCap = geomButting( nElecChannel nDiff keep == 1 )
        pElecChannelCap = geomButting( pElecChannel pDiff keep == 1 )
        Space = geomNot( geomOr( active poly elec ) )
    else
        nDiff = geomAndNot( nNotOhmic poly )
        pDiff = geomAndNot( pNotOhmic poly )
        nChannel = geomAnd( nNotOhmic poly )
        pChannel = geomAnd( pNotOhmic poly )
        Space = geomNot( geomOr( active poly ) ) 
    )
    nChannelTran = geomButting( nChannel nDiff keep == 2 )
    pChannelTran = geomButting( pChannel pDiff keep == 2 )
    nChannelCap = geomButting( nChannel nDiff keep == 1 )
    pChannelCap = geomButting( pChannel pDiff keep == 1 )
    if( hvAvailable then
        hvnChannelTran = geomAnd( nChannelTran tactive )
        nChannelTran = geomAndNot( nChannelTran hvnChannelTran )
        hvpChannelTran = geomAnd( pChannelTran tactive )
        pChannelTran = geomAndNot( pChannelTran hvpChannelTran )
    )

    nDiffContact   = geomAnd( ca nDiff )
    pDiffContact   = geomAnd( ca pDiff )
    nOhmicContact  = geomAnd( ca nOhmic )
    pOhmicContact  = geomAnd( ca pOhmic )
    Gate           = geomAnd( geomOr( nNotOhmic pNotOhmic) poly )
    fieldPoly      = geomAvoiding( poly Gate )
    m1pCap         = geomAnd( geomAnd( poly metal1 ) cap_id )
    m1sCap         = geomAnd( geomAndNot( metal1 poly ) cap_id )
    m2m1Cap        = geomAnd( geomAnd( metal1 metal2 ) cap_id )
    if( metal3Available then
        m3m2Cap        = geomAnd( geomAnd( metal2 metal3 ) cap_id )
    )
    if( metal4Available then
        m4m3Cap        = geomAnd( geomAnd( metal3 metal4 ) cap_id )
    )
    if( metal5Available then
        m5m4Cap        = geomAnd( geomAnd( metal4 metal5 ) cap_id )
    )
    if( metal6Available then
        m6m5Cap        = geomAnd( geomAnd( metal5 metal6 ) cap_id )
    )
    if( metalcapAvailable then
        /*
         * metalcap is between top-layer metal and next-to-top layer metal. for
         * drc, we need the whole metal shape of the bottom plate, not just the
         * metal-metalcap overlap.
         */
        cond( 
            ( metal6Available
                metalcapBottom = geomStraddle( metal5 metalcap )
                metalcapCap = geomAnd( metalcap metal5 )
                via5metalcap = geomAnd( via5 metalcapBottom )
                via5 = geomAndNot( via5 via5metalcap )
            )
            ( metal5Available
                metalcapBottom = geomStraddle( metal4 metalcap )
                metalcapCap = geomAnd( metalcap metal4 )
                via4metalcap = geomAnd( via4 metalcapBottom )
                via4 = geomAndNot( via4 via4metalcap )
            )
        )
    )
    NPdiode = geomAnd( dio_id geomOutside( nNotOhmic poly ) )
    PNdiode = geomAnd( dio_id geomOutside( pNotOhmic poly ) )
    unless( wellType == "P" || wellType == "E"
        NwPdiode = geomAnd( dio_id geomOutside( nwell pNotOhmic ) )
    )
    if( elecAvailable then
        elecGate       = geomAnd( geomOr( nNotOhmic pNotOhmic) elec )
        fieldElec      = geomAvoiding( elec elecGate )
        CapacitorElec  = geomInside( elec poly )
        TransistorElec = geomOverlap( elec geomNot( poly ) )
    )
    if( polycapAvailable then
        polycapCap = geomAnd( poly polycap )
    )
    if( sblockAvailable then
        sGateWidthCheck = geomSize( geomSize( geomAnd( Gate sblock ) -2.9 ) 2.9 )
    )
    if( npnAvailable then
        npnCollector        = geomAnd( nwell geomAnd( nselect cactive ) )
        npnCollectorContact = geomAnd( ca npnCollector )
        npnBaseImplant      = geomAnd( nwell pbase )
        npnEmitter          = geomAnd( nselect npnBaseImplant )
        npnBase             = geomAndNot( npnBaseImplant npnEmitter )
        npnBaseTap          = geomAnd( npnBase pselect )
        npnBaseContact      = geomAnd( geomOr( cc ca ) npnBaseTap )
        npnEmitterContact   = geomAnd( geomOr( cc ca ) npnEmitter )
        npnTran             = geomEnclose( nwell geomOr( npnCollector npnBase npnEmitter ) )
    )
    if( ccdAvailable then
        ccdDiff           = geomAnd( active ccd )
        ccdContact        = geomAnd( ca ccdDiff )
    )
    if( cwellAvailable then
        ; since the extractDevice for cwell caps uses "lcDiff" as negative
        ; terminal, and all caps in a single cwell need to have a common neg.
        ; term (the cwell itself) use the cwell as the lcDiff layer. the lcCap
        ; ANDs it with active & poly to get shape for calculating capacitance.
        lcDiff         = geomStraddle( cwell active )
        lcContact      = geomAnd( ca lcDiff )
        lcCap          = geomAnd( poly geomAnd( lcDiff active ) )
    )

    ; recognize resistors: res_id/(poly|elec), sblock/poly, highres/elec, nwell/res_id

    ; res_id/poly, sblock/poly
    if( sblockAvailable then
        fieldPoly = geomAndNot( fieldPoly geomOr( sblock res_id ) )
        polySRes = geomButting( geomAnd( sblock poly ) fieldPoly keep == 2 )
        polyRes = geomButting( geomAndNot( geomAnd( res_id poly ) polySRes ) fieldPoly keep == 2 )
        poly = geomAndNot( poly geomOr( sblock res_id ) )
    else
        fieldPoly = geomAndNot( fieldPoly res_id )
        polyRes = geomButting( geomAnd( res_id poly ) fieldPoly keep == 2 )
        poly = geomAndNot( poly res_id )
    )

    ; res_id/elec
    if( elecAvailable then
        ; currently can only do highres over elec (poly2)
        if( highresAvailable then
            fieldElec = geomAndNot( fieldElec geomOr( res_id highres ) )
            elecRes = geomButting( geomAnd( res_id elec ) fieldElec keep == 2 )
            elecHighres = geomButting( geomAnd( highres elec ) fieldElec keep == 2 )
            elec = geomAndNot( elec geomOr( res_id highres ) )
        else
            fieldElec = geomAndNot( fieldElec res_id )
            elecRes = geomButting( geomAnd( res_id elec ) fieldElec keep == 2 )
            elec = geomAndNot( elec res_id )
        )
    )

    ; res_id/nwell
    nBulk = geomAndNot( nBulk res_id )
    nwellRes = geomButting( geomAnd( res_id nwell ) nBulk keep == 2 )
    nwell = geomAndNot( nwell res_id ) ; w/o this, whole well is connected 

    cond( 
        ( metal6Available
            if( metalcapAvailable then
                geomConnect( via( nOhmicContact nOhmic nwell nBulk metal1 )
                             via( pOhmicContact pOhmic pwell pBulk metal1 )
                             via( nDiffContact nDiff metal1 )
                             via( pDiffContact pDiff metal1 )
                             via( cp poly metal1 )
                             via( via metal1 metal2 )
                             via( via2 metal2 metal3 )
                             via( via3 metal3 metal4 )
                             via( via4 metal4 metal5 )
                             via( via5 metal5 metal6 )
                             via( via5metalcap metalcap metal6 )
                             label( "text" metal6 metalcap metal5 metal4 metal3 metal2 metal1 poly pDiff nDiff )
                )
            else
                geomConnect( via( nOhmicContact nOhmic nwell nBulk metal1 )
                             via( pOhmicContact pOhmic pwell pBulk metal1 )
                             via( nDiffContact nDiff metal1 )
                             via( pDiffContact pDiff metal1 )
                             via( cp poly metal1 )
                             via( via metal1 metal2 )
                             via( via2 metal2 metal3 )
                             via( via3 metal3 metal4 )
                             via( via4 metal4 metal5 )
                             via( via5 metal5 metal6 )
                             label( "text" metal6 metal5 metal4 metal3 metal2 metal1 poly pDiff nDiff )
                )
            )
        )
        ( metal5Available
            if( metalcapAvailable then
                geomConnect( via( nOhmicContact nOhmic nwell nBulk metal1 )
                             via( pOhmicContact pOhmic pwell pBulk metal1 )
                             via( nDiffContact nDiff metal1 )
                             via( pDiffContact pDiff metal1 )
                             via( cp poly metal1 )
                             via( via metal1 metal2 )
                             via( via2 metal2 metal3 )
                             via( via3 metal3 metal4 )
                             via( via4 metal4 metal5 )
                             via( via4metalcap metalcap metal5 )
                             label( "text" metal5 metalcap metal4 metal3 metal2 metal1 poly pDiff nDiff )
                )
            else
                geomConnect( via( nOhmicContact nOhmic nwell nBulk metal1 )
                             via( pOhmicContact pOhmic pwell pBulk metal1 )
                             via( nDiffContact nDiff metal1 )
                             via( pDiffContact pDiff metal1 )
                             via( cp poly metal1 )
                             via( via metal1 metal2 )
                             via( via2 metal2 metal3 )
                             via( via3 metal3 metal4 )
                             via( via4 metal4 metal5 )
                             label( "text" metal5 metal4 metal3 metal2 metal1 poly pDiff nDiff )
                )
            )
        )
        ( metal4Available
            if( elecAvailable then
                geomConnect( via( nOhmicContact nOhmic nwell nBulk metal1 )
                             via( pOhmicContact pOhmic pwell pBulk metal1 )
                             via( nDiffContact nDiff metal1 )
                             via( pDiffContact pDiff metal1 )
                             via( cp poly metal1 )
                             via( ce elec metal1 )
                             via( via metal1 metal2 )
                             via( via2 metal2 metal3 )
                             via( via3 metal3 metal4 )
                             label( "text" metal4 metal3 metal2 metal1 elec poly pDiff nDiff )
                )
            else
                geomConnect( via( nOhmicContact nOhmic nwell nBulk metal1 )
                             via( pOhmicContact pOhmic pwell pBulk metal1 )
                             via( nDiffContact nDiff metal1 )
                             via( pDiffContact pDiff metal1 )
                             via( cp poly metal1 )
                             via( via metal1 metal2 )
                             via( via2 metal2 metal3 )
                             via( via3 metal3 metal4 )
                             label( "text" metal4 metal3 metal2 metal1 poly pDiff nDiff )
                )
            )
        )
        ( metal3Available && cwellAvailable
            geomConnect( via( nOhmicContact nOhmic nwell nBulk metal1 )
                         via( pOhmicContact pOhmic pwell pBulk metal1 )
                         via( nDiffContact nDiff metal1 )
                         via( pDiffContact pDiff metal1 )
                         via( lcContact lcDiff metal1 )
                         via( cp poly metal1 )
                         via( via metal1 metal2 )
                         via( via2 metal2 metal3 )
                         label( "text" metal3 metal2 metal1 poly lcDiff pDiff nDiff )
            ) 
        )
        ( metal3Available && elecAvailable
            geomConnect( via( nOhmicContact nOhmic nwell nBulk metal1 )
                         via( pOhmicContact pOhmic pwell pBulk metal1 )
                         via( nDiffContact nDiff metal1 )
                         via( pDiffContact pDiff metal1 )
                         via( cp poly metal1 )
                         via( ce elec metal1 )
                         via( via metal1 metal2 )
                         via( via2 metal2 metal3 )
                         label( "text" metal3 metal2 metal1 elec poly pDiff nDiff )
            ) 
        )
        ( metal3Available
            geomConnect( via( nOhmicContact nOhmic nwell nBulk metal1 )
                         via( pOhmicContact pOhmic pwell pBulk metal1 )
                         via( nDiffContact nDiff metal1 )
                         via( pDiffContact pDiff metal1 )
                         via( cp poly metal1 )
                         via( via metal1 metal2 )
                         via( via2 metal2 metal3 )
                         label( "text" metal3 metal2 metal1 poly pDiff nDiff )
            ) 
        )
        ( npnAvailable && ccdAvailable && elecAvailable
            geomConnect( via( nOhmicContact nOhmic nwell nBulk metal1 )
                         via( pOhmicContact pOhmic pwell pBulk metal1 )
                         via( nDiffContact nDiff metal1 )
                         via( pDiffContact pDiff metal1 )
                         via( ccdContact ccdDiff metal1 )
                         via( npnEmitterContact npnEmitter metal1 )
                         via( npnBaseContact npnBaseTap npnBase metal1 )
                         via( npnCollectorContact npnCollector metal1 )
                         via( cp poly metal1 )
                         via( ce elec metal1 )
                         via( via metal1 metal2 )
                         label( "text" metal2 metal1 elec poly pDiff nDiff ccdDiff npnCollector npnEmitter npnBase )
            ) 
        )
        ( npnAvailable && elecAvailable
            geomConnect( via( nOhmicContact nOhmic nwell nBulk metal1 )
                         via( pOhmicContact pOhmic pwell pBulk metal1 )
                         via( nDiffContact nDiff metal1 )
                         via( pDiffContact pDiff metal1 )
                         via( npnEmitterContact npnEmitter metal1 )
                         via( npnBaseContact npnBaseTap npnBase metal1 )
                         via( npnCollectorContact npnCollector metal1 )
                         via( cp poly metal1 )
                         via( ce elec metal1 )
                         via( via metal1 metal2 )
                         label( "text" metal2 metal1 elec poly pDiff nDiff npnCollector npnEmitter npnBase )
            ) 
        )
        ( polycapAvailable
            geomConnect( via( nOhmicContact nOhmic nwell nBulk metal1 )
                         via( pOhmicContact pOhmic pwell pBulk metal1 )
                         via( nDiffContact nDiff metal1 )
                         via( pDiffContact pDiff metal1 )
                         via( cp poly metal1 )
                         via( cpolycap polycap metal1 )
                         via( via metal1 metal2 )
                         label( "text" metal2 metal1 poly polycap pDiff nDiff )
            ) 
        )
        ( t
            geomConnect( via( nOhmicContact nOhmic nwell nBulk metal1 )
                         via( pOhmicContact pOhmic pwell pBulk metal1 )
                         via( nDiffContact nDiff metal1 )
                         via( pDiffContact pDiff metal1 )
                         via( cp poly metal1 )
                         via( via metal1 metal2 )
                         label( "text" metal2 metal1 poly pDiff nDiff )
            ) 
        )
    )

    ivIf( switch("drc?") then
    
    ivIf( ( !switch("hier?") || switch("currentCell?") ) then

        dubiousData( ( "gwell" "drawing" )   "Improperly formed shape - gwell" )
        dubiousData( ( "nwell" "drawing" )   "Improperly formed shape - nwell" )
        dubiousData( ( "pwell" "drawing" )   "Improperly formed shape - pwell" )
        dubiousData( ( "active" "drawing" )  "Improperly formed shape - active, nactive or pactive" )
        dubiousData( ( "gselect" "drawing" ) "Improperly formed shape - gselect" )
        dubiousData( ( "nselect" "drawing" ) "Improperly formed shape - nselect" )
        dubiousData( ( "pselect" "drawing" ) "Improperly formed shape - pselect" )
        dubiousData( ( "poly" "drawing" )    "Improperly formed shape - poly" )
        dubiousData( ( "metal1" "drawing" )  "Improperly formed shape - metal1" )
        dubiousData( ( "ca" "drawing" )      "Improperly formed shape - ca" )
        dubiousData( ( "cp" "drawing" )      "Improperly formed shape - cp" )
        dubiousData( ( "metal2" "drawing" )  "Improperly formed shape - metal2" )
        dubiousData( ( "via" "drawing" )     "Improperly formed shape - via" )
        dubiousData( ( "glass" "drawing" )   "Improperly formed shape - glass" )

        saveDerived( geomGetNon45( gwell )   "Non-Manhattan shape - gwell" )
        saveDerived( geomGetNon45( nwell )   "Non-Manhattan shape - nwell" )
        saveDerived( geomGetNon45( pwell )   "Non-Manhattan shape - pwell" )
        saveDerived( geomGetNon45( active )  "Non-Manhattan shape - active, nactive or pactive" )
        saveDerived( geomGetNon45( gselect ) "Non-Manhattan shape - gselect" )
        saveDerived( geomGetNon45( nselect ) "Non-Manhattan shape - nselect" )
        saveDerived( geomGetNon45( pselect ) "Non-Manhattan shape - pselect" )
        saveDerived( geomGetNon45( poly )    "Non-Manhattan shape - poly" )
        saveDerived( geomGetNon45( metal1 )  "Non-Manhattan shape - metal1" )
        saveDerived( geomGetNon45( ca )      "Non-Manhattan shape - ca" )
        saveDerived( geomGetNon45( cp )      "Non-Manhattan shape - cp" )
        saveDerived( geomGetNon45( metal2 )  "Non-Manhattan shape - metal2" )
        saveDerived( geomGetNon45( via )     "Non-Manhattan shape - via" )

        ; allow round glass cuts for solder bumps
        unless( padType == "Area array"
             saveDerived( geomGetNon45( glass ) "Non-Manhattan shape - glass" )
        )

        ;saveDerived( geomGetAngledEdge( active angle == 45 ) )

        offGrid( gwell gridRes "(SCMOS Inst) Edge not on grid" )
        offGrid( nwell gridRes "(SCMOS Inst) Edge not on grid" )
        offGrid( pwell gridRes "(SCMOS Inst) Edge not on grid" )
        offGrid( active gridRes "(SCMOS Inst) Edge not on grid" )
        offGrid( gselect gridRes "(SCMOS Inst) Edge not on grid" )
        offGrid( nselect gridRes "(SCMOS Inst) Edge not on grid" )
        offGrid( pselect gridRes "(SCMOS Inst) Edge not on grid" )
        offGrid( poly gridRes "(SCMOS Inst) Edge not on grid" )                                  
        offGrid( metal1 gridRes "(SCMOS Inst) Edge not on grid" )
        offGrid( ca gridRes "(SCMOS Inst) Edge not on grid" )
        offGrid( cp gridRes "(SCMOS Inst) Edge not on grid" )
        offGrid( metal2 gridRes "(SCMOS Inst) Edge not on grid" )
        offGrid( via gridRes "(SCMOS Inst) Edge not on grid" )
        unless( padType== "Area array"
            (offGrid glass gridRes "(SCMOS Inst) Edge not on grid" )
        )

        if( npnAvailable then
            dubiousData( ( "pbase" "drawing" )   "Improperly formed shape - pbase" )
            saveDerived( geomGetNon45( pbase )   "Non-Manhattan shape - pbase" )
            offGrid( pbase gridRes "(SCMOS Inst) Edge not on grid" )
            dubiousData( ( "cactive" "drawing" )   "Improperly formed shape - cactive" )
            saveDerived( geomGetNon45( cactive )   "Non-Manhattan shape - cactive" )
            offGrid( cactive gridRes "(SCMOS Inst) Edge not on grid" )
        )
        if( ccdAvailable then
            dubiousData( ( "ccd" "drawing" )     "Improperly formed shape - ccd" )
            saveDerived( geomGetNon45( ccd )     "Non-Manhattan shape - ccd" )
            offGrid( ccd gridRes "(SCMOS Inst) Edge not on grid" )
        )
        if( metal3Available then
            dubiousData( ( "metal3" "drawing" )  "Improperly formed shape - metal3" )
            dubiousData( ( "via2" "drawing" )    "Improperly formed shape - via2" )
            saveDerived( geomGetNon45( metal3 )  "Non-Manhattan shape - metal3" )
            saveDerived( geomGetNon45( via2 )    "Non-Manhattan shape - via2" )
            offGrid( metal3 gridRes "(SCMOS Inst) Edge not on grid" )
            offGrid( via2 gridRes "(SCMOS Inst) Edge not on grid" )
        )
        if( metal4Available then
            dubiousData( ( "metal4" "drawing" )  "Improperly formed shape - metal4" )
            dubiousData( ( "via3" "drawing" )    "Improperly formed shape - via3" )
            saveDerived( geomGetNon45( metal4 )  "Non-Manhattan shape - metal4" )
            saveDerived( geomGetNon45( via3 )    "Non-Manhattan shape - via3" )
            offGrid( metal4 gridRes "(SCMOS Inst) Edge not on grid" )
            offGrid( via3 gridRes "(SCMOS Inst) Edge not on grid" )
        )
        if( metal5Available then
            dubiousData( ( "metal5" "drawing" )  "Improperly formed shape - metal5" )
            dubiousData( ( "via4" "drawing" )    "Improperly formed shape - via4" )
            saveDerived( geomGetNon45( metal5 )  "Non-Manhattan shape - metal5" )
            saveDerived( geomGetNon45( via4 )    "Non-Manhattan shape - via4" )
            offGrid( metal5 gridRes "(SCMOS Inst) Edge not on grid" )
            offGrid( via4 gridRes "(SCMOS Inst) Edge not on grid" )
        )
        if( metal6Available then
            dubiousData( ( "metal6" "drawing" )  "Improperly formed shape - metal6" )
            dubiousData( ( "via5" "drawing" )    "Improperly formed shape - via5" )
            saveDerived( geomGetNon45( metal6 )  "Non-Manhattan shape - metal6" )
            saveDerived( geomGetNon45( via5 )    "Non-Manhattan shape - via5" )
            offGrid( metal6 gridRes "(SCMOS Inst) Edge not on grid" )
            offGrid( via5 gridRes "(SCMOS Inst) Edge not on grid" )
        )
        if( metalcapAvailable then
            dubiousData( ( "metalcap" "drawing" )  "Improperly formed shape - metalcap" )
            saveDerived( geomGetNon45( metalcap )  "Non-Manhattan shape - metalcap" )
            offGrid( metalcap gridRes "(SCMOS Inst) Edge not on grid" )
        )
        if( elecAvailable then
            dubiousData( ( "elec" "drawing" )    "Improperly formed shape - elec" )
            dubiousData( ( "ce" "drawing" )      "Improperly formed shape - ce" )
            saveDerived( geomGetNon45( elec )    "Non-Manhattan shape - elec" )
            saveDerived( geomGetNon45( ce )      "Non-Manhattan shape - ce" )
            offGrid( elec gridRes "(SCMOS Inst) Edge not on grid" )
            offGrid( ce gridRes "(SCMOS Inst) Edge not on grid" )
        )
        if( cwellAvailable then
            dubiousData( ( "cwell" "drawing" )   "Improperly formed shape - cwell" )
            saveDerived( geomGetNon45( cwell )   "Non-Manhattan shape - cwell" )
            offGrid( cwell gridRes "(SCMOS Inst) Edge not on grid" )
        )
        if( polycapAvailable then
            dubiousData( ( "polycap" "drawing" )   "Improperly formed shape - polycap" )
            saveDerived( geomGetNon45( polycap )   "Non-Manhattan shape - polycap" )
            offGrid( polycap gridRes "(SCMOS Inst) Edge not on grid" )
        )
        if( sblockAvailable then
            dubiousData( ( "sblock" "drawing" )   "Improperly formed shape - sblock" )
            saveDerived( geomGetNon45( sblock )   "Non-Manhattan shape - sblock" )
            offGrid( sblock gridRes "(SCMOS Inst) Edge not on grid" )
        )
        if( memsAvailable then
            dubiousData( ( "pstop" "drawing" )   "Improperly formed shape - pstop" )
            saveDerived( geomGetNon45( pstop )   "Non-Manhattan shape - pstop" )
            offGrid( pstop gridRes "(SCMOS Inst) Edge not on grid" )
            dubiousData( ( "open" "drawing" )   "Improperly formed shape - open" )
            saveDerived( geomGetNon45( open )   "Non-Manhattan shape - open" )
            offGrid( open gridRes "(SCMOS Inst) Edge not on grid" )
        )
        if( hvAvailable then
            dubiousData( ( "tactive" "drawing" )   "Improperly formed shape - tactive" )
            saveDerived( geomGetNon45( tactive )   "Non-Manhattan shape - tactive" )
            offGrid( tactive gridRes "(SCMOS Inst) Edge not on grid" )
        )
    )

    gwellEdge          = geomGetEdge( gwell   )
    nwellEdge          = geomGetEdge( nwell   )
    pwellEdge          = geomGetEdge( pwell   )
    activeEdge         = geomGetEdge( active  )
    gselectEdge        = geomGetEdge( gselect )
    nselectEdge        = geomGetEdge( nselect )
    pselectEdge        = geomGetEdge( pselect )
    polyEdge           = geomGetEdge( poly    )
    metal1Edge         = geomGetEdge( metal1  )
    ccEdge             = geomGetEdge( cc      )
    caEdge             = geomGetEdge( ca      )
    cpEdge             = geomGetEdge( cp      )
    metal2Edge         = geomGetEdge( metal2  )
    viaEdge            = geomGetEdge( via     )
    glassEdge          = geomGetEdge( glass   )
    padEdge            = geomGetEdge( pad     )

    if( cwellAvailable then
        cwellEdge          = geomGetEdge( cwell    )
    )
    if( npnAvailable then
        pbaseEdge          = geomGetEdge( pbase    )
        cactiveEdge        = geomGetEdge( cactive  )
    )
    if( ccdAvailable then
        ccdEdge            = geomGetEdge( ccd      )
    )
    if( polycapAvailable then
        polycapEdge        = geomGetEdge( polycap  )
        cpolycapEdge       = geomGetEdge( cpolycap )
    )
    if( sblockAvailable then
        sblockEdge         = geomGetEdge( sblock   )
    )
    if( highresAvailable then
        highresEdge        = geomGetEdge( highres    )
    )
    if( memsAvailable then
        pstopEdge          = geomGetEdge( pstop    )
        openEdge           = geomGetEdge( open     )
    )
    if( elecAvailable then
        ceEdge             = geomGetEdge( ce       )
        elecEdge           = geomGetEdge( elec     )
    )
    if( metal3Available then
        metal3Edge         = geomGetEdge( metal3   )
        via2Edge           = geomGetEdge( via2     )
    )
    if( metal4Available then
        metal4Edge         = geomGetEdge( metal4   )
        via3Edge           = geomGetEdge( via3     )
    )
    if( metal5Available then
        metal5Edge         = geomGetEdge( metal5   )
        via4Edge           = geomGetEdge( via4     )
    )
    if( metal6Available then
        metal6Edge         = geomGetEdge( metal6   )
        via5Edge           = geomGetEdge( via5     )
    )
    if( metalcapAvailable then
        metalcapEdge       = geomGetEdge( metalcap )
        metalcapBottomEdge = geomGetEdge( metalcapBottom )
        metalcapCapEdge    = geomGetEdge( metalcapCap )
        cond(
            ( metal6Available
                via5metalcapEdge = geomGetEdge( via5metalcap )
            )
            ( metal5Available
                via4metalcapEdge = geomGetEdge( via4metalcap )
            )
        )
    )
    if( hvAvailable then
        tactiveEdge        = geomGetEdge( tactive  )
    )

    nBulkEdge          = geomGetEdge( nBulk     )
    pBulkEdge          = geomGetEdge( pBulk     )
    nOhmicEdge         = geomGetEdge( nOhmic    )
    pOhmicEdge         = geomGetEdge( pOhmic    )
    nNotOhmicEdge      = geomGetEdge( nNotOhmic )
    pNotOhmicEdge      = geomGetEdge( pNotOhmic )
    GateEdge           = geomGetEdge( Gate      )
    fieldPolyEdge      = geomGetEdge( fieldPoly )
    if( elecAvailable then
        CapacitorElecEdge  = geomGetEdge( CapacitorElec  )
        TransistorElecEdge = geomGetEdge( TransistorElec )
    )
    if( npnAvailable then
        npnCollectorEdge        = geomGetEdge( npnCollector        )
        npnCollectorContactEdge = geomGetEdge( npnCollectorContact )
        npnBaseImplantEdge      = geomGetEdge( npnBaseImplant      )
        npnEmitterEdge          = geomGetEdge( npnEmitter          )
        npnBaseEdge             = geomGetEdge( npnBase             )
        npnBaseTapEdge          = geomGetEdge( npnBaseTap          )
        npnBaseContactEdge      = geomGetEdge( npnBaseContact      )
        npnEmitterContactEdge   = geomGetEdge( npnEmitterContact   )
    )
    if( ccdAvailable then
        ccdDiffEdge        = geomGetEdge( ccdDiff    )
        ccdContactEdge     = geomGetEdge( ccdContact )
    )
    if( cwellAvailable then
        lcDiffEdge         = geomGetEdge( lcDiff     )
        lcCapEdge          = geomGetEdge( lcCap      )
    )
    if( polycapAvailable then
        polycapCapEdge     = geomGetEdge( polycapCap )
    )
    if( sblockAvailable then
        sGateWidthCheckEdge = geomGetEdge( sGateWidthCheck )
    )

    if( sblockAvailable then
	; BUG: tags false enclosure errors when sblock edge butts salicided poly, modified by ramirtha 06/05/05 - updated 05/23/07
        ; polySResEdge = geomGetEdge( polySRes )
        polySResEdge = geomAndNot( geomGetEdge( polySRes ) geomGetEdge( polySRes butting poly) )
    )
    polyResEdge = geomGetEdge( polyRes coincident poly )
    nwellResEdge = geomGetEdge( nwellRes coincident nwell )
    if( elecAvailable && highresAvailable then
        elecHighresEdge = geomGetEdge( elecRes coincident elec )
    )

    ) ; close ivIf( switch( "?drc" ) )

; vim:ts=4:columns=132:set tw=0:
