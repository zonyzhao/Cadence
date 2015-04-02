;==========================================================================
;
; $Id: devices.tf,v 1.1.1.1 2006/02/10 16:32:38 slipa Exp $
; 
;--------------------------------------------------------------------------

devices(

let( (technology lambda wellType contactSpacing submicronAvailable deepAvailable
      cwellAvailable polycapAvailable metal3Available metal4Available
      metal5Available metal6Available npnAvailable ccdAvailable
      elecAvailable sblockAvailable)

technology = techParam( "technology" )

if( NCSU_techData[ technology ] == nil then
    hiGetAttention()
    error( "Unrecognizable \"technology\" property!" )
)

wellType = substring( NCSU_techData[ technology ]->mosisCode 3 1 )
submicronAvailable = NCSU_techData[ technology ]->submicronRules
deepAvailable = NCSU_techData[ technology ]->deepRules
lambda = atof( NCSU_techData[ technology ]->lambda )

cwellAvailable   = techParam( "cwellAvailable" )
polycapAvailable = techParam( "polycapAvailable" )
npnAvailable     = techParam( "npnAvailable" )
elecAvailable    = techParam( "elecAvailable" )
ccdAvailable     = techParam( "ccdAvailable" )
metal3Available  = techParam( "metal3Available" )
metal4Available  = techParam( "metal4Available" )
metal5Available  = techParam( "metal5Available" )
metal6Available  = techParam( "metal6Available" )
sblockAvailable  = techParam( "sblockAvailable" )
hvAvailable      = techParam( "hvAvailable" )

; Set contact spacing here. Saves room later.

cond(
    ( submicronAvailable
        contactSpacing = 5*lambda )
     
    
    ( deepAvailable
        contactSpacing = 6*lambda )
      
    ( t
        
        contactSpacing = 4*lambda )
    )

tcCreateCDSDeviceClass()

/*
 * symbolic contacts
 *
 * Format:
 *
 * (name  viaLayer  viaPurpose
 *        layer1    purpose1  [(enclosure1  encpurpose1  encspacing1)]
 *        layer2    purpose2  [(enclosure2  encpurpose2  encspacing2)]
 *        width          length        
 *        (rows cols    xPitch         yPitch         xBias   yBias)
 *        encByLayer1    encByLayer2    legalRegion)
 *
 * See "Technology File and Display Resource File User Guide" for more info
 */

cond(
    ( wellType == "P"
        symContactDevice(
          (M1_P  cc        drawing
                 pactive   drawing   (pselect     drawing     (lambda * 2.0))
                 metal1    drawing
                 (lambda * 2.0) (lambda * 2.0)
                 (1    1       contactSpacing contactSpacing center  center)
                 (lambda * 1.0) (lambda * 1.0) (outside pwell drawing))

          (M1_N  cc        drawing
                 nactive   drawing   (nselect     drawing     (lambda * 2.0))
                 metal1    drawing
                 (lambda * 2.0) (lambda * 2.0)
                 (1    1       contactSpacing contactSpacing center  center)
                 (lambda * 1.0) (lambda * 1.0) (inside pwell drawing))

          (PTAP  cc        drawing
                 pwell     drawing   (pselect     drawing     (lambda * -1.0))
                 metal1    drawing   (pactive     drawing     0)
                 (lambda * 2.0) (lambda * 2.0)
                 (1    1       contactSpacing contactSpacing center  center)
                 (lambda * 4.0) (lambda * 1.0) (inside pwell drawing))
        )
    )
    ( wellType == "E"
        symContactDevice(
          (M1_P  cc        drawing
                 pactive   drawing   (pselect     drawing     (lambda * 2.0))
                 metal1    drawing
                 (lambda * 2.0) (lambda * 2.0)
                 (1    1       contactSpacing contactSpacing center  center)
                 (lambda * 1.0) (lambda * 1.0) (inside nwell drawing))

          (M1_N  cc        drawing
                 nactive   drawing   (nselect     drawing     (lambda * 2.0))
                 metal1    drawing
                 (lambda * 2.0) (lambda * 2.0)
                 (1    1       contactSpacing contactSpacing center  center)
                 (lambda * 1.0) (lambda * 1.0) (inside pwell drawing))

          (PTAP  cc        drawing
                 pwell     drawing   (pselect     drawing     (lambda * -1.0))
                 metal1    drawing   (pactive     drawing     0)
                 (lambda * 2.0) (lambda * 2.0)
                 (1    1       contactSpacing contactSpacing center  center)
                 (lambda * 4.0) (lambda * 1.0) (inside pwell drawing))

          (NTAP  cc        drawing
                 nwell     drawing   (nselect     drawing     (lambda * -1.0))
                 metal1    drawing   (nactive     drawing     0)
                 (lambda * 2.0) (lambda * 2.0)
                 (1    1       contactSpacing contactSpacing center  center)
                 (lambda * 4.0) (lambda * 1.0) (inside nwell drawing))
        )
    )
    ( t
        symContactDevice(
          (M1_P  cc        drawing
                 pactive   drawing   (pselect     drawing     (lambda * 2.0))
                 metal1    drawing
                 (lambda * 2.0) (lambda * 2.0)
                 (1    1       contactSpacing contactSpacing center  center)
                 (lambda * 1.0) (lambda * 1.0) (inside nwell drawing))

          (M1_N  cc        drawing
                 nactive   drawing   (nselect     drawing     (lambda * 2.0))
                 metal1    drawing
                 (lambda * 2.0) (lambda * 2.0)
                 (1    1       contactSpacing contactSpacing center  center)
                 (lambda * 1.0) (lambda * 1.0) (outside nwell drawing))

          (NTAP  cc        drawing
                 nwell     drawing   (nselect     drawing     (lambda * -1.0))
                 metal1    drawing   (nactive     drawing     0)
                 (lambda * 2.0) (lambda * 2.0)
                 (1    1       contactSpacing contactSpacing center  center)
                 (lambda * 4.0) (lambda * 1.0) (inside nwell drawing))
        )
    )
)

symContactDevice(
  (M1_POLY cc     drawing
         poly      drawing
         metal1    drawing
         (lambda * 2.0) (lambda * 2.0)
         (1    1       contactSpacing contactSpacing center  center)
         (lambda * 1.0) (lambda * 1.0) _NA_)
)

if( npnAvailable then
    symContactDevice(
      (M1_COLLECTOR cc      drawing
                    cactive drawing
                    metal1  drawing
                    (lambda * 2.0) (lambda * 2.0)
                    (1    1       (lambda * 4.0) (lambda * 4.0) center  center)
                    (lambda * 2.0) (lambda * 1.0) _NA_)
    )
    symContactDevice(
      (M1_EMITTER cc      drawing
                  nselect drawing
                  metal1  drawing
                  (lambda * 2.0) (lambda * 2.0)
                  (1    1       (lambda * 4.0) (lambda * 4.0) center  center)
                  (lambda * 3.0) (lambda * 1.0) _NA_)
    )
    symContactDevice(
      (M1_BASE cc      drawing
               pselect drawing
               metal1  drawing
               (lambda * 2.0) (lambda * 2.0)
               (1    1       (lambda * 4.0) (lambda * 4.0) center  center)
               (lambda * 2.0) (lambda * 1.0) _NA_)
    )
)

if( polycapAvailable then
    symContactDevice(
      (M1_POLYCAP cc      drawing
                  polycap drawing
                  metal1  drawing
                  (lambda * 2.0) (lambda * 2.0)
                  (1    1       (lambda * 4.0) (lambda * 4.0) center  center)
                  (lambda * 2.0) (lambda * 1.0) _NA_)
    )
)

if( elecAvailable then
    symContactDevice(
      (M1_ELEC cc     drawing
               elec      drawing
               metal1    drawing
               (lambda * 2.0) (lambda * 2.0)
               (1    1       (lambda * 4.0) (lambda * 4.0) center  center)
               (lambda * 2.0) (lambda * 1.0) _NA_)
    )
)

if( deepAvailable then
symContactDevice(
  (M2_M1 via       drawing
         metal1    drawing
         metal2    drawing
         (lambda * 3.0) (lambda * 3.0)
         (1    1       (lambda * 6.0) (lambda * 6.0) center  center)
         (lambda * 1.0) (lambda * 1.0) _NA_)
  )

else 

symContactDevice(
  (M2_M1 via       drawing
         metal1    drawing
         metal2    drawing
         (lambda * 2.0) (lambda * 2.0)
         (1    1       (lambda * 5.0) (lambda * 5.0) center  center)
         (lambda * 1.0) (lambda * 1.0) _NA_)
  )
) 



if( cwellAvailable then
    symContactDevice(
      (M1_CAP cc       drawing
              metal1   drawing
              active   drawing
              (lambda * 2.0) (lambda * 2.0)
              (1    1       (lambda * 5.0) (lambda * 5.0) center  center)
              (lambda * 1.0) (lambda * 2.0) (inside cwell drawing))
    )
)

cond( 
        (metal6Available && deepAvailable
            
	    
	    symContactDevice(
            (M6_M5 via5    drawing
                 metal5    drawing
                 metal6    drawing
                 (lambda * 4.0) (lambda * 4.0)
                 (1    1       (lambda * 8.0) (lambda * 8.0) center  center)
                 (lambda * 1.0) (lambda * 2.0) _NA_)
            (M5_M4 via4    drawing
                 metal4    drawing
                 metal5    drawing
                 (lambda * 3.0) (lambda * 3.0)
                 (1    1       (lambda * 6.0) (lambda * 6.0) center  center)
                 (lambda * 1.0) (lambda * 1.0) _NA_)
            (M4_M3 via3      drawing
                 metal3    drawing
                 metal4    drawing
                 (lambda * 3.0) (lambda * 3.0)
                 (1    1       (lambda * 7.0) (lambda * 7.0) center  center)
                 (lambda * 1.0) (lambda * 1.0) _NA_)
            (M3_M2 via2      drawing
                 metal2    drawing
                 metal3    drawing
                 (lambda * 3.0) (lambda * 3.0)
                 (1    1       (lambda * 6.0) (lambda * 6.0) center  center)
                 (lambda * 1.0) (lambda * 1.0) _NA_)
            )
       
           )
	   
	 (metal6Available && submicronAvailable
	   
	   symContactDevice(
            (M6_M5 via5    drawing
                 metal5    drawing
                 metal6    drawing
                 (lambda * 3.0) (lambda * 3.0)
                 (1    1       (lambda * 7.0) (lambda * 7.0) center  center)
                 (lambda * 1.0) (lambda * 2.0) _NA_)
            (M5_M4 via4    drawing
                 metal4    drawing
                 metal5    drawing
                 (lambda * 2.0) (lambda * 2.0)
                 (1    1       (lambda * 5.0) (lambda * 5.0) center  center)
                 (lambda * 1.0) (lambda * 1.0) _NA_)
            (M4_M3 via3      drawing
                 metal3    drawing
                 metal4    drawing
                 (lambda * 2.0) (lambda * 2.0)
                 (1    1       (lambda * 6.0) (lambda * 6.0) center  center)
                 (lambda * 1.0) (lambda * 1.0) _NA_)
            (M3_M2 via2      drawing
                 metal2    drawing
                 metal3    drawing
                 (lambda * 2.0) (lambda * 2.0)
                 (1    1       (lambda * 5.0) (lambda * 5.0) center  center)
                 (lambda * 1.0) (lambda * 1.0) _NA_)
            )
       
        )
       
	  (metal5Available && deepAvailable
            symContactDevice(
            (M5_M4 via4    drawing
                 metal4    drawing
                 metal5    drawing
                 (lambda * 3.0) (lambda * 3.0)
                 (1    1       (lambda * 6.0) (lambda * 6.0) center  center)
                 (lambda * 1.0) (lambda * 1.0) _NA_)
            (M4_M3 via3      drawing
                 metal3    drawing
                 metal4    drawing
                 (lambda * 3.0) (lambda * 3.0)
                 (1    1       (lambda * 7.0) (lambda * 7.0) center  center)
                 (lambda * 1.0) (lambda * 1.0) _NA_)
            (M3_M2 via2      drawing
                 metal2    drawing
                 metal3    drawing
                 (lambda * 3.0) (lambda * 3.0)
                 (1    1       (lambda * 6.0) (lambda * 6.0) center  center)
                 (lambda * 1.0) (lambda * 1.0) _NA_)
            )
        )
      
      
      (metal5Available && submicronAvailable
            symContactDevice(
            (M5_M4 via4    drawing
                 metal4    drawing
                 metal5    drawing
                 (lambda * 2.0) (lambda * 2.0)
                 (1    1       (lambda * 5.0) (lambda * 5.0) center  center)
                 (lambda * 1.0) (lambda * 1.0) _NA_)
            (M4_M3 via3      drawing
                 metal3    drawing
                 metal4    drawing
                 (lambda * 2.0) (lambda * 2.0)
                 (1    1       (lambda * 6.0) (lambda * 6.0) center  center)
                 (lambda * 1.0) (lambda * 1.0) _NA_)
            (M3_M2 via2      drawing
                 metal2    drawing
                 metal3    drawing
                 (lambda * 2.0) (lambda * 2.0)
                 (1    1       (lambda * 5.0) (lambda * 5.0) center  center)
                 (lambda * 1.0) (lambda * 1.0) _NA_)
            )
        )
        
        
	(metal4Available
            symContactDevice(
              (M4_M3 via3      drawing
                     metal3    drawing
                     metal4    drawing
                     (lambda * 2.0) (lambda * 2.0)
                     (1    1       (lambda * 6.0) (lambda * 6.0) center  center)
                     (lambda * 1.0) (lambda * 2.0) _NA_)
              (M3_M2 via2      drawing
                     metal2    drawing
                     metal3    drawing
                     (lambda * 2.0) (lambda * 2.0)
                     (1    1       (lambda * 5.0) (lambda * 5.0) center  center)
                     (lambda * 1.0) (lambda * 1.0) _NA_)
            )
        )
        (metal3Available
            symContactDevice(
              (M3_M2 via2      drawing
                     metal2    drawing
                     metal3    drawing
                     (lambda * 2.0) (lambda * 2.0)
                     (1    1       (lambda * 5.0) (lambda * 5.0) center  center)
                     (lambda * 1.0) (lambda * 2.0) _NA_)
            )
        )
    )

;---------------- end contacts


;
; no depletion devices
;

;
; no enhancement devices - if we ever use LAS, then we'll need them...
;


/*
 * symbolic pins
 *
 * (name maskable layer1 purpose1 w1 layer2 purpose2 w2 legalRegion)
 */


cond(
    ( wellType == "P"
        symPinDevice(
            (pwell nil pwell drawing (lambda * 2.0) _NA_ _NA_ _NA_ _NA_)
        )
    )
    ( wellType == "E"
        symPinDevice(
            (pwell nil pwell drawing (lambda * 2.0) _NA_ _NA_ _NA_ _NA_)
            (nwell nil nwell drawing (lambda * 2.0) _NA_ _NA_ _NA_ _NA_)
        )
    )
    ( wellType == "N"
        symPinDevice(
            (nwell nil nwell drawing (lambda * 2.0) _NA_ _NA_ _NA_ _NA_)
        )
    )
)

symPinDevice(
  (nactive nil nactive drawing (lambda * 2.0) _NA_ _NA_ _NA_ _NA_)
  (pactive nil pactive drawing (lambda * 2.0) _NA_ _NA_ _NA_ _NA_)
  (active nil active drawing (lambda * 2.0) _NA_ _NA_ _NA_ _NA_)
  (poly nil poly drawing (lambda * 2.0) _NA_ _NA_ _NA_ _NA_)
  (metal1 nil metal1 drawing (lambda * 3.0) _NA_ _NA_ _NA_ _NA_)
  (metal2 nil metal2 drawing (lambda * 3.0) _NA_ _NA_ _NA_ _NA_)
)

if( npnAvailable then
    symPinDevice(
      (cactive nil cactive drawing (lambda * 2.0) _NA_ _NA_ _NA_ _NA_)
    )
)

if( hvAvailable then
    symPinDevice(
      (tactive nil tactive drawing (lambda * 2.0) _NA_ _NA_ _NA_ _NA_)
    )
)

if( cwellAvailable then
    symPinDevice(
      (cwell nil cwell drawing (lambda * 2.0) _NA_ _NA_ _NA_ _NA_)
    )
)

if( elecAvailable then
    symPinDevice(
      (elec nil elec drawing (lambda * 2.0) _NA_ _NA_ _NA_ _NA_)
    )
)

if( polycapAvailable then
    symPinDevice(
      (polycap nil polycap drawing (lambda * 2.0) _NA_ _NA_ _NA_ _NA_)
    )
)

if( metal3Available then
    symPinDevice(
      (metal3 nil metal3 drawing (lambda * 3.0) _NA_ _NA_ _NA_ _NA_)
    )
)

if( metal4Available then
    symPinDevice(
      (metal4 nil metal4 drawing (lambda * 3.0) _NA_ _NA_ _NA_ _NA_)
    )
)

if( metal5Available then
    symPinDevice(
      (metal5 nil metal5 drawing (lambda * 3.0) _NA_ _NA_ _NA_ _NA_)
    )
)

if( metal6Available then
    symPinDevice(
      (metal6 nil metal6 drawing (lambda * 3.0) _NA_ _NA_ _NA_ _NA_)
    )
)


;
; no ruleContact devices
;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Opus Symbolic Device Class Definition
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;
; no other device classes
;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Opus Symbolic Device Declaration
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;
; no other devices
;
  ) ; let

) ;devices

; vim:ts=4:columns=132:
