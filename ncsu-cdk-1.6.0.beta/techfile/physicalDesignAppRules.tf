;==========================================================================
;
; $Id: physicalDesignAppRules.tf,v 1.1.1.1 2006/02/10 16:32:38 slipa Exp $
; 
;--------------------------------------------------------------------------

/**************
 *
 * layout editor rules
 *
 **************/

    ; no layout editor rules


/**************
 *
 * device-level editor rules
 *
 **************/

lxRules(

let( (technology cwellAvailable metal3Available npnAvailable
      ccdAvailable elecAvailable metal4Available polycapAvailable
      metal5Available metal6Available)


technology       = techParam( "technology" )
cwellAvailable   = techParam( "cwellAvailable" )
npnAvailable     = techParam( "npnAvailable" )
ccdAvailable     = techParam( "ccdAvailable" )
elecAvailable    = techParam( "elecAvailable" )
metal3Available  = techParam( "metal3Available" )
metal4Available  = techParam( "metal4Available" )
metal5Available  = techParam( "metal5Available" )
metal6Available  = techParam( "metal6Available" )
polycapAvailable = techParam( "polycapAvailable" )

lxExtractLayers(
    ( gwell pwell nwell active nactive pactive metal1 metal2 via ca cp cc )
)

if( cwellAvailable then
    lxExtractLayers(
        ( cwell )
    )
)
if( npnAvailable then
    lxExtractLayers(
        ( pbase cactive )
    )
)
if( ccdAvailable then
    lxExtractLayers(
        ( ccd )
    )
)
if( polycapAvailable then
    lxExtractLayers(
        ( polycap )
    )
)
if( elecAvailable then
    lxExtractLayers(
        ( elec ce )
    )
)
if( metal3Available then
    lxExtractLayers(
        ( metal3 )
    )
)
if( metal4Available then
    lxExtractLayers(
        ( metal4 )
    )
)
if( metal5Available then
    lxExtractLayers(
        ( metal5 )
    )
)
if( metal6Available then
    lxExtractLayers(
        ( metal6 )
    )
)

lxNoOverlapLayers(
    ( poly active )
    ( poly nactive )
    ( poly pactive )
    ( via  ca )
    ( via  cp )
    ( via  cc )
)
if( npnAvailable then
    lxNoOverlapLayers(
        ( poly cactive )
    )
)
if( polycapAvailable then
    lxNoOverlapLayers(
        ( poly polycap )
        ( metal1 polycap )
        ( metal2 polycap )
    )
)
if( elecAvailable then
    lxNoOverlapLayers(
        ( elec active )
        ( via ce )
    )
)
if( metal3Available && !metal4Available then
    lxNoOverlapLayers(
        ( via2 via )
    )
)

  ) ; let
) ;lxRules

/**************
 *
 * device-level router rules
 *
 **************/

dlrRules(

let( (metal3Available metal4Available metal5Available metal6Available)


metal3Available  = techParam( "metal3Available" )
metal4Available  = techParam( "metal4Available" )
metal5Available  = techParam( "metal5Available" )
metal6Available  = techParam( "metal6Available" )

dlrRoutingLayers(
   ;( layer     direction )
    ( poly      "horizontal" )
    ( metal1    "horizontal" )
    ( metal2    "vertical" )
)

if( metal3Available then
    dlrRoutingLayers(
       ;( layer     direction )
        ( metal3    "horizontal" )
    )
)

if( metal4Available then
    dlrRoutingLayers(
       ;( layer     direction )
        ( metal4    "vertical" )
    )
)

if( metal5Available then
    dlrRoutingLayers(
       ;( layer     direction )
        ( metal5    "horizontal" )
    )
)

if( metal6Available then
    dlrRoutingLayers(
       ;( layer     direction )
        ( metal6    "vertical" )
    )
)

; DLR only supports 1 poly layer for MOS creation (p.5-17, TF & DRF User Guide)

dlrDevices(
    ( poly active )
)

  ) ; let
) ;dlrRules

; vim:ts=4:columns=90:
