;==========================================================================
;
; $Id: layerRules.tf,v 1.1.1.1 2006/02/10 16:32:38 slipa Exp $
; 
;--------------------------------------------------------------------------

layerRules(

let( (cwellAvailable polycapAvailable metal3Available metal4Available 
      metal5Available metal6Available npnAvailable ccdAvailable 
      sblockAvailable elecAvailable memsAvailable hvAvailable 
      highresAvailable metalcapAvailable)

 cwellAvailable    = techParam( "cwellAvailable" )
 polycapAvailable  = techParam( "polycapAvailable" )
 npnAvailable      = techParam( "npnAvailable" )
 ccdAvailable      = techParam( "ccdAvailable" )
 metal3Available   = techParam( "metal3Available" )
 metal4Available   = techParam( "metal4Available" )
 metal5Available   = techParam( "metal5Available" )
 metal6Available   = techParam( "metal6Available" )
 elecAvailable     = techParam( "elecAvailable" )
 memsAvailable     = techParam( "memsAvailable" )
 sblockAvailable   = techParam( "sblockAvailable" )
 hvAvailable       = techParam( "hvAvailable" )
 highresAvailable  = techParam( "highresAvailable" )
 metalcapAvailable = techParam( "metalcapAvailable" )
 egrcAvailable     = techParam( "egrcAvailable" )
 
/*
 * viaLayers
 */

viaLayers(
 ;( layer1      viaLayer    layer2     )
  ( poly        cp          metal1     )
  ( poly        cc          metal1     )
  ( active      ca          metal1     )
  ( active      cc          metal1     )
  ( nactive     ca          metal1     )
  ( nactive     cc          metal1     )
  ( pactive     ca          metal1     )
  ( pactive     cc          metal1     )
  ( metal1      via         metal2     )
 )

if( elecAvailable then
    viaLayers(
      ( elec        ce          metal1     )
      ( elec        cc          metal1     )
    )
)

if( npnAvailable then
    viaLayers(
      ( cactive     ca          metal1      )
      ( cactive     cc          metal1      )
    )
)

if( polycapAvailable then
    viaLayers(
      ( polycap     cp          metal1     )
      ( polycap     cc          metal1     )
    )
)

if( metal3Available then
    viaLayers(
      ( metal2      via2        metal3     )
    )
)

if( metal4Available then
    viaLayers(
      ( metal3      via3        metal4     )
    )
)

if( metal5Available then
    viaLayers(
      ( metal4      via4        metal5     )
    )
)

if( metal6Available then
    viaLayers(
      ( metal5      via5        metal6     )
    )
)

if( hvAvailable then
    viaLayers(
      ( tactive     ca          metal1      )
      ( tactive     cc          metal1      )
    )
)
; end viaLayers


/*
 * no equivalentLayers needed (?)
 */


/*
 * streamLayers
 */

streamLayers(
; ( layer     stream#   dataType    translate )
  ( gwell     53        0           t )
  ( nwell     42        0           t )
  ( pwell     41        0           t )
  ( active    43        0           t )
  ( nactive   43        0           t )
  ( pactive   43        0           t )
  ( gselect   54        0           t )
  ( nselect   45        0           t )
  ( pselect   44        0           t )
  ( poly      46        0           t )
  ( metal1    49        0           t )
  ( ca        25        0           t )
  ( cp        25        0           t )
  ( cc        25        0           t )
  ( metal2    51        0           t )
  ( via       50        0           t )
  ( glass     52        0           t )
  ( pad       26        0           t )
)

if( metal3Available then
    streamLayers(
      ( metal3    62        0           t )
      ( via2      61        0           t )
    )
)
if( metal4Available then
    streamLayers(
      ( metal4    31        0           t )
      ( via3      30        0           t )
    )
)
if( metal5Available then
    streamLayers(
      ( metal5    33        0           t )
      ( via4      32        0           t )
    )
)
if( metal6Available then
    streamLayers(
      ( metal6    99        0           t )
      ( via5      98        0           t )
    )
)
if( cwellAvailable then
    streamLayers(
      ( cwell     59        0           t )
    )
)
if( polycapAvailable then
    streamLayers(
      ( polycap   28        0           t )
    )
)
if( npnAvailable then
    streamLayers(
      ( pbase     58        0           t )
      ( cactive   43        0           t )
    )
)
if( ccdAvailable then
    streamLayers(
      ( ccd       57        0           t )
    )
)
if( elecAvailable then
    streamLayers(
      ( elec      56        0           t )
      ( ce        25        0           t )
    )
)
if( memsAvailable then
    streamLayers(
      ( open      23        0           t )
      ( pstop     24        0           t )
    )
)
if( sblockAvailable then
    streamLayers(
      ( sblock    29        0           t )
    )
)
if( hvAvailable then
    streamLayers(
      ( tactive   60        0           t )
    )
)
if( highresAvailable then
    streamLayers(
      ( highres   34        0           t )
    )
)
if( metalcapAvailable then
    streamLayers(
      ( metalcap  35        0           t )
    )
)
if( egrcAvailable then
    streamLayers(
      ( via3         30       0           t   )
      ( metal1_cut   0        0           nil )
      ( metal2_cut   1        0           nil )
      ( metal3_cut   2        0           nil )
      ( ac_pad       3        0           t   )
      ( contact_pad  4        0           t   )
      ( contct_ubm   5        0           t   )
      ( mech0        6        0           t   )
      ( mech0_cut    7        0           nil )
      ( mech1        8        0           t   )
      ( mech1_cut    9        0           nil )
      ( sac0         10       0           t   )
      ( sac0_cut     11       0           nil )
      ( sac1         12       0           t   )
      ( sac1_cut     13       0           nil )
      ( bulk         14       0           t   )
      ( bulk_cut     15       0           nil )
      ( ground       16       0           t   )
      ( ground_cut   17       0           nil )
    )
)
; end streamLayers

 ) ; let
) ; layerRules

; vim:ts=4:
