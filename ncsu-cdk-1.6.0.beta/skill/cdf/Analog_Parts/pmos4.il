;==========================================================================
;
; $Id: pmos4.il,v 1.1.1.1 2006/02/10 16:33:45 slipa Exp $
; 
; Revision History
;
; $Log: pmos4.il,v $
; Revision 1.1.1.1  2006/02/10 16:33:45  slipa
; starting CDK v1.5.0rc1 source file
;
;
;--------------------------------------------------------------------------

/****************************************************/
 LIBRARY = "NCSU_Analog_Parts"
 CELL    = "pmos4"
/****************************************************/

let( ( libId cellId cdfId )
    unless( cellId = ddGetObj( LIBRARY CELL )
        error( "Could not get cell %s." CELL )
    )
    when( cdfId = cdfGetBaseCellCDF( cellId )
        cdfDeleteCDF( cdfId )
    )
    cdfId  = cdfCreateBaseCellCDF( cellId )

    ;;; Parameters
    cdfCreateParam( cdfId
        ?name           "model"
        ?prompt         "Model name"
        ?defValue       "pmos"
        ?type           "string"
        ?display        "artParameterInToolDisplay('model)"
        ?editable       "(cdfgData->ModelType->value == \"user\")"
    )
    cdfCreateParam( cdfId
        ?name           "ModelType"
        ?prompt         "Model Type"
        ?defValue       "system"
        ?choices        '("system" "user")
        ?type           "radio"
        ?display        "t"
        ?callback       "CheckFetModelCB()"
    )
    cdfCreateParam( cdfId
        ?name           "m"
        ?prompt         "Multiplier"
        ?defValue       1
        ?type           "int"
        ?display        "t"
        ?editable       "(cdfgData->fingers->value == 1)"
        ?callback       "ChangeMultiplierCB()"
    )
    cdfCreateParam( cdfId
        ?name           "fingers"
        ?prompt         "Fingers"
        ?defValue       1
        ?type           "int"
        ?display        "t"
        ?editable       "(cdfgData->m->value == 1)"
        ?callback       "ChangeFingersCB()"
    )
    cdfCreateParam( cdfId
        ?name           "w_microns"
        ?prompt         "Width (um)"
        ?defValue       ""
        ?type           "string"
        ?display        "nil"
        ?editable       "nil"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "w_grid"
        ?prompt         "Width (grid units)"
        ?defValue       0
        ?type           "int"
        ?callback       "CheckGridSizeCB(\"w\")"
    )
    cdfCreateParam( cdfId
        ?name           "w"
        ?prompt         "Width"
        ?units          "lengthMetric"
        ?defValue       ""
        ?type           "string"
        ?display        "artParameterInToolDisplay('w)"
        ?callback       "CheckMicronSizeCB(\"w\")"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "MinW"
        ?prompt         "Width (minimum)"
        ?units          "lengthMetric"
        ?defValue       ""
        ?type           "string"
        ?display        "t"
        ?editable       "nil"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "l_grid"
        ?prompt         "Length (grid units)"
        ?defValue       0
        ?type           "int"
        ?callback       "CheckGridSizeCB(\"l\")"
    )
    cdfCreateParam( cdfId
        ?name           "l"
        ?prompt         "Length"
        ?units          "lengthMetric"
        ?defValue       ""
        ?type           "string"
        ?display        "artParameterInToolDisplay('l)"
        ?callback       "CheckMicronSizeCB(\"l\")"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "l_microns"
        ?prompt         "Length (um)"
        ?defValue       ""
        ?type           "string"
        ?display        "nil"
        ?editable       "nil"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "MinL"
        ?prompt         "Length (minimum)"
        ?units          "lengthMetric"
        ?defValue       ""
        ?type           "string"
        ?display        "t"
        ?editable       "nil"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "ad"
        ?prompt         "Drain diffusion area"
        ?defValue       ""
        ?type           "string"
        ?display        "artParameterInToolDisplay('ad)"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "as"
        ?prompt         "Source diffusion area"
        ?defValue       ""
        ?type           "string"
        ?display        "artParameterInToolDisplay('as)"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "pd"
        ?prompt         "Drain diffusion perimeter"
        ?units          "lengthMetric"
        ?defValue       ""
        ?type           "string"
        ?display        "artParameterInToolDisplay('pd)"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "ps"
        ?prompt         "Source diffusion perimeter"
        ?units          "lengthMetric"
        ?defValue       ""
        ?type           "string"
        ?display        "artParameterInToolDisplay('ps)"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "nrd"
        ?prompt         "Drain diffusion res squares"
        ?defValue       ""
        ?type           "string"
        ?display        "artParameterInToolDisplay('nrd)"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "nrs"
        ?prompt         "Source diffusion res squares"
        ?defValue       ""
        ?type           "string"
        ?display        "artParameterInToolDisplay('nrs)"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "dleUseCell"
        ?prompt         "DLE layout cell"
        ?defValue       ""
        ?type           "string"
        ?display        "t"
        ?editable       "t"
        ?callback       "CheckDLECellName()"
    )
    cdfCreateParam( cdfId
        ?name           "ld"
        ?prompt         "Drain diffusion length"
        ?units          "lengthMetric"
        ?defValue       ""
        ?type           "string"
        ?display        "artParameterInToolDisplay('ld)"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "ls"
        ?prompt         "Source diffusion length"
        ?units          "lengthMetric"
        ?defValue       ""
        ?type           "string"
        ?display        "artParameterInToolDisplay('ls)"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "off"
        ?prompt         "Device initially off"
        ?type           "boolean"
        ?display        "artParameterInToolDisplay('off)"
    )
    cdfCreateParam( cdfId
        ?name           "Vds"
        ?prompt         "Drain source initial voltage"
        ?units          "voltage"
        ?defValue       ""
        ?type           "string"
        ?display        "artParameterInToolDisplay('Vds)"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "Vgs"
        ?prompt         "Gate source initial voltage"
        ?units          "voltage"
        ?defValue       ""
        ?type           "string"
        ?display        "artParameterInToolDisplay('Vgs)"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "Vbs"
        ?prompt         "Bulk source initial voltage"
        ?units          "voltage"
        ?defValue       ""
        ?type           "string"
        ?display        "artParameterInToolDisplay('Vbs)"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "trise"
        ?prompt         "Temp rise from ambient"
        ?defValue       ""
        ?type           "string"
        ?display        "artParameterInToolDisplay('trise)"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "region"
        ?prompt         "Estimated operating region"
        ?defValue       "sat"
        ?choices        '("off" "triode" "sat" "subth")
        ?type           "cyclic"
        ?display        "artParameterInToolDisplay('region)"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "rdc"
        ?prompt         "Additional drain resistance"
        ?units          "current"
        ?defValue       ""
        ?type           "string"
        ?display        "artParameterInToolDisplay('rdc)"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "rsc"
        ?prompt         "Additional source resistance"
        ?units          "current"
        ?defValue       ""
        ?type           "string"
        ?display        "artParameterInToolDisplay('rsc)"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "dtemp"
        ?prompt         "Temperature difference"
        ?defValue       ""
        ?type           "string"
        ?display        "artParameterInToolDisplay('dtemp)"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "geo"
        ?prompt         "Source/drain selector"
        ?defValue       ""
        ?type           "string"
        ?display        "artParameterInToolDisplay('geo)"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )

    ;;; Simulator Information
    cdfId->simInfo = list( nil )
    cdfId->simInfo->auCdl = '( nil
        netlistProcedure  ansCdlCompPrim
        instParameters    (m L W)
        componentName     pmos
        termOrder         (D G S B)
        propMapping       (nil L l W w)
        namePrefix        "M"
        modelName         "PM"
    )
    cdfId->simInfo->auLvs = '( nil
        propMapping       nil
        netlistProcedure  ansLvsCompPrim
        instParameters    (m l w)
        componentName     pmos
        termOrder         (D G S B)
        deviceTerminals   "D G S B"
        permuteRule       "(p D S)"
        namePrefix        "Q"
    )
    cdfId->simInfo->cdsSpice = '( nil
        termMapping       nil
        macroArguments    nil
        modelArguments    nil
        netlistProcedure  ansSpiceDevPrim
        instParameters    (m w l ad as pd ps nrd nrs ld ls off vds vgs vbs)
        otherParameters   (model)
        componentName     mosfet
        termOrder         (D G S B)
        propMapping       (nil vds Vds vgs Vgs vbs Vbs)
        namePrefix        "M"
        current           port
        dcSens            t
        acSens            t
    )
    cdfId->simInfo->hpmns = '( nil )
    cdfId->simInfo->hspiceS = '( nil
        termMapping       nil
        macroArguments    nil
        modelArguments    nil
        netlistProcedure  ansSpiceDevPrim
        instParameters    (l w ad as pd ps nrd nrs rdc rsc off Vds Vgs Vbs dtemp geo m)
        otherParameters   (bn model)
        componentName     hnmos
        termOrder         (D G S B)
        propMapping       (nil vds Vds vgs Vgs vbs Vbs)
        namePrefix        "M"
        current           port
        dcSens            t
        acSens            t
    )
    cdfId->simInfo->libra = '( nil )
    cdfId->simInfo->mharm = '( nil )
    cdfId->simInfo->spectre = '( nil
        macroArguments    nil
        modelArguments    nil
        propMapping       nil
        netlistProcedure  ansSpectreDevPrim
        otherParameters   (model)
        instParameters    (w l as ad ps pd nrd nrs ld ls m trise region)
        termOrder         (D G S B)
        termMapping       (nil D d G g S s B b)
        namePrefix        "M"
        componentName     mos2
        current           port
    )
    cdfId->simInfo->spectreS = '( nil
        macroArguments    nil
        modelArguments    nil
        propMapping       nil
        netlistProcedure  ansSpectreSDevPrim
        otherParameters   (model region)
        instParameters    (w l as ad ps pd nrd nrs ld ls m trise)
        termOrder         (D G S B)
        termMapping       (nil D d G g S s B b)
        namePrefix        "M"
        componentName     mos2
        current           port
    )
    cdfId->simInfo->switcap = '( nil )
    cdfId->simInfo->watscad = '( nil )

    ;;; Properties
    cdfId->formInitProc            = "SetFetDefaultsCB"
    cdfId->doneProc                = ""
    cdfId->buttonFieldWidth        = 340
    cdfId->fieldHeight             = 35
    cdfId->fieldWidth              = 350
    cdfId->promptWidth             = 190
    cdfId->paramLabelSet           = "-model w l m"
    cdfId->opPointLabelSet         = "id vgs vds"
    cdfId->modelLabelSet           = "vto kp gamma"
    cdfId->paramDisplayMode        = "parameter"
    cdfId->paramEvaluate           = "t nil nil nil nil"
    cdfId->paramSimType            = "DC"
    cdfId->termDisplayMode         = "netName"
    cdfId->termSimType             = "DC"
    cdfId->netNameType             = "schematic"
    cdfId->instDisplayMode         = "instName"
    cdfId->instNameType            = "schematic"
    cdfSaveCDF( cdfId )
)
