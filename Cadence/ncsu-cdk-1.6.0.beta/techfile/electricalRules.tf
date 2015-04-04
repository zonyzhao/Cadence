;==========================================================================
;
; $Id: electricalRules.tf,v 1.1.1.1 2006/02/10 16:32:38 slipa Exp $
; 
; Revision History
;
; $Log: electricalRules.tf,v $
; Revision 1.1.1.1  2006/02/10 16:32:38  slipa
; starting CDK v1.5.0rc1 source file
;
; Revision 1.1  1997/04/04 23:46:50  jtschaff
; Initial revision
;
;
;--------------------------------------------------------------------------

;electricalRules(
;
;let( (lambda technology 
;      cwellAvailable analogAvailable metal3Available elecAvailable)
;
; lambda          = techParam( "lambda" )
; technology      = techParam( "technology" )
; cwellAvailable  = techParam( "cwellAvailable" )
; analogAvailable = techParam( "analogAvailable" )
; metal3Available = techParam( "metal3Available" )
; elecAvailable   = techParam( "elecAvailable" )
;
;
;/*
; * fill in values as appropriate...
; */
;
;case( technology
;/*
;    ( ("")
;        characterizationRules(
;               ;( rule              layer       value )
;                ; metal 1
;                ( areaCap           metal1      XX.XX )
;                ( currentDensity    metal1      XX.XX )
;                ( edgeCapacitance   metal1      XX.XX )
;                ( parallelCap       metal1      XX.XX )
;                ( sheetRes          metal1      XX.XX )
;                ; metal 2
;                ( areaCap           metal2      XX.XX )
;                ( currentDensity    metal2      XX.XX )
;                ( edgeCapacitance   metal2      XX.XX )
;                ( parallelCap       metal2      XX.XX )
;                ( sheetRes          metal2      XX.XX )
;        )
;    )
;*/
;/*
;    ( ("SCN3M_SUBM" "SCN3MLC_SUBM")
;       characterizationRules(
;              ;( rule              layer       value )
;               ; metal 1
;               ( areaCap           metal1      XX.XX )
;               ( currentDensity    metal1      XX.XX )
;               ( edgeCapacitance   metal1      XX.XX )
;               ( parallelCap       metal1      XX.XX )
;               ( sheetRes          metal1      XX.XX )
;               ; metal 2
;               ( areaCap           metal2      XX.XX )
;               ( currentDensity    metal2      XX.XX )
;               ( edgeCapacitance   metal2      XX.XX )
;               ( parallelCap       metal2      XX.XX )
;               ( sheetRes          metal2      XX.XX )
;               ; metal 3
;               ( areaCap           metal3      XX.XX )
;               ( currentDensity    metal3      XX.XX )
;               ( edgeCapacitance   metal3      XX.XX )
;               ( parallelCap       metal3      XX.XX )
;               ( sheetRes          metal3      XX.XX )
;       )
;    )
;*/
;)
;
;   ) ; let
;); electricalRules
