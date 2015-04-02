;==========================================================================
;
; $Id: physicalRules.tf,v 1.1.1.1 2006/02/10 16:32:38 slipa Exp $
; 
;--------------------------------------------------------------------------

physicalRules(

let( (lambda technology cwellAvailable metal3Available metal4Available
      metal5Available metal6Available elecAvailable hvAvailable
      submicronAvailable deepAvailable)

lambda          = techParam( "lambda" )
technology      = techParam( "technology" )
cwellAvailable  = techParam( "cwellAvailable" )
metal3Available = techParam( "metal3Available" )
metal4Available = techParam( "metal4Available" )
metal5Available = techParam( "metal5Available" )
metal6Available = techParam( "metal6Available" )
elecAvailable   = techParam( "elecAvailable" )
hvAvailable     = techParam( "hvAvailable" )

if( NCSU_techData[ technology ] == nil then
    hiGetAttention()
    error( "Unrecognizable \"technology\" property!" )
)

submicronAvailable = NCSU_techData[ technology ]->submicronRules
deepAvailable = NCSU_techData[ technology ]->deepRules

/*
 * Rule numbers refer to SCMOS rules
 */

/*
 * we aren't trying to do all the applicable rules here, since our setup
 * doesn't use them all yet (eg, we don't do P&R yet). the pcells do use
 * some of these.
 */

orderedSpacingRules(
    ; rule          layer 1     layer 2      value
    ( minEnclosure  nselect     active       (lambda * 2.0) ) ; 4.2
    ( minEnclosure  pselect     active       (lambda * 2.0) ) ; 4.2
    ( minEnclosure  nselect     ca           (lambda * 1.0) ) ; 4.3, ohmic
    ( minEnclosure  pselect     ca           (lambda * 1.0) ) ; 4.3, ohmic
    ( minEnclosure  nselect     cc           (lambda * 1.0) ) ; 4.3, ohmic
    ( minEnclosure  pselect     cc           (lambda * 1.0) ) ; 4.3, ohmic
    ( minEnclosure  active      ca           (lambda * 1.0) ) ; 6.2.b
    ( minEnclosure  active      cc           (lambda * 1.0) ) ; 6.2.b
    ( minEnclosure  poly        cp           (lambda * 1.0) ) ; 5.2.b
    ( minEnclosure  poly        cc           (lambda * 1.0) ) ; 5.2.b
    ( minEnclosure  active      via          (lambda * 2.0) ) ; 8.5 XXX
    ( minEnclosure  poly        via          (lambda * 2.0) ) ; 8.5 XXX
    ( minEnclosure  metal1      ca           (lambda * 1.0) ) ; 7.3
    ( minEnclosure  metal1      cp           (lambda * 1.0) ) ; 7.3
    ( minEnclosure  metal1      cc           (lambda * 1.0) ) ; 7.3
    ( minEnclosure  metal1      via          (lambda * 1.0) ) ; 8.3
    ( minEnclosure  metal2      via          (lambda * 1.0) ) ; 9.3
) ; orderedSpacingRules

; - the followings are for DEEP only
if( deepAvailable then
    orderedSpacingRules(
        ; rule          layer 1     layer 2      value
        ( minEnclosure  nselect     ca           (lambda * 1.5) ) ; 4.3, ohmic
        ( minEnclosure  pselect     ca           (lambda * 1.5) ) ; 4.3, ohmic
        ( minEnclosure  nselect     cc           (lambda * 1.5) ) ; 4.3, ohmic
        ( minEnclosure  pselect     cc           (lambda * 1.5) ) ; 4.3, ohmic
    ) ; orderedSpacingRules
else
    orderedSpacingRules(
        ; rule          layer 1     layer 2      value
        ( minEnclosure  nselect     ca           (lambda * 1.0) ) ; 4.3, ohmic
        ( minEnclosure  pselect     ca           (lambda * 1.0) ) ; 4.3, ohmic
        ( minEnclosure  nselect     cc           (lambda * 1.0) ) ; 4.3, ohmic
        ( minEnclosure  pselect     cc           (lambda * 1.0) ) ; 4.3, ohmic
    ) ; orderedSpacingRules
)

/*  exist a bug in compile SUBM library  corrected  -gma2

; - do not apply for DEEP, and maybe also some SUBM
if( ( ( !deepAvailable ) && ( ( metal3Available ) || ( !submicronAvailable ) ) ) then
    orderedSpacingRules(
        ; rule          layer 1     layer 2      value - soj
        ( minEnclosure  active      via          (lambda * 2.0) ) ; 8.5 XXX
        ( minEnclosure  poly        via          (lambda * 2.0) ) ; 8.5 XXX
    ) ; orderedSpacingRules
) */



; - do not apply for DEEP, and maybe also some SUBM
if( ( ( !deepAvailable ) && (  metal3Available  || ( !submicronAvailable ) ) ) then
    orderedSpacingRules(
        ; rule          layer 1     layer 2      value - soj
        ( minEnclosure  active      via          (lambda * 2.0) ) ; 8.5 XXX
        ( minEnclosure  poly        via          (lambda * 2.0) ) ; 8.5 XXX
    ) ; orderedSpacingRules
) 



orderedSpacingRules(
    ; these use [np]active to distinguish them from the "active" rules
    ; below (2.3) so the ohmic contact pcells can get this value, which
    ; is not the same as 2.3, which is needed by the MOSFET pcells
    ; rule          layer 1     layer 2      value
    ( minEnclosure  nwell       nactive      (lambda * 3.0) ) ; 2.4, ohmic
    ( minEnclosure  pwell       pactive      (lambda * 3.0) ) ; 2.4, ohmic
) ; orderedSpacingRules

; - add conditionals for DEEP
if( ( submicronAvailable || deepAvailable ) then
    orderedSpacingRules(
        ; rule          layer 1     layer 2      value
        ( minEnclosure  nwell       active       (lambda * 6.0) ) ; 2.3
        ( minEnclosure  pwell       active       (lambda * 6.0) ) ; 2.3
    ) ; orderedSpacingRules
else
    orderedSpacingRules(
        ; rule          layer 1     layer 2      value
        ( minEnclosure  nwell       active       (lambda * 5.0) ) ; 2.3
        ( minEnclosure  pwell       active       (lambda * 5.0) ) ; 2.3
    ) ; orderedSpacingRules
)

if( elecAvailable then
    orderedSpacingRules(
        ; rule          layer 1     layer 2      value
        ( minEnclosure  elec        ce           (lambda * 2.0) ) ; 13.4
        ( minEnclosure  metal1      ce           (lambda * 1.0) ) ; 7.3
        ( minEnclosure  elec        cc           (lambda * 2.0) ) ; 13.4
        ( minEnclosure  metal1      cc           (lambda * 1.0) ) ; 7.3
    )
) ; orderedSpacingRules

if( hvAvailable then
    orderedSpacingRules(
        ; rule          layer 1     layer 2      value
        ( minEnclosure  tactive     active       (lambda * 4.0) ) ; 24.3
    )
) ; orderedSpacingRules
    
; via-enclosure rules change a little depending on what the top-level metal is...
; "metal6" section is new addition
cond(
        (metal6Available
            orderedSpacingRules(
                ; rule          layer 1   layer 2   value
                ( minEnclosure  metal2    via2      (lambda * 1.0) ) ; 14.3
                ( minEnclosure  metal3    via2      (lambda * 1.0) ) ; 15.3
                ( minEnclosure  metal3    via3      (lambda * 1.0) ) ; 21.3
                ( minEnclosure  metal4    via3      (lambda * 1.0) ) ; 22.3
                ( minEnclosure  metal4    via4      (lambda * 1.0) ) ; 25.3
                ( minEnclosure  metal5    via4      (lambda * 1.0) ) ; 26.3
                ( minEnclosure  metal5    via5      (lambda * 1.0) ) ; 29.3
                ( minEnclosure  metal6    via5      (lambda * 2.0) ) ; 30.3
            )
        )

        (metal5Available
            orderedSpacingRules(
                ; rule          layer 1   layer 2   value
                ( minEnclosure  metal2    via2      (lambda * 1.0) ) ; 14.3
                ( minEnclosure  metal3    via2      (lambda * 1.0) ) ; 15.3
                ( minEnclosure  metal3    via3      (lambda * 1.0) ) ; 21.3
                ( minEnclosure  metal4    via3      (lambda * 1.0) ) ; 22.3
                ( minEnclosure  metal4    via4      (lambda * 1.0) ) ; 25.3
            )
            if( deepAvailable then
                orderedSpacingRules(
                ( minEnclosure  metal5    via4      (lambda * 2.0) ) ; 26.3 DEEP
                ) ; orderedSpacingRules
            else
                orderedSpacingRules(
                  ; rule          layer 1     layer 2      value
                ( minEnclosure  metal5    via4      (lambda * 1.0) ) ; 26.3
                ) ; orderedSpacingRules
            )
        )
        
	(metal4Available
            orderedSpacingRules(
                ; rule          layer 1   layer 2   value
                ( minEnclosure  metal2    via2      (lambda * 1.0) ) ; 14.3
                ( minEnclosure  metal3    via2      (lambda * 1.0) ) ; 15.3
                ( minEnclosure  metal3    via3      (lambda * 1.0) ) ; 21.3
                ( minEnclosure  metal4    via3      (lambda * 2.0) ) ; 22.3
            )
        )
        (metal3Available
            orderedSpacingRules(
            ; rule          layer 1   layer 2   value
            ( minEnclosure  metal2    via2      (lambda * 1.0) ) ; 14.3
            ( minEnclosure  metal3    via2      (lambda * 2.0) ) ; 15.3
            )
        )
    )

spacingRules(
    ; rule          layer1      layer2      value

    ; nwell
    ( minNotch      nwell                   (lambda * 6.0) ) ; 1.3
    ( minSpacing    nwell       active      (lambda * 3.0) )
    ( minSpacing    nwell       nactive     (lambda * 5.0) ) ; XXX

    ; pwell
    ( minNotch      pwell                   (lambda * 6.0) ) ; 1.3

    ; active
    ( minSpacing    active                  (lambda * 3.0) )
    ( minNotch      active                  (lambda * 3.0) )
    ( minWidth      active                  (lambda * 3.0) )

    ; selects
    ( minSpacing    nselect                 (lambda * 2.0) )
    ( minSpacing    pselect                 (lambda * 2.0) )
    ( minNotch      nselect                 (lambda * 2.0) )
    ( minNotch      pselect                 (lambda * 2.0) )
    ( minWidth      nselect                 (lambda * 2.0) ) ; 4.4
    ( minWidth      pselect                 (lambda * 2.0) ) ; 4.4

    ; poly
    ( minWidth      poly                    (lambda * 2.0) ) ; 3.1 
    ( minSpacing    poly        ca          (lambda * 2.0) ) ; 6.4
    ( minSpacing    poly        cc          (lambda * 2.0) ) ; 6.4

    ; metal1
    ( minSpacing    metal1                  (lambda * 3.0) ) ; 7.2.a
    ( minNotch      metal1                  (lambda * 3.0) ) ; 7.2.a
    ( minWidth      metal1                  (lambda * 3.0) ) ; 7.1

    ; metal2
    ( minWidth      metal2                  (lambda * 3.0) ) ; 9.1

    ; via
    ( minSpacing    via                     (lambda * 3.0) ) ; 8.2
) ; spacingRules

; - the following rules for SELECT are changed - DEEP is different
if( deepAvailable then
    spacingRules(
        ; rule          layer 1     layer 2      value
        ; selects
        ( minSpacing    nselect                 (lambda * 4.0) )
        ( minSpacing    pselect                 (lambda * 4.0) )
        ( minNotch      nselect                 (lambda * 4.0) )
        ( minNotch      pselect                 (lambda * 4.0) )
        ( minWidth      nselect                 (lambda * 4.0) ) ; 4.4
        ( minWidth      pselect                 (lambda * 4.0) ) ; 4.4
    ) ; spacingRules
else
    spacingRules(
        ; rule          layer 1     layer 2      value
        ; selects
        ( minSpacing    nselect                 (lambda * 2.0) )
        ( minSpacing    pselect                 (lambda * 2.0) )
        ( minNotch      nselect                 (lambda * 2.0) )
        ( minNotch      pselect                 (lambda * 2.0) )
        ( minWidth      nselect                 (lambda * 2.0) ) ; 4.4
        ( minWidth      pselect                 (lambda * 2.0) ) ; 4.4
    ) ; spacingRules
)

if( submicronAvailable then
    spacingRules(
        ; rule             layer1           value
        ( minSpacing       metal2           (lambda * 3.0) )  ; 9.2.b
        ( minNotch         metal2           (lambda * 3.0) )  ; 9.2.b
        ( minSpacing       ca               (lambda * 3.0) )  ; 6b.3
        ( minSpacing       cp               (lambda * 3.0) )  ; 5b.3
        ( minSpacing       cc               (lambda * 3.0) )  ; 5b.3
        ( minSpacing       poly             (lambda * 3.0) )  ; 3.2
        ( minWidth         nwell            (lambda * 12.0))  ; 1.1
        ( minWidth         pwell            (lambda * 12.0))  ; 1.1
        ( minSpacing       nwell            (lambda * 18.0))  ; 1.2
        ( minSpacing       pwell            (lambda * 18.0))  ; 1.2
    ) ; spacingRules
else
  if( deepAvailable then
    spacingRules(
        ; rule             layer1           value - again, DEEP is different
        ( minSpacing       metal2           (lambda * 4.0) )  ; 9.2.b
        ( minNotch         metal2           (lambda * 4.0) )  ; 9.2.b
        ( minSpacing       ca               (lambda * 4.0) )  ; 6b.3
        ( minSpacing       cp               (lambda * 4.0) )  ; 5b.3
        ( minSpacing       cc               (lambda * 4.0) )  ; 5b.3
        ( minSpacing       poly             (lambda * 4.0) )  ; 3.2 3 for field poly??
        ( minWidth         nwell            (lambda * 12.0))  ; 1.1
        ( minWidth         pwell            (lambda * 12.0))  ; 1.1
        ( minSpacing       nwell            (lambda * 18.0))  ; 1.2
        ( minSpacing       pwell            (lambda * 18.0))  ; 1.2
    ) ; spacingRules
else
    spacingRules(
        ; rule             layer1           value
        ( minSpacing       metal2           (lambda * 4.0) )  ; 9.2.a
        ( minNotch         metal2           (lambda * 4.0) )  ; 9.2.a
        ( minSpacing       ca               (lambda * 2.0) )  ; 6b.3
        ( minSpacing       cp               (lambda * 2.0) )  ; 5b.3
        ( minSpacing       cc               (lambda * 2.0) )  ; 5b.3
        ( minSpacing       poly             (lambda * 2.0) )  ; 3.2
        ( minWidth         nwell            (lambda * 10.0))  ; 1.1
        ( minWidth         pwell            (lambda * 10.0))  ; 1.1
        ( minSpacing       nwell            (lambda * 9.0))   ; 1.2
        ( minSpacing       pwell            (lambda * 9.0))   ; 1.2
    ) ; spacingRules
)  )


cond( 
; - additions for metal6 and DEEP
        (metal6Available
            spacingRules(
                 ; rule             layer1           value
                 ( minSpacing       metal6       (lambda * 4.0) )  ; 30.2
                 ( minNotch         metal6       (lambda * 4.0) )  ; 30.2
                 ( minWidth         metal6       (lambda * 4.0) )  ; 30.1
                 ( minSpacing       via5         (lambda * 4.0) )  ; 29.2
                 ( minSpacing       metal5       (lambda * 4.0) )  ; 26.2
                 ( minNotch         metal5       (lambda * 4.0) )  ; 26.2
                 ( minWidth         metal5       (lambda * 4.0) )  ; 26.1
                 ( minSpacing       via4         (lambda * 3.0) )  ; 25.2
                 ( minWidth         metal4       (lambda * 3.0) )  ; 22.1
                 ( minSpacing       via3         (lambda * 4.0) )  ; 21.2
                 ( minWidth         metal3       (lambda * 3.0) )  ; 15.1
                 ( minSpacing       via2         (lambda * 3.0) )  ; 14.2
            ) ; spacingRules
            if( deepAvailable then
                spacingRules(
                     ; rule             layer1           value - soj
                     ( minSpacing       metal4       (lambda * 4.0) )  ; 22.2
                     ( minNotch         metal4       (lambda * 4.0) )  ; 22.2
                     ( minSpacing       metal3       (lambda * 4.0) )  ; 15.2
                     ( minNotch         metal3       (lambda * 4.0) )  ; 15.2
                ) ; spacingRules
            else
                spacingRules(
                     ; rule             layer1           value
                     ( minSpacing       metal4       (lambda * 3.0) )  ; 22.2
                     ( minNotch         metal4       (lambda * 3.0) )  ; 22.2
                     ( minSpacing       metal3       (lambda * 3.0) )  ; 15.2
                     ( minNotch         metal3       (lambda * 3.0) )  ; 15.2
                ) ; spacingRules
            ) ; if
        ) ; metal6Available

        (metal5Available
            spacingRules(
                 ; rule             layer1           value
                 ( minSpacing       metal5       (lambda * 4.0) )  ; 26.2
                 ( minNotch         metal5       (lambda * 4.0) )  ; 26.2
                 ( minWidth         metal5       (lambda * 4.0) )  ; 26.1
                 ( minSpacing       via4         (lambda * 3.0) )  ; 25.2
                 ( minWidth         metal4       (lambda * 3.0) )  ; 22.1
                 ( minSpacing       via3         (lambda * 4.0) )  ; 21.2
                 ( minWidth         metal3       (lambda * 3.0) )  ; 15.1
                 ( minSpacing       via2         (lambda * 3.0) )  ; 14.2
            ) ; spacingRules
            if( deepAvailable then
                spacingRules(
                     ; rule             layer1           value - soj
                     ( minSpacing       metal4       (lambda * 4.0) )  ; 22.2
                     ( minNotch         metal4       (lambda * 4.0) )  ; 22.2
                     ( minSpacing       metal3       (lambda * 4.0) )  ; 15.2
                     ( minNotch         metal3       (lambda * 4.0) )  ; 15.2
                ) ; spacingRules
            else
                spacingRules(
                     ; rule             layer1           value
                     ( minSpacing       metal4       (lambda * 3.0) )  ; 22.2
                     ( minNotch         metal4       (lambda * 3.0) )  ; 22.2
                     ( minSpacing       metal3       (lambda * 3.0) )  ; 15.2
                     ( minNotch         metal3       (lambda * 3.0) )  ; 15.2
                ) ; spacingRules
            )
        )

        (metal4Available
            spacingRules(
                 ; rule             layer1           value
                 ( minSpacing       metal4       (lambda * 6.0) )  ; 22.2
                 ( minNotch         metal4       (lambda * 6.0) )  ; 22.2
                 ( minWidth         metal4       (lambda * 6.0) )  ; 22.1
                 ( minSpacing       via3         (lambda * 4.0) )  ; 21.2
                 ( minWidth         metal3       (lambda * 3.0) )  ; 15.1
                 ( minSpacing       via2         (lambda * 3.0) )  ; 14.2
            ) ; spacingRules
            if( deepAvailable then
                spacingRules(
                     ; rule             layer1           value - soj
                     ( minSpacing       metal3       (lambda * 4.0) )  ; 15.2
                     ( minNotch         metal3       (lambda * 4.0) )  ; 15.2
                ) ; spacingRules
            else
                spacingRules(
                     ; rule             layer1           value
                     ( minSpacing       metal3       (lambda * 3.0) )  ; 15.2
                     ( minNotch         metal3       (lambda * 3.0) )  ; 15.2
                ) ; spacingRules
            )
        )

        (metal3Available && ( submicronAvailable || deepAvailable )
            spacingRules(
                 ; rule             layer1           value
                 ( minSpacing       metal3       (lambda * 3.0) )  ; 15.2
                 ( minNotch         metal3       (lambda * 3.0) )  ; 15.2
                 ( minWidth         metal3       (lambda * 5.0) )  ; 15.1
                 ( minSpacing       via2         (lambda * 3.0) )  ; 14.2
            ) ; spacingRules
        )

        (metal3Available
             spacingRules(
                 ; rule             layer1           value
                 ( minSpacing       metal3       (lambda * 4.0) )  ; 15.2
                 ( minNotch         metal3       (lambda * 4.0) )  ; 15.2
                 ( minWidth         metal3       (lambda * 6.0) )  ; 15.1
                 ( minSpacing       via2         (lambda * 3.0) )  ; 14.2
           ) ; spacingRules
        )
    )

if( cwellAvailable then
    if( ( submicronAvailable || deepAvailable ) then
        spacingRules(
            ; rule             layer1           value
            ( minWidth         cwell          (lambda * 12.0)  )  ; 17.1
            ( minSpacing       cwell          (lambda * 18.0)  )  ; 17.2
            ( minNotch         cwell          (lambda * 18.0)  )  ; 17.2
        ) ; spacingRules
     else
        spacingRules(
            ; rule             layer1           value
            ( minWidth         cwell          (lambda * 10.0) )   ; 17.1
            ( minSpacing       cwell          (lambda * 9.0)  )   ; 17.2
            ( minNotch         cwell          (lambda * 9.0)  )   ; 17.2
        ) ; spacingRules
    )
)

if( elecAvailable then
    spacingRules(
        ; rule           layer1       value
        ( minSpacing     elec         (lambda * 3.0) )
        ( minNotch       elec         (lambda * 3.0) )
        ( minWidth       elec         (lambda * 2.0) )
    )
    if( submicronAvailable then
        spacingRules(
            ( minSpacing     ce           (lambda * 3.0) )
            ( minSpacing     cc           (lambda * 3.0) )
        ) ; spacingRules
; - addition for DEEP
    else
      if( deepAvailable then
        spacingRules(
            ( minSpacing     ce           (lambda * 4.0) )
            ( minSpacing     cc           (lambda * 4.0) )
        ) ; spacingRules
    else
        spacingRules(
            ( minSpacing     ce           (lambda * 2.0) )
            ( minSpacing     cc           (lambda * 2.0) )
        ) ; spacingRules
    )  )
)

; mfgGridResolution() requires a list argument
mfgGridResolution( list(lambda * 0.5) )

   ) ; let
); physicalRules
