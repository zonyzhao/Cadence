;==========================================================================
;
; $Id: prRules.tf,v 1.1.1.1 2006/02/10 16:32:39 slipa Exp $
; 
;--------------------------------------------------------------------------

/**************
 *
 * place-and-route rules
 *
 **************/


prRules(

let( (metal3Available metal4Available metal5Available 
      metal6Available submicronAvailable deepAvailable lambda rules )

 technology = techParam( "technology" )

 if( NCSU_techData[ technology ] == nil then
     hiGetAttention()
     error( "Unrecognizable \"technology\" property!" )
 )

 submicronAvailable = NCSU_techData[ technology ]->submicronRules
 deepAvailable = NCSU_techData[ technology ]->deepRules
 lambda = techParam( "lambda" )
 metal3Available  = techParam( "metal3Available" )
 metal4Available  = techParam( "metal4Available" )
 metal5Available  = techParam( "metal5Available" )
 metal6Available  = techParam( "metal6Available" )

 prRoutingLayers(
 ;( layer                       preferredDirection  )
 ;( -----                       ------------------  )
  ( metal1                   	"horizontal" )
  ( metal2                   	"vertical" )
 ) ;prRoutingLayers
 if( metal3Available then
  prRoutingLayers(
   ( metal3                   	"horizontal" )
  ) ;prRoutingLayers
 ) ;if metal3Available
 if( metal4Available then
  prRoutingLayers(
   ( metal4                   	"vertical" )
  ) ;prRoutingLayers
 ) ;if metal4Available
 if( metal5Available then
  prRoutingLayers(
   ( metal5                   	"horizontal" )
  ) ;prRoutingLayers
 ) ;if metal5Available
 if( metal6Available then
  prRoutingLayers(
   ( metal6                   	"vertical" )
  ) ;prRoutingLayers
 ) ;if metal6Available

 prViaTypes(
 ;( device viewName             viaType    )
 ;( ---------------             -------    )
  ( ("M2_M1" "symbolic")	"default"  )
 ) ;prViaTypes
 if( metal3Available then
  prViaTypes(
   ( ("M3_M2" "symbolic")	"default"  )
  ) ;prViaTypes
 ) ;if metal3Available
 if( metal4Available then
  prViaTypes(
   ( ("M4_M3" "symbolic")	"default"  )
  ) ;prViaTypes
 ) ;if metal4Available
 if( metal5Available then
  prViaTypes(
   ( ("M5_M4" "symbolic")	"default"  )
  ) ;prViaTypes
 ) ;if metal5Available
 if( metal6Available then
  prViaTypes(
   ( ("M6_M5" "symbolic")	"default"  )
  ) ;prViaTypes
 ) ;if metal6Available


 ;prStackVias(
 ; not needed
 ;) ;prStackVias

 ;prMaxStackVias(
 ; not needed
 ;) ;prMaxStackVias


 prMastersliceLayers(
 ;( layers : listed in order of lowest (closest to substrate) to highest )
 ;( -------------------------------------------------------------------- )
  ( nwell     	nactive   	pactive   	poly       )
 ) ;prMastersliceLayers

 ;prViaRules(
 ; not needed
 ;) ;prViaRules

 ; PR Gen Via Rules are needed to import Generated Array Vias from P&R tools
 ; The rules here are adapted from the via rules in $cdk_dir/techfile/devices.tf


 ;( ViaRuleName         viaLayer     (lowerPt upperPt xPitch yPitch resistence) 
 ;    Layer1            Direction|(overhang1 overhang2)    (wMin wMax overHang metalOverHang) 
 ;    Layer2            Direction|(overhang1 overhang2)    (wMin wMax overHang metalOverHang) 
 ;    (properties)
 ;) 
 ;( ---------------------------------------------------------------------- ) 
 rules = list( 
     list( 'viagen21	"via"		list( list( 'range -lambda -lambda) list( 'range lambda lambda) 5*lambda 5*lambda '_NA_ )
      'metal1         	"horizontal"	list( 3*lambda 600*lambda lambda 0.0 )
      'metal2         	"vertical"	list( 3*lambda 600*lambda lambda 0.0 )
         ))
 apply( 'prGenViaRules rules )
 prGenViaRules(
  ( TURN1       	nil	( _NA_ _NA_ _NA_ _NA_ _NA_ )
      metal1         	"vertical"	( _NA_ _NA_ _NA_ _NA_ )
      metal1         	"horizontal"	( _NA_ _NA_ _NA_ _NA_ )
  )
  ( TURN2       	nil	( _NA_ _NA_ _NA_ _NA_ _NA_ )
      metal2         	"vertical"	( _NA_ _NA_ _NA_ _NA_ )
      metal2         	"horizontal"	( _NA_ _NA_ _NA_ _NA_ )
  )
 ) ;prGenViaRules

cond( 
 (metal6Available && submicronAvailable
  rules = list( 
     list( 'viagen65	"via5"		list( list( 'range -1.5*lambda -1.5*lambda) list( 'range 1.5*lambda 1.5*lambda) 7*lambda 7*lambda '_NA_ )
      'metal5         	"horizontal"	list( 5*lambda 600*lambda lambda 0.0 )
      'metal6         	"vertical"	list( 5*lambda 600*lambda lambda 0.0 )
         )
     list( 'viagen54	"via4"		list( list( 'range -lambda -lambda) list( 'range lambda lambda) 5*lambda 5*lambda '_NA_ )
      'metal5         	"horizontal"	list( 3*lambda 600*lambda lambda 0.0 )
      'metal4         	"vertical"	list( 3*lambda 600*lambda lambda 0.0 )
         )
     list( 'viagen43	"via3"		list( list( 'range -lambda -lambda) list( 'range lambda lambda) 5*lambda 5*lambda '_NA_ )
      'metal3         	"horizontal"	list( 3*lambda 600*lambda lambda 0.0 )
      'metal4         	"vertical"	list( 3*lambda 600*lambda lambda 0.0 )
         )
     list( 'viagen32	"via2"		list( list( 'range -lambda -lambda) list( 'range lambda lambda) 5*lambda 5*lambda '_NA_ )
      'metal3         	"horizontal"	list( 3*lambda 600*lambda lambda 0.0 )
      'metal2         	"vertical"	list( 3*lambda 600*lambda lambda 0.0 )
         )
       )
  apply( 'prGenViaRules rules )
  prGenViaRules(
   ( TURN3       	nil	( _NA_ _NA_ _NA_ _NA_ _NA_ )
       metal3         	"vertical"	( _NA_ _NA_ _NA_ _NA_ )
       metal3         	"horizontal"	( _NA_ _NA_ _NA_ _NA_ )
   )
   ( TURN4       	nil	( _NA_ _NA_ _NA_ _NA_ _NA_ )
       metal4         	"vertical"	( _NA_ _NA_ _NA_ _NA_ )
       metal4         	"horizontal"	( _NA_ _NA_ _NA_ _NA_ )
   )
   ( TURN5       	nil	( _NA_ _NA_ _NA_ _NA_ _NA_ )
       metal5         	"vertical"	( _NA_ _NA_ _NA_ _NA_ )
       metal5         	"horizontal"	( _NA_ _NA_ _NA_ _NA_ )
   )
   ( TURN6       	nil	( _NA_ _NA_ _NA_ _NA_ _NA_ )
       metal6         	"vertical"	( _NA_ _NA_ _NA_ _NA_ )
       metal6         	"horizontal"	( _NA_ _NA_ _NA_ _NA_ )
   )
  ) ;prGenViaRules
 )
 (metal5Available && submicronAvailable
  rules = list( 
     list( 'viagen54	"via4"		list( list( 'range -lambda -lambda) list( 'range lambda lambda) 5*lambda 5*lambda '_NA_ )
      'metal5         	"horizontal"	list( 3*lambda 600*lambda lambda 0.0 )
      'metal4         	"vertical"	list( 3*lambda 600*lambda lambda 0.0 )
         )
     list( 'viagen43	"via3"		list( list( 'range -lambda -lambda) list( 'range lambda lambda) 5*lambda 5*lambda '_NA_ )
      'metal3         	"horizontal"	list( 3*lambda 600*lambda lambda 0.0 )
      'metal4         	"vertical"	list( 3*lambda 600*lambda lambda 0.0 )
         )
     list( 'viagen32	"via2"		list( list( 'range -lambda -lambda) list( 'range lambda lambda) 5*lambda 5*lambda '_NA_ )
      'metal3         	"horizontal"	list( 3*lambda 600*lambda lambda 0.0 )
      'metal2         	"vertical"	list( 3*lambda 600*lambda lambda 0.0 )
         )
       )
  apply( 'prGenViaRules rules )
  prGenViaRules(
   ( TURN3       	nil	( _NA_ _NA_ _NA_ _NA_ _NA_ )
       metal3         	"vertical"	( _NA_ _NA_ _NA_ _NA_ )
       metal3         	"horizontal"	( _NA_ _NA_ _NA_ _NA_ )
   )
   ( TURN4       	nil	( _NA_ _NA_ _NA_ _NA_ _NA_ )
       metal4         	"vertical"	( _NA_ _NA_ _NA_ _NA_ )
       metal4         	"horizontal"	( _NA_ _NA_ _NA_ _NA_ )
   )
   ( TURN5       	nil	( _NA_ _NA_ _NA_ _NA_ _NA_ )
       metal5         	"vertical"	( _NA_ _NA_ _NA_ _NA_ )
       metal5         	"horizontal"	( _NA_ _NA_ _NA_ _NA_ )
   )
  ) ;prGenViaRules
 )
 (metal4Available && submicronAvailable
  rules = list( 
     list( 'viagen43	"via3"		list( list( 'range -lambda -lambda) list( 'range lambda lambda) 5*lambda 5*lambda '_NA_ )
      'metal3         	"horizontal"	list( 3*lambda 600*lambda lambda 0.0 )
      'metal4         	"vertical"	list( 3*lambda 600*lambda lambda 0.0 )
         )
     list( 'viagen32	"via2"		list( list( 'range -lambda -lambda) list( 'range lambda lambda) 5*lambda 5*lambda '_NA_ )
      'metal3         	"horizontal"	list( 3*lambda 600*lambda lambda 0.0 )
      'metal2         	"vertical"	list( 3*lambda 600*lambda lambda 0.0 )
         )
       )
  apply( 'prGenViaRules rules )
  prGenViaRules(
   ( TURN3       	nil	( _NA_ _NA_ _NA_ _NA_ _NA_ )
       metal3         	"vertical"	( _NA_ _NA_ _NA_ _NA_ )
       metal3         	"horizontal"	( _NA_ _NA_ _NA_ _NA_ )
   )
   ( TURN4       	nil	( _NA_ _NA_ _NA_ _NA_ _NA_ )
       metal4         	"vertical"	( _NA_ _NA_ _NA_ _NA_ )
       metal4         	"horizontal"	( _NA_ _NA_ _NA_ _NA_ )
   )
  ) ;prGenViaRules
 )
 (metal3Available && submicronAvailable
  rules = list( 
     list( 'viagen32	"via2"		list( list( 'range -lambda -lambda) list( 'range lambda lambda) 5*lambda 5*lambda '_NA_ )
      'metal3         	"horizontal"	list( 3*lambda 600*lambda lambda 0.0 )
      'metal2         	"vertical"	list( 3*lambda 600*lambda lambda 0.0 )
         )
       )
  apply( 'prGenViaRules rules )
  prGenViaRules(
   ( TURN3       	nil	( _NA_ _NA_ _NA_ _NA_ _NA_ )
       metal3         	"vertical"	( _NA_ _NA_ _NA_ _NA_ )
       metal3         	"horizontal"	( _NA_ _NA_ _NA_ _NA_ )
   )
  ) ;prGenViaRules
 )
) ;cond



 ;prNonDefaultRules(
 ; not needed
 ;) ;prNonDefaultRules

 ; prRoutingPitch section is created when importing a LEF file, but
 ; It has been omitted temporarily while I try to figure out how to
 ; implement it.  
 ;   -- 10/16/2004 Rhett Davis
 ;prRoutingPitch(
 ;( layer                pitch )
 ;( -----                ----- )
 ; ( metal1               1.0 )
 ; ( metal2               0.8 )
 ; ( metal3               1.0 )
 ; ( metal4               0.8 )
 ; ( metal5               1.0 )
 ; ( metal6               1.6 )
 ;) ;prRoutingPitch

 ;prRoutingOffset(
 ; not needed
 ;) ;prRoutingOffset

 ;prOverlapLayer(
 ; not needed
 ;) ;prOverlapLayer


) ;let
) ;prRules






