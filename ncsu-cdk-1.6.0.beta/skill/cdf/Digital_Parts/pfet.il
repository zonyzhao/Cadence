;==========================================================================
;
; $Id: pfet.il,v 1.1.1.1 2006/02/10 16:33:45 slipa Exp $
; 
; Revision History
;
; $Log: pfet.il,v $
; Revision 1.1.1.1  2006/02/10 16:33:45  slipa
; starting CDK v1.5.0rc1 source file
;
;
;--------------------------------------------------------------------------

/****************************************************/
 LIBRARY = "NCSU_Digital_Parts"
 CELL    = "pfet"
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
        ?name           "Gate"
        ?prompt         "For Standalone use"
        ?defValue       "Gate"
        ?type           "string"
        ?display        "t"
        ?editable       "nil"
    )
    cdfCreateParam( cdfId
        ?name           "Use"
        ?prompt         "NCSU_Analog_Parts"
        ?defValue       "Use"
        ?type           "string"
        ?display        "t"
        ?editable       "nil"
    )
    cdfCreateParam( cdfId
        ?name           "Only"
        ?prompt         "pmos or pmos4"
        ?defValue       "Only"
        ?type           "string"
        ?display        "t"
        ?editable       "nil"
    )
    cdfCreateParam( cdfId
        ?name           "model"
        ?prompt         "Model name"
        ?defValue       "pPar(\"pModel\")"
        ?type           "string"
        ?display        "nil"
        ?editable       "nil"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "bn"
        ?prompt         "Bulk node connection"
        ?defValue       "pPar(\"bp\")"
        ?type           "string"
        ?display        "nil"
        ?editable       "nil"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "w_microns"
        ?prompt         "Width (um)"
        ?defValue       "pPar(\"wp\") * 1e6"
        ?type           "string"
        ?display        "nil"
        ?editable       "nil"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "w"
        ?prompt         "Width"
        ?units          "lengthMetric"
        ?defValue       "pPar(\"wp\")"
        ?type           "string"
        ?display        "nil"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "l"
        ?prompt         "Length"
        ?units          "lengthMetric"
        ?defValue       "pPar(\"lp\")"
        ?type           "string"
        ?display        "nil"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "l_microns"
        ?prompt         "Length (um)"
        ?defValue       "pPar(\"lp\") * 1e6"
        ?type           "string"
        ?display        "nil"
        ?editable       "nil"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "ad"
        ?prompt         "Drain diffusion area"
        ?defValue       "pPar(\"wp\") * (pPar(\"MinL\")*2.5)"
        ?type           "string"
        ?display        "nil"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "as"
        ?prompt         "Source diffusion area"
        ?defValue       "pPar(\"wp\") * (pPar(\"MinL\")*2.5)"
        ?type           "string"
        ?display        "nil"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "pd"
        ?prompt         "Drain diffusion perimeter"
        ?units          "lengthMetric"
        ?defValue       "pPar(\"wp\")*2 + pPar(\"MinL\")*5"
        ?type           "string"
        ?display        "nil"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "ps"
        ?prompt         "Source diffusion perimeter"
        ?units          "lengthMetric"
        ?defValue       "pPar(\"wp\")*2 + pPar(\"MinL\")*5"
        ?type           "string"
        ?display        "nil"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "dleUseCell"
        ?prompt         "DLE Cell Name"
        ?defValue       "pPar(\"pDLEcell\")"
        ?type           "string"
        ?display        "nil"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "nrd"
        ?prompt         "Drain diffusion res squares"
        ?defValue       ""
        ?type           "string"
        ?display        "nil"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "nrs"
        ?prompt         "Source diffusion res squares"
        ?defValue       ""
        ?type           "string"
        ?display        "nil"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "ld"
        ?prompt         "Drain diffusion length"
        ?units          "lengthMetric"
        ?defValue       ""
        ?type           "string"
        ?display        "nil"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "ls"
        ?prompt         "Source diffusion length"
        ?units          "lengthMetric"
        ?defValue       ""
        ?type           "string"
        ?display        "nil"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "off"
        ?prompt         "Device initially off"
        ?defValue       t
        ?type           "boolean"
        ?display        "nil"
    )
    cdfCreateParam( cdfId
        ?name           "Vds"
        ?prompt         "Drain source initial voltage"
        ?units          "voltage"
        ?defValue       ""
        ?type           "string"
        ?display        "nil"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "Vgs"
        ?prompt         "Gate source initial voltage"
        ?units          "voltage"
        ?defValue       ""
        ?type           "string"
        ?display        "nil"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "Vbs"
        ?prompt         "Bulk source initial voltage"
        ?units          "voltage"
        ?defValue       ""
        ?type           "string"
        ?display        "nil"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "trise"
        ?prompt         "Temp rise from ambient"
        ?defValue       ""
        ?type           "string"
        ?display        "nil"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "region"
        ?prompt         "Estimated operating region"
        ?defValue       "sat"
        ?choices        '("off" "triode" "sat" "subth")
        ?type           "cyclic"
        ?display        "nil"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "rdc"
        ?prompt         "Additional drain resistance"
        ?units          "current"
        ?defValue       ""
        ?type           "string"
        ?display        "nil"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "rsc"
        ?prompt         "Additional source resistance"
        ?units          "current"
        ?defValue       ""
        ?type           "string"
        ?display        "nil"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "dtemp"
        ?prompt         "Temperature difference"
        ?defValue       ""
        ?type           "string"
        ?display        "nil"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )
    cdfCreateParam( cdfId
        ?name           "geo"
        ?prompt         "Source/drain selector"
        ?defValue       ""
        ?type           "string"
        ?display        "nil"
        ?parseAsNumber  "yes"
        ?parseAsCEL     "yes"
    )

    ;;; Simulator Information
    cdfId->simInfo = list( nil )
    cdfId->simInfo->auCdl = '( nil
        netlistProcedure  ansCdlCompPrim
        instParameters    (m L W)
        componentName     pmos
        termOrder         (D G S progn(bn))
        propMapping       (nil L l W w)
        namePrefix        "M"
        modelName         "PM"
    )
    cdfId->simInfo->auLvs = '( nil
        propMapping       nil
        netlistProcedure  ansLvsCompPrim
        instParameters    (m l w)
        componentName     pmos
        termOrder         (D G S progn(bn))
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
        otherParameters   (model bn)
        componentName     mosfet
        termOrder         (D G S progn(bn))
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
        componentName     hpmos
        termOrder         (D G S progn(bn))
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
        otherParameters   (bn model)
        instParameters    (w l as ad ps pd nrd nrs ld ls m trise region)
        termOrder         (D G S progn(bn))
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
        otherParameters   (bn model region)
        instParameters    (w l as ad ps pd nrd nrs ld ls m trise)
        termOrder         (D G S progn(bn))
        termMapping       (nil D d G g S s B b)
        namePrefix        "M"
        componentName     mos2
        current           port
    )
    cdfId->simInfo->switcap = '( nil )
    cdfId->simInfo->watscad = '( nil )

    ;;; Properties
    cdfId->formInitProc            = "PropDisplayOffCB"
    cdfId->doneProc                = ""
    cdfId->buttonFieldWidth        = 340
    cdfId->fieldHeight             = 35
    cdfId->fieldWidth              = 350
    cdfId->promptWidth             = 190
    cdfId->paramLabelSet           = "-Gate -Use -Only"
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
