;==========================================================================
;
; $Id: library.il,v 1.1.1.1 2006/02/10 16:33:45 slipa Exp $
; 
; Revision History
;
; $Log: library.il,v $
; Revision 1.1.1.1  2006/02/10 16:33:45  slipa
; starting CDK v1.5.0rc1 source file
;
;
;--------------------------------------------------------------------------

/****************************************************/
 LIBRARY = "NCSU_Digital_Parts"
/****************************************************/

let( ( libId cellId cdfId )
    unless( libId = ddGetObj( LIBRARY )
        error( "Could not get library %s." LIBRARY )
    )
    when( cdfId = cdfGetBaseLibCDF( libId )
        cdfDeleteCDF( cdfId )
    )
    cdfId  = cdfCreateBaseLibCDF( libId )

    ;;; Parameters
    cdfCreateParam( cdfId
        ?name           "DisplayGateProps"
        ?prompt         "Display Gate Type Part"
        ?defValue       "t"
        ?type           "boolean"
        ?display        "nil"
    )
    cdfCreateParam( cdfId
        ?name           "pModel"
        ?prompt         "PMOS Model"
        ?defValue       "pmos"
        ?type           "string"
        ?display        "(cdfgData->DisplayGateProps->value == t)"
        ?editable       "(cdfgData->ModelType->value == \"user\")"
    )
    cdfCreateParam( cdfId
        ?name           "nModel"
        ?prompt         "NMOS Model"
        ?defValue       "nmos"
        ?type           "string"
        ?display        "(cdfgData->DisplayGateProps->value == t)"
        ?editable       "(cdfgData->ModelType->value == \"user\")"
    )
    cdfCreateParam( cdfId
        ?name           "ModelType"
        ?prompt         "Model Type"
        ?defValue       "system"
        ?choices        '("system" "user")
        ?type           "radio"
        ?display        "(cdfgData->DisplayGateProps->value == t)"
        ?callback       "CheckFetModelCB()"
    )
    cdfCreateParam( cdfId
        ?name           "wp_microns"
        ?prompt         "PMOS Width (um)"
        ?defValue       ""
        ?type           "string"
        ?display        "nil"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "wp_grid"
        ?prompt         "PMOS Width (grid units)"
        ?defValue       0
        ?type           "int"
        ?display        "(cdfgData->DisplayGateProps->value == t)"
        ?editable       "t"
        ?callback       "CheckGridSizeCB(\"wp\")"
    )
    cdfCreateParam( cdfId
        ?name           "wp"
        ?prompt         "PMOS Width"
        ?units          "lengthMetric"
        ?defValue       ""
        ?type           "string"
        ?display        "(cdfgData->DisplayGateProps->value == t)"
        ?editable       "t"
        ?callback       "CheckMicronSizeCB(\"wp\")"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "wn_microns"
        ?prompt         "NMOS Width (um)"
        ?defValue       ""
        ?type           "string"
        ?display        "nil"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "wn_grid"
        ?prompt         "NMOS Width (grid units)"
        ?defValue       0
        ?type           "int"
        ?display        "(cdfgData->DisplayGateProps->value == t)"
        ?editable       "t"
        ?callback       "CheckGridSizeCB(\"wn\")"
    )
    cdfCreateParam( cdfId
        ?name           "wn"
        ?prompt         "NMOS Width"
        ?units          "lengthMetric"
        ?defValue       ""
        ?type           "string"
        ?display        "(cdfgData->DisplayGateProps->value == t)"
        ?editable       "t"
        ?callback       "CheckMicronSizeCB(\"wn\")"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "MinW"
        ?prompt         "Minimum Width"
        ?units          "lengthMetric"
        ?defValue       ""
        ?type           "string"
        ?display        "(cdfgData->DisplayGateProps->value == t)"
        ?editable       "nil"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "lp_grid"
        ?prompt         "PMOS Length (grid units)"
        ?defValue       0
        ?type           "int"
        ?display        "(cdfgData->DisplayGateProps->value == t)"
        ?editable       "t"
        ?callback       "CheckGridSizeCB(\"lp\")"
    )
    cdfCreateParam( cdfId
        ?name           "lp"
        ?prompt         "PMOS Length"
        ?units          "lengthMetric"
        ?defValue       ""
        ?type           "string"
        ?display        "(cdfgData->DisplayGateProps->value == t)"
        ?editable       "t"
        ?callback       "CheckMicronSizeCB(\"lp\")"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "ln_grid"
        ?prompt         "NMOS Length (grid units)"
        ?defValue       0
        ?type           "int"
        ?display        "(cdfgData->DisplayGateProps->value == t)"
        ?editable       "t"
        ?callback       "CheckGridSizeCB(\"ln\")"
    )
    cdfCreateParam( cdfId
        ?name           "ln"
        ?prompt         "NMOS Length"
        ?units          "lengthMetric"
        ?defValue       ""
        ?type           "string"
        ?display        "(cdfgData->DisplayGateProps->value == t)"
        ?editable       "t"
        ?callback       "CheckMicronSizeCB(\"ln\")"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "MinL"
        ?prompt         "Minimum Length"
        ?units          "lengthMetric"
        ?defValue       ""
        ?type           "string"
        ?display        "(cdfgData->DisplayGateProps->value == t)"
        ?editable       "nil"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "bp"
        ?prompt         "PMOS Bulk Node"
        ?defValue       "vdd!"
        ?type           "string"
        ?display        "(cdfgData->DisplayGateProps->value == t)"
        ?editable       "t"
    )
    cdfCreateParam( cdfId
        ?name           "bn"
        ?prompt         "NMOS Bulk Node"
        ?defValue       "gnd!"
        ?type           "string"
        ?display        "(cdfgData->DisplayGateProps->value == t)"
        ?editable       "t"
    )
    cdfCreateParam( cdfId
        ?name           "pDLEcell"
        ?prompt         "PMOS DLE layout cell"
        ?defValue       ""
        ?type           "string"
        ?display        "(cdfgData->DisplayGateProps->value == t)"
        ?callback       "CheckDLECellName()"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "nDLEcell"
        ?prompt         "NMOS DLE layout cell"
        ?defValue       ""
        ?type           "string"
        ?display        "(cdfgData->DisplayGateProps->value == t)"
        ?callback       "CheckDLECellName()"
        ?parseAsCEL     "yes"
    )

    ;;; Simulator Information
    cdfId->simInfo = list( nil )
    cdfId->simInfo->auCdl = '( nil )
    cdfId->simInfo->auLvs = '( nil )
    cdfId->simInfo->cdsSpice = '( nil )
    cdfId->simInfo->hpmns = '( nil )
    cdfId->simInfo->hspiceS = '( nil )
    cdfId->simInfo->libra = '( nil )
    cdfId->simInfo->mharm = '( nil )
    cdfId->simInfo->spectre = '( nil )
    cdfId->simInfo->spectreS = '( nil )
    cdfId->simInfo->switcap = '( nil )
    cdfId->simInfo->watscad = '( nil )

    ;;; Properties
    cdfId->formInitProc            = "SetFetDefaultsCB"
    cdfId->doneProc                = ""
    cdfId->buttonFieldWidth        = 340
    cdfId->fieldHeight             = 35
    cdfId->fieldWidth              = 350
    cdfId->promptWidth             = 175
    cdfSaveCDF( cdfId )
)
