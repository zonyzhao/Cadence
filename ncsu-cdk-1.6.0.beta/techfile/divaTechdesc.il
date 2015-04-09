;==========================================================================
;
; $Id: divaTechdesc.il,v 1.1.1.1 2006/02/10 16:32:38 slipa Exp $
; 
;--------------------------------------------------------------------------

/********************************************************************************
 *                                                                              *
 *                                                                              *
 *                            Diva TechDesc Section                             *
 *                                                                              *
 *                                                                              *
 ********************************************************************************/


techdesc = LookupLibProp( "technology" nil )
if( techdesc == nil then
    hiGetAttention()
    error( "Can't find \"technology\" property!" )
)

if( NCSU_techData[ techdesc ] == nil then
    hiGetAttention()
    hiDisplayAppDBox( ?name 'TechLibPropError
                      ?dboxBanner "Library uses obsolete technology property"
                      ?dialogType hicErrorDialog
                      ?dialogStyle 'modeless
                      ?buttonLayout 'Close
                      ?dboxText
" Your design library was probably created using the \"Compile tech file\"\n
option in a version of the NCSU CDK prior to 1.0.\n
\n
As a result of the general cleanup for the 1.0 release of the NCSU CDK,\n
existing design libraries that were created using the \"Compile tech file\"\n
option (i.e., design libraries that are not linked to an SCMOS technology\n
library) need to change their \"technology\" property.\n
\n
Right-click on the library name in the Library Manager and choose\n
\"Properties...\". If you see a single field called \"techLibName\", cancel,\n
and apply this procedure to the library named in that field. Otherwise,\n
edit the \"technology\" field according to the list below:\n
\n
    SCNA_MEMS       -> ORBIT_SCNA2\n
    SCNPC           -> AMI_CWL\n
    SCNA            -> AMI_ABN_12\n
    SCN3ME_AMI_SUBM -> AMI_C5N\n
    SCN4M           -> HP_GMOS10QA\n
    SCN3MLC_SUBM    -> HP_AMOS14TB\n
    SCN3M_SUBM      -> HP_CMOS26G\n
    SCN5M_SUBM      -> TSMC_CMOS025\n
    SCN3ME_SUBM     -> TSMC_CMOS035_3M2P\n"
    )
    error( "Obsolete \"technology\" property! ")

    else

        padType = LookupLibProp( "PadType" nil )
        if( padType == nil then
            hiGetAttention()
            error( "Can't find \"PadType\" property!" )
        )
)


; vim:ts=4:columns=132:set tw=0:
