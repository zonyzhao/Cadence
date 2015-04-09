
; This file contains the definitions of the PUBLIC global IL variables that
; are redefinable by the user. 
;
; Global variables
;
schZoneFormatString = "%d%[?ABCDEFGHIJKLMNOPQRSTUVWXYZ]%d"
schZoneFormatValue = list(nil 'sheet 1 'yZone 2 'xZone 3)

; This IL structure describes the "indirection map" used by the schematic
; user interface (UI) to provide a simplified approach for selecting the
; border size of a schematic. 
;
; Choices can be added or deleted anytime before any schematic functionality 
; is executed in an interactive session. Do NOT change the structure of this
; "indirection map" since the UI form needs to read it in order to present 
; the choices to the user.
;
schSheetMasters = list( 

    ; Put choices for type of sheet border here. There can be as many
    ; choices as the user wants.
    ;
    list("basic" "continue")

    ; Put choices for symbolic sheet "size" here.  The first element of
    ; each choice's list should be the symbolic name for the sheet size
    ; which will be used on the UI form.  There should be an additional
    ; element for each available choice of sheet "type".  If a choice is
    ; 'nil' then it is considered an invalid choice.  To specify a choice
    ; that is valid but does not create a sheet border, use null strings
    ; (""). 
    ;
    ; Standard structure: 
    ;     list( SIZE_NAME
    ;         list( LIBRARY_NAME CELL_NAME VIEW_NAME ) => "basic"
    ;         list( LIBRARY_NAME CELL_NAME VIEW_NAME ) => "continue"
    ;	      etc, etc, ...
    ;     )
    ;
    ; Describing a valid "continue" choice, but an invalid "basic" choice:
    ;     list( SIZE_NAME
    ;         nil				       => "basic"
    ;         list( LIBRARY_NAME CELL_NAME VIEW_NAME ) => "continue"
    ;     )
    ;
    ; Describing valid choices that do not create borders:
    ;     list( SIZE_NAME
    ;         list("" "" "")
    ;         list("" "" ""))
    ;
    list("A" 	
        list("NCSU_Sheets_8ths" "Asize"   "symbol")
        list("NCSU_Sheets_8ths" "Asize.cont" "symbol"))
    list("A Book" 	
        list("NCSU_Sheets_8ths" "Asize.book"   "symbol")
        list("NCSU_Sheets_8ths" "Asize.book.cont" "symbol"))
    list("C" 	
        list("NCSU_Sheets_8ths" "Csize"   "symbol")
        list("NCSU_Sheets_8ths" "Csize.cont" "symbol"))
    list("E" 	
        list("NCSU_Sheets_8ths" "Esize"   "symbol")
        list("NCSU_Sheets_8ths" "Esize.cont" "symbol"))
    list("none"
        list("" "" "")
        list("" "" ""))
)

; This IL structure describes the "indirection map" used by the schematic
; user interface (UI) to provide a simplified approach for selecting the
; the pins to be placed in a schematic.
;
; Choices can be added or deleted anytime before any schematic functionality
; is executed in an interactive session. Do NOT change the structure of this
; "indirection map" since the UI form needs to read it in order to present 
; the choices to the user.
;
schPinMasters = list(

    ; Put choices for usage of the different pins here.  There can be as
    ; many choices as the user wants.  The choice "offSheet" is special
    ; in that pins of this usage can only be put on a sheet of a multisheet
    ; schematic.
    ;
    list(list("schematic" nil)  list("offSheet" t))

    ; Put choices for the symbolic "pin directions" here.  The first
    ; element of each choices' list should be the symbolic name for the
    ; pin which will be used on the UI form.  The second element of each
    ; choices' list should be the Terminal Direction as described by CDBA.
    ; There should be an additional element for each available choice of
    ; "pin directions".  If a choice is 'nil' then it is considered an
    ; invalid choice.
    ;
    ; Standard structure: 
    ;     list( SYMBOLIC_PIN_DIRECTION CDBA_TERMINAL_DIRECTION
    ;         list( LIBRARY_NAME CELL_NAME VIEW_NAME ) => "schematic"
    ;         list( LIBRARY_NAME CELL_NAME VIEW_NAME ) => "offSheet"
    ;         list( LIBRARY_NAME CELL_NAME VIEW_NAME ) => "jack"
    ;         list( LIBRARY_NAME CELL_NAME VIEW_NAME ) => "plug"
    ;	      etc, etc, ...
    ;     )
    ;
    list("input" "input"       
        list("basic" "ipin"   "symbol")
        list("basic" "ipin"   "symbolrOff"))
    list("output" "output"
        list("basic" "opin" "symbol")
        list("basic" "opin" "symbollOff"))
    list("inputOutput"  "inputOutput" 
        list("basic" "iopin"  "symbolr")
        list("basic" "iopin"  "symbolrOff"))
    list("switch" "switch"
        list("basic" "iopin"  "symbolr")
        list("basic" "iopin"  "symbolrOff"))
)

; This IL structure describes the "indirection map" used by the schematic
; user interface (UI) to provide a simplified approach for selecting the
; the pins to be placed in a symbol.
;
; Choices can be added or deleted anytime before any schematic functionality
; is executed in an interactive session. Do NOT change the structure of this
; "indirection map" since the UI form needs to read it in order to present 
; the choices to the user.
;
schSymbolPinMasters = list(

    ; Once only entry for the number of increments and their size:
    ;
    ;     list(LABEL_OFFSET_INCREMENT
    ;          MAX_NUMBER_OF_INCREMENTS)
    ;
    ; Standard structure: 
    ;
    ;     list(TYPE
    ;         list(CDBA_DIRECTION list(LIBRARY_NAME CELL_NAME VIEW_NAME))
    ;         list(CDBA_DIRECTION list(LIBRARY_NAME CELL_NAME VIEW_NAME))
    ;         list(CDBA_DIRECTION list(LIBRARY_NAME CELL_NAME VIEW_NAME))
    ;     )
    ;
    list(0.03125 32)

    list("square"
        list("input"       list("basic" "sympin" "symbolNN"))
        list("output"      list("basic" "sympin" "symbolNN"))
        list("inputOutput" list("basic" "sympin" "symbolNN")))
    list("round"
        list("input"       list("basic" "circle" "symbol"))
        list("output"      list("basic" "circle" "symbol"))
        list("inputOutput" list("basic" "circle" "symbol")))
    list("actHi"
        list("input"       list("basic" "actHiInp"   "symbol"))
        list("output"      list("basic" "actHiOut"   "symbol"))
        list("inputOutput" list("basic" "actHiInOut" "symbol")))
    list("commActLo"
        list("input"       list("basic" "commActLoInp"   "symbol"))
        list("output"      list("basic" "commActLoOut"   "symbol"))
        list("inputOutput" list("basic" "commActLoInOut" "symbol")))
    list("ieeeActLo"
        list("input"       list("basic" "ieeeActLoInp"   "symbol"))
        list("output"      list("basic" "ieeeActLoOut"   "symbol"))
        list("inputOutput" list("basic" "ieeeActLoInOut" "symbol"))
    )
    list("block"
        list("input"       list("basic" "blockipin"  "symbol"))
        list("output"      list("basic" "blockopin"  "symbol"))
        list("inputOutput" list("basic" "blockiopin" "symbol")))
)

; This IL structure describes the set of symbol labels used by the schematic
; user interface (UI) to provide a simplified approach for configuring the
; the symbol label attributes during the Add Symbol Label command
;
; Choices can be added or deleted anytime before any schematic functionality
; is executed in an interactive session. Do NOT change the structure of this
; since the UI form needs to read it in order to present the choices to 
; the user.
;
schSymbolLabelChoices = list(

    ; Put choices for the label choice and corresponding text, layer, purpose
    ; and type to be used during the Add Symbol Label command.
    ;
    ; Each label consists of :
    ;
    ;     label = list(choice text type layer purpose)
    ;
    ; where
    ;     choice - is an identifier used in forms to access this list to 
    ;              select the label attributes
    ;     text - is the label string
    ;     layer - is the layer name used for the label
    ;     purpose - is the labels purpose
    ;     type - is a dbLabelType : "normalLabel" "NLPLabel" "ILLabel"
    ;
    ; Standard structure: 
    ; list(
    ;     list( CHOICE list( TEXT TYPE LAYER_NAME PURPOSE))
    ;     list( CHOICE list( TEXT TYPE LAYER_NAME PURPOSE))
    ;     list( CHOICE list( TEXT TYPE LAYER_NAME PURPOSE))
    ;     etc, etc, ...
    ; )
    ;
    list("instance label"
        list("[@instanceName]" "NLPLabel" "instance" "label"))
    list("device annotate"
        list("[@refDes]" "NLPLabel" "device" "annotate"))
    list("logical label"
        list("[@partName]" "NLPLabel" "device" "label"))
    list("physical label"
        list("[@userPartName:%:[@phyPartName]]" "NLPLabel" "annotate" "drawing2"))
    list("pin name"
        list("{pinName}" "normalLabel" "pin" "label"))
    list("pin annotate"
        list("[@p_{pinName}]" "NLPLabel" "pin" "annotate"))
    list("other"
        list("" "normalLabel" "annotate" "drawing5"))
)

; This IL structure describes the "indirection map" used by the schematic
; user interface (UI) to provide a simplified approach for selecting the
; the views that can be translated in a schematic.
;
; Choices can be added or deleted anytime before any schematic functionality
; is executed in an interactive session. Do NOT change the structure of this
; "indirection map" since the UI form needs to read it in order to present 
; the choices to the user.
;

; Put choices for the view names and their translation routines here.
; The first element of each choice's list should be the view name to
; be translated from/to.  The seconds element should be the name of
; the skill routine for translating from this view to a pin list.  The
; final element should be the name of the skill routine for translating
; from a pin list to this view.  If a translation routine is 'nil' then
; translation in that direction is undefined.
;
; Standard structure: 
;     list(
;         list( VIEW_NAME TRANSLTE_TO TRANSLATE_FROM )
;         list( VIEW_NAME TRANSLTE_TO TRANSLATE_FROM )
;         list( VIEW_NAME TRANSLTE_TO TRANSLATE_FROM )
;	      etc, etc, ...
;     )
;
if( schIsHDLCapEnabled(nil) then
    schViewMasters = list(
        list("schematic"   "schSchemToPinList"   "schPinListToSchemGen")
        list("symbol"      "schSymbolToPinList"  "schPinListToSymbolGen")
        list("functional"  "schVerilogToPinList" "schPinListToVerilog")
        list("behavioral"  "schVerilogToPinList" "schPinListToVerilog")
        list("system"      "schVerilogToPinList" "schPinListToVerilog")
        list("entity.vhdl" "schVHDLToPinList"    "schPinListToVHDL")
        list("abel"        nil                   "pldPinListToAbel")
    )
else
    schViewMasters = list(
        list("schematic"   "schSchemToPinList"   "schPinListToSchem")
        list("symbol"      "schSymbolToPinList"  "schPinListToSymbolGen")
        list("abel"        nil                   "pldPinListToAbel")
    )
)
if( schIsHDLCapEnabled(nil) then

    ; Standard structure:
    ;     list(
    ;         list( VIEW_NAME OPTIONS_FUNC)
    ;         etc, etc, ...
    ;     )
    ;
    ; Put choices for the view names and their translation routine here.
    ;
    schViewMastersOptionFunc = list(
        list("schematic"	nil)
        list("symbol"	"schDisplaySymbolTemplateForm")
        list("functional"	nil)
        list("behavioral"	nil)
        list("system"	nil)
        list("entity.vhdl"	nil)
        list("abel"		nil)
    )
else
    schViewMastersOptionFunc = list(
        list("schematic"	nil)
        list("symbol"	"schDisplaySymbolTemplateForm")
        list("abel"		nil)
    )
)
schHDLSwitchList = list(
    "functional" "behavioral" "system" "abel"
    "entity.vhdl" "behavior.vhdl" "dataflow.vhdl" "structure.vhdl" 
    "mixed.vhdl"
)

; This IL structure describes the set of block samples used by the schematic
; user interface (UI) to provide a simplified approach for selecting the
; the block sizes during top-down block creation.
;
; Choices can be added or deleted anytime before any schematic functionality
; is executed in an interactive session. Do NOT change the structure of this
; since the UI form needs to read it in order to present the choices to 
; the user.
;
schBlockTemplate = list(

    ; Put choices for the block sample names, sizes, and labels here which
    ; are used during block creation.
    ;
    ; It consists of a list of blockSamples :
    ;
    ;     blockSample = list(blockName blockSize labelList)
    ;
    ; where blockName is string identifying the blockSample.
    ;     blockSize is described as length and height of block
    ;         (user units)
    ;     labelList is list of label descriptions
    ; 
    ; Each label consists of :
    ;
    ;     label = list(text choice height font type)
    ;
    ; where text is the label string
    ;     choice is one of: "instance label", "logical label", 
    ;                       "physical label", "pin label", 
    ;                       "device annotate", "pin annotate"
    ;     height is in user units
    ;     font is a dbFontStyle : "stick", "fixed", "large", etc.
    ;     type is a dbLabelType : "normalLabel" "NLPLabel" "ILLabel"
    ;
    ;
    ; Standard structure: 
    ; list(
    ;     list( BLOCK_NAME  
    ;         list( pt1 pt2 pt3 pt4 ... ) 
    ;             list(
    ;                 list( TEXT CHOICE HEIGHT FONT TYPE)
    ;                 list( TEXT CHOICE HEIGHT FONT TYPE)
    ;                 list( TEXT CHOICE HEIGHT FONT TYPE)
    ;                 etc, etc, ...
    ;             )
    ;     )
    ;     list( BLOCK_NAME  
    ;         list( LENGTH HEIGHT )
    ;         list(
    ;             list( TEXT CHOICE HEIGHT FONT TYPE)
    ;             list( TEXT CHOICE HEIGHT FONT TYPE)
    ;             list( TEXT CHOICE HEIGHT FONT TYPE)
    ;             etc, etc, ...
    ;             )
    ;	  )
    ;     etc, etc, ...
    ; )
    ;
    list("freeform" 
        list(0:0 0:0) 
        list(
         list("[@instanceName]" "instance label" .08125 "stick" "NLPLabel")
         list("[@cellName]" "logical label" .08125 "stick" "NLPLabel")))
    list("small"
        list(0.0:0.0 1.0:1.0) 
        list(
   	     list("[@instanceName]" "instance label" .075 "stick" "NLPLabel")
         list("[@cellName]"     "logical label"  .075 "stick" "NLPLabel")))
    list("medium"
        list(0.0:0.0 1.5:1.5) 
        list(
         list("[@instanceName]" "instance label" .08125 "stick" "NLPLabel")
         list("[@cellName]"    "logical label" .08125 "stick" "NLPLabel")))
    list("large" 
        list(0.0:0.0 2.0:2.0) 
        list(
  	     list("[@instanceName]" "instance label" .125 "stick" "NLPLabel")
         list("[@cellName]"     "logical label"  .125 "stick" "NLPLabel")))
    list("2 by 1"	 	
        list(0.0:0.0 1.5:0.75) 
        list(
         list("[@instanceName]" "instance label" .08125 "stick" "NLPLabel")
         list("[@cellName]"    "logical label" .08125 "stick" "NLPLabel")))
    list("1 by 2"	 	
        list(0.0:0.0 0.75:1.5) 
        list(
         list("[@instanceName]" "instance label" .08125 "stick" "NLPLabel")
         list("[@cellName]"    "logical label" .08125 "stick" "NLPLabel")))
    list("alu" 
        list(0.625:0.000 1.375:0.000 2.000:0.750
    	 1.375:0.750 1.000:0.375 0.625:0.750 0.0:0.750) 
        list(
         list("[@instanceName]" "instance label" .08125 "stick" "NLPLabel")
         list("[@cellName]"    "logical label" .08125 "stick" "NLPLabel")))
    list("mux4" 
        list(0.0:0.0 0.0:1.5 0.5:1.25 0.5:0.25) 
        list(
         list("[@instanceName]" "instance label" .08125 "stick" "NLPLabel")
         list("[@cellName]"    "logical label" .08125 "stick" "NLPLabel")))
    list("mux8" 
        list(0.0:0.0 0.0:3.0 0.75:2.5 0.75:0.5) 
        list(
         list("[@instanceName]" "instance label" .08125 "stick" "NLPLabel")
         list("[@cellName]"    "logical label" .08125 "stick" "NLPLabel")))
)

; Block template for metric tech file (2mm pin-to-pin spacing)
; (Comment this out to use and insure that metric libraries are in place)
;
;   schBlockTemplate = list(
;       list("freeform" 
; 	    list(0:0 0:0)
; 	    list(
; 	     list("[@instanceName]" "instance label" 1.6 "stick" "NLPLabel") 
; 	     list("[@cellName]"     "logical label"  1.6 "stick" "NLPLabel")))
;       list("small" 
; 	    list(0.0:0.0 16.0:16.0)
; 	    list( 
; 	     list("[@instanceName]" "instance label" 1.2 "stick" "NLPLabel") 
; 	     list("[@cellName]"     "logical label"  1.2 "stick" "NLPLabel")))
;       list("medium" 
; 	    list(0.0:0.0 24.0:24.0)
; 	    list(
; 	     list("[@instanceName]" "instance label" 1.6 "stick" "NLPLabel") 
; 	     list("[@cellName]"     "logical label"  1.6 "stick" "NLPLabel"))) 
;       list("large" 
; 	    list(0.0:0.0 32.0:32.0)
; 	    list(
;            list("[@instanceName]" "instance label" 2.0 "stick" "NLPLabel") 
; 	     list("[@cellName]"     "logical label"  2.0 "stick" "NLPLabel"))) 
;       list("2 by 1" 
; 	    list(0.0:0.0 24.0:12.0)
; 	    list(
;            list("[@instanceName]" "instance label" 1.2 "stick" "NLPLabel") 
; 	     list("[@cellName]"      "logical label" 1.2 "stick" "NLPLabel")))
;       list("1 by 2" 
; 	    list(0.0:0.0 12.0:24.0)
; 	    list(
;            list("[@instanceName]" "instance label" 1.2 "stick" "NLPLabel") 
; 	     list("[@cellName]"      "logical label" 1.2 "stick" "NLPLabel"))) 
;       list("alu" 
; 	    list(10.0:0.0 22.0:0.0 32.0:12.0 22.0:12.0
; 	         16.0:6.0 10.0:12.0 0.0:12.0)
; 	    list(
;            list("[@instanceName]" "instance label" 1.2 "stick" "NLPLabel") 
; 	     list("[@cellName]"      "logical label" 1.2 "stick" "NLPLabel"))) 
;       list("mux4" 
; 	    list(0.0:0.0 0.0:24.0 8.0:20.0 8.0:4.0)
; 	    list(
;            list("[@instanceName]" "instance label" 1.2 "stick" "NLPLabel") 
; 	     list("[@cellName]"      "logical label" 1.2 "stick" "NLPLabel"))) 
;       list("mux8" 
; 	    list(0.0:0.0 0.0:48.0 12.0:40.0 12.0:8.0)
; 	    list(
;            list("[@instanceName]" "instance label" 1.2 "stick" "NLPLabel") 
; 	     list("[@cellName]"      "logical label" 1.2 "stick" "NLPLabel"))) 
;   )
;

; Block template for metric tech file (2.5mm pin-to-pin spacing)
; (Comment this out to use and insure that metric libraries are in place)
;
;   schBlockTemplate = list(
;       list("freeform" 
; 	    list(0:0 0:0)
; 	    list(
;            list("[@instanceName]" "instance label" 1.6 "stick" "NLPLabel") 
; 	     list("[@cellName]"     "logical label"  1.6 "stick" "NLPLabel"))) 
;       list("small" 
; 	    list(0.0:0.0 20.0:20.0)
; 	    list(
;            list("[@instanceName]" "instance label" 1.2 "stick" "NLPLabel") 
; 	     list("[@cellName]"     "logical label"  1.2 "stick" "NLPLabel"))) 
;       list("medium" 
; 	    list(0.0:0.0 30.0:30.0)
; 	    list(
; 	     list("[@instanceName]" "instance label" 2.0 "stick" "NLPLabel") 
; 	     list("[@cellName]"     "logical label"  2.0 "stick" "NLPLabel"))) 
;       list("large" 
; 	    list(0.0:0.0 40.0:40.0)
; 	    list(
; 	     list("[@instanceName]" "instance label" 2.5 "stick" "NLPLabel") 
; 	     list("[@cellName]"     "logical label"  2.5 "stick" "NLPLabel"))) 
;       list("2 by 1"  
; 	    list(0.0:0.0 30.0:15.0)
; 	    list(
; 	     list("[@instanceName]" "instance label" 1.6 "stick" "NLPLabel") 
; 	     list("[@cellName]"     "logical label"  1.6 "stick" "NLPLabel")))
;       list("1 by 2" 
; 	    list(0.0:0.0 15.0:30.0)
; 	    list(
; 	     list("[@instanceName]" "instance label" 1.6 "stick" "NLPLabel") 
; 	     list("[@cellName]"     "logical label" 1.6 "stick" "NLPLabel"))) 
;       list("alu" 
; 	    list(12.5:0.0 27.5:0.0 40.0:15.0 27.5:15.0
; 	         20.0:7.5 12.5:15.0 0.0:15.0)
; 	    list(
; 	     list("[@instanceName]" "instance label" 1.6 "stick" "NLPLabel") 
; 	     list("[@cellName]"     "logical label" 1.6 "stick" "NLPLabel"))) 
;       list("mux4" 
; 	    list(0.0:0.0 0.0:30.0 10.0:25.0 10.0:5.0)
; 	    list(
; 	     list("[@instanceName]" "instance label" 1.2 "stick" "NLPLabel") 
; 	     list("[@cellName]"     "logical label" 1.2 "stick" "NLPLabel"))) 
;       list("mux8" 
; 	    list(0.0:0.0 0.0:60.0 15.0:50.0 15.0:10.0)
; 	    list(
; 	     list("[@instanceName]" "instance label" 1.6 "stick" "NLPLabel") 
; 	     list("[@cellName]"     "logical label" 1.6 "stick" "NLPLabel"))) 
;   )

; This IL structure describes the mapping of block edge to pin type and
; direction. This map is used by schematic user interface (UI) to provide 
; a simplified approach for selecting the pin direction which is implied 
; by connecting to a specific edge of a block.
;
schBlockPinAttrs = list(

    ; The first element is the name of the pin "type".  The "type"
    ; and "direction" uniquely identify a pin master in the
    ; schSymbolPinMasters map.
    ;
    ; Put choices here for the pin directions which should be applied to
    ; new pins created when connecting up to edge of a block.
    ;
    ; It consists of a list of pairs: 
    ;     EDGE_DIRECTION  CDBA_TERMINAL_DIRECTION
    ;
    ; where EDGE_DIRECTION is one of: "left" "right" "bottom" "top"
    ;
    ; Standard structure: 
    ; list(
    ;      list( EDGE_DIRECTION CDBA_TERMINAL_DIRECTION )
    ;      list( EDGE_DIRECTION CDBA_TERMINAL_DIRECTION )
    ;	   etc, etc, ...
    ;     )
    ;
    "block"
    list("left"   "input")
    list("right"  "output")
    list("bottom" "inputOutput")
    list("top"    "inputOutput")
)

; This IL structure describes the "indirection map" used by the schematic user
; interface (UI) to provide a flexible, simplified approach for initializing
; the severities and values for the various SRC checks.
;
;
schSRCPackagedChecks = list(
    list("Normal"
        list("floatingNets"      "warning")
        list("floatingInput"     "warning")
        list("floatingOutput"    "ignored")
        list("floatingIO"        "warning")
        list("floatingSwitch"    "warning")
        list("shortedOutputs"    "warning")
        list("unconnectedWires"  "ignored")
        list("solderOnCrossover" "warning")
        list("instOverlap"       "ignored")
        list("instOverlapValue"  0)
        list("maxLabelOffset"    "ignored")
        list("maxLabelOffsetUU"  0.0)
        list("nameCollision"     "warning")
        list("verilogSyntax"     "ignored")
        list("VHDLSyntax"        "ignored")
        list("instNameSyntax"    "ignored")
        list("termNameSyntax"    "ignored")
        list("netNameSyntax"     "ignored")
    )
    list("Logical Only"
        list("floatingNets"      "warning")
        list("floatingInput"     "warning")
        list("floatingOutput"    "ignored")
        list("floatingIO"        "warning")
        list("floatingSwitch"    "warning")
        list("shortedOutputs"    "warning")
        list("unconnectedWires"  "ignored")
        list("solderOnCrossover" "ignored")
        list("instOverlap"       "ignored")
        list("maxLabelOffset"    "ignored")
        list("nameCollision"     "ignored")
        list("verilogSyntax"     "ignored")
        list("VHDLSyntax"        "ignored")
        list("instNameSyntax"    "ignored")
        list("termNameSyntax"    "ignored")
        list("netNameSyntax"     "ignored")
    )
    list("Physical Only"
        list("floatingNets"      "ignored")
        list("floatingInput"     "ignored")
        list("floatingOutput"    "ignored")
        list("floatingIO"        "ignored")
        list("floatingSwitch"    "ignored")
        list("shortedOutputs"    "ignored")
        list("unconnectedWires"  "warning")
        list("solderOnCrossover" "warning")
        list("instOverlap"       "ignored")
        list("instOverlapValue"  0)
        list("maxLabelOffset"    "ignored")
        list("maxLabelOffsetUU"  0.0)
        list("nameCollision"     "ignored")
        list("verilogSyntax"     "ignored")
        list("VHDLSyntax"        "ignored")
        list("verilogSyntax"     "ignored")
        list("instNameSyntax"    "ignored")
        list("termNameSyntax"    "ignored")
        list("netNameSyntax"     "ignored")
    )
    list("VHDL"
        list("nameCollision"     "warning")
        list("verilogSyntax"     "ignored")
        list("VHDLSyntax"        "warning")
    )
    list("Verilog"
        list("nameCollision"     "warning")
        list("verilogSyntax"     "warning")
        list("VHDLSyntax"        "ignored")
    )
)

; This IL structure describes the "indirection map" used by the schematic user
; interface (UI) to provide a flexible, simplified approach for 
; entering property names for the Select By Property/Replace and Find commands.
;
;  Syntax :
;      schSelPropertyNameList = list( viewProperties )
;      viewProperties = list( viewName propertyList)
;      propertyList   = list( aliasName realPropName )
;
;      where:
;               viewName is the cellViewType, valid values
;                    are "schematic" and "schematicSymbol"
;               aliasName is the name to be shown in the cyclic
;                            field on the form.
;               realPropName is the actual propertyName which will
;                          be searched for in the database.
;
schSelPropertyNameList = list(
    list("schematic" 
        list(
    	list("instName" "name"
    	    list('("objType" "inst") '("purpose" "cell")))
    	list("netName" "name" list('("objType" "net")))
    	list("pinName" "name" list('("objType" "term")))
    	list("master" "master")
    	list("libName" "libName")
    	list("cellName" "cellName")
    	list("fontStyle" "font")
    	list("fontHeight" "height")
    	list("orient" "orient")
    	list("partName" "partName")
    	list("phyPartName" "phyPartName")
    	list("power" "power")
    	list("refDes" "refDes")
    	list("technology" "technology")
    	list("simMonitor" "schSimSignalName" list('("objType" "inst")))
        )
    )
    list("schematicSymbol"
        list(list("pinName" "name" list('("objType" "net")))
    	 list("fontStyle" "font")
    	 list("fontHeight" "height")
    	 list("orient" "orient")
    	 list("layer" "layerName")
        )
    )
)

; This IL structure describes the "indirection map" used by the schematic
; user interface (UI) to provide a simplified approach for selecting the
; simulation probe to be used for a specified format.
;
; Choices can be added or deleted anytime before any schematic functionality
; is executed in an interactive session. Do NOT change the structure of this
; "indirection map" since the UI form needs to read it in order to present 
; the choices to the user.
;
schSimProbeMasters = list(

    ; This list consist of simulation display format/cellview pairs.
    ; The first element contains the format string that will appear
    ; in the cyclic field of the create display box form.  The second
    ; element is a list of library, cellname, cellview which specifies
    ; the master which will be used for this format.
    ;
    ; Standard structure: 
    ;     list(
    ;         list( PROBE_FORMAT list( LIBRARY_NAME CELL_NAME VIEW_NAME ))
    ;         list( PROBE_FORMAT list( LIBRARY_NAME CELL_NAME VIEW_NAME ))
    ;         list( PROBE_FORMAT list( LIBRARY_NAME CELL_NAME VIEW_NAME ))
    ;	      etc, etc, ...
    ;     )
    ;
    list("<state>"		list("basic" "simState"   "symbol"))
    list("<time>:<state>"	list("basic" "simState" "symbol"))
    list("<name>=<state>"	list("basic" "simState"  "symbol"))
    list("<name>=<time>:<state>" list("basic" "simState"  "symbol"))
)

; This IL variable describes the "indirection map" used by the schematic
; user interface (UI) to provide a simplified approach for excluding 
; schematicSymbol views from being cycled through in schHiCreateInst
; 
schCycleViewNameExclusionList = list(
    "ta" "silos" "hspice" "shilo" "package" ".moduleInfo" 
    "pcb" "verilog" "lai_verilog" "lmsi_verilog"
)

; The following variables control VHDL and Verilog editting and processing.
;
;---------------------------------------------------
;              VHDL,Verilog Edit
;
; Application: VHDL, Verilog
; Description: Re-edit VHDL or Verilog description if syntax error is found.
; Example    : schHdlEditAfterError = nil
;
schHdlEditAfterError = t

; Application: VHDL
; Description: Perform VSH "analyze" command after editting VHDL object.
;              This is a tri-state flag: t | nil | "query".
; Example    : schHdlEditAfterError = "query"
;
schVHDLAnalyzeAfterEdit = t

;---------------------------------------------------
;           V/HDL Cross View Checking
;
; Application: VHDL, Verilog
; Description: Enable/disable cross view checking after 
;              editting Verilog or VHDL. If enabled, cross view 
;              checks are performed after editting Verilog or VHDL.
; Example    : schHdlCrossViewCheck = nil ; disable xview checks
;
schHdlCrossViewCheck = t

; Application: VHDL, Verilog
; Description: If cross view checking is enabled, all views are checked
;	       against the editted view.  Use schHdlCrossViewString to
;	       specify a particular set of views to check. A nil value
;	       or "" causes all views to be checked.
; Example:     schHdlCrossViewString = "schematic symbol"
;
schHdlCrossViewString = "" 

;----------------------------------------------------
;                   HDL Printing 
;
; Application: VHDL, Verilog
; Description: UNIX command used by Design->Print menu item
;              in HDL/VHDL view window.
; Example: ;   schHdlPrintCommand = "lw -Plw1"
;
schHdlPrintCommand = "lpr"

;---------------------------------------------------
;                Verilog Diagnostics 
;
; Application: Verilog
; Description: Print out diagnostic messages while the Verilog text is
;	       parsed and processed.  This is a tri-state flag: 
;              t | nil | "all". If hdlVerbose is set to "all", a detailed 
;              description of the pseudo schematic is displayed in the ciw.
;	       The output can be quite lengthy.
; Example    : schHdlVerbose = t
;
schHdlVerbose = nil 

;------------------------------------------
;         Verilog Hierarhcy Creation
;
; Application: Verilog
; Description: This flag turns the mixed text-graphics feature on and off.
;	       If the flag is set, instance information is ignored when the
;	       Verilog text is post-processed. Verilog description editted
;              when this flag is set can only be used as leaf cells
;              in a netlist.
;
schHdlNoHierarchy = nil 

;------------------------------------------
;      Verilog Instance Symbol Creation
;
; Application: Verilog
; Description: Port direction for instantiated Verilog modules
;              is inferred by their connection to primary I/O or
;              internal registers. The following variables map
;              the inferred port type (input or inout) to the connecting
;              net type. All other nets are assumed to be connected to
;              instance output ports. The valid values in the
;              list are "reg", "time", "integer", "real",  "expression",
;              "net" and "unknown". (A "net" is any wire; unkown nets
;              are those, e.g., connected to the terminal of module
;              foo as in "foo(,,,)";)
;
; Example    : schHdlNetToInoutPort = '("net") ; default pin direction of
;                                              ; instantiated module := "inout"
;
schHdlNetToInputPort = list("reg" "time" "integer" "real" "expression")
schHdlNetToInoutPort = nil

;  After editing Verilog or VHDL text, the symbol associated with the
;  cell will conditionally be updated to match the pinout of the
;  Verilog module. The following flag controls the updating
;  of the symbol and may be set to one of three values:
;
;     t  : if required, update symbol after editing
;   nil  : don't update symbol after editing
; "query": display dialog box, asking if you want symbol updated
;
schHdlUpdateSymbolAfterEdit = "query"       

; TSG configuration lists.
; The following lists are used to configure the characteristics of
; symbols built by TSG.

; This IL structure describes the "indirection map" used by tsg to provide
; a simplified approach for selecting the pin Graphics to be used during
; symbol generation.
;
tsgPinGraphicMasters = list(

    ; Put choices for the symbol generator "pin graphic" here. Each entry
    ; contains a pin Graphic name followed by a cellview specification for
    ; each direction. The pin graphic name will be used  on the UI form.
    ; The cellview should contain only pin graphics such as a clock or
    ; negitive indicator, but not the pin stub or pin connector.
    ; A nil entry indicates there are no graphics for this type.
    ;
    ; Standard structure: 
    ;
    ;     list(PIN_GRAPHIC
    ;         list(CDBA_DIRECTION list(LIBRARY_NAME CELL_NAME VIEW_NAME))
    ;         list(CDBA_DIRECTION list(LIBRARY_NAME CELL_NAME VIEW_NAME))
    ;         list(CDBA_DIRECTION list(LIBRARY_NAME CELL_NAME VIEW_NAME))
    ;     )
    ;

    list("actHi"
        list("input"	nil)
        list("output"	nil)
        list("inputOutput"	nil)
        list("switch" 	nil))
    list("actLo"
        list("input"	list("basic" "tsgActLo"   "symbol"))
        list("output"	list("basic" "tsgActLo"   "symbol"))
        list("inputOutput"	list("basic" "tsgActLo"   "symbol"))
        list("switch"	list("basic" "tsgActLo"   "symbol")))
    list("ieeeActLo"
        list("input"	list("basic" "tsgIeeeActLoInp"  "symbol"))
        list("output"	list("basic" "tsgIeeeActLoOut"  "symbol"))
        list("inputOutput"	list("basic" "tsgIeeeActLoOut" "symbol"))
        list("switch" 	list("basic" "tsgIeeeActLoOut" "symbol")))
    list("clock"
        list("input"	list("basic" "tsgClock"  "symbol"))
        list("output"	list("basic" "tsgClock"  "symbol"))
        list("inputOutput"	list("basic" "tsgClock" "symbol")))
    list("actLoClock"
        list("input"	list("basic" "tsgActLoClock"  "symbol"))
        list("output"	list("basic" "tsgActLoClock"  "symbol"))
        list("inputOutput"	list("basic" "tsgActLoClock"  "symbol")))
)

; This IL structure describes the "indirection map" used by tsg to provide
; a simplified approach for selecting the pin Connectors to be used during
; symbol generation.
;
tsgConnectorMasters = list(

    ; Put choices for the symbol generator "pin connector" here.
    ; Each entry contains a pin connector name followed by a cellview
    ; specification for each direction. The pin connector name will be
    ; used  on the UI form. The cellview should contain the graphics
    ; for just the pin connector, not the pin stub or the clock/negitive
    ; indicators.
    ;
    ; Standard structure: 
    ;
    ;     list(TYPE
    ;         list(CDBA_DIRECTION list(LIBRARY_NAME CELL_NAME VIEW_NAME))
    ;         list(CDBA_DIRECTION list(LIBRARY_NAME CELL_NAME VIEW_NAME))
    ;         list(CDBA_DIRECTION list(LIBRARY_NAME CELL_NAME VIEW_NAME))
    ;     )
    ;

    list("square"
        list("input"	list("basic" "sympin" "symbolNN"))
        list("output"	list("basic" "sympin" "symbolNN"))
        list("inputOutput"	list("basic" "sympin" "symbolNN"))
        list("switch"	list("basic" "sympin" "symbolNN")))
    list("circle"
        list("input"	list("basic" "circle"   "symbol"))
        list("output"	list("basic" "circle"   "symbol"))
        list("inputOutput"	list("basic" "circle"   "symbol"))
        list("switch"	list("basic" "circle"   "symbol")))
    list("block"
        list("input"	list("basic" "blockipin"  "symbol"))
        list("output"	list("basic" "blockopin"  "symbol"))
        list("inputOutput"	list("basic" "blockiopin"   "symbol"))
        list("switch"	list("basic" "blockiopin"   "symbol")))
)

; The tsgSymbolTemplateFile is a TSG file which defines the characteristics
; of symbols built by TSG and also defines the initial values in the
; Symbol Generation Form.  
;
;unless( boundp('tsgSymbolTemplateFile)
;     tsgSymbolTemplateFile = (prependInstallPath "samples/symbolGen/package.tsg")
;)
unless( boundp('tsgSymbolTemplateFile)
tsgSymbolTemplateFile = (prependInstallPath "samples/symbolGen/default.tsg")
)
;unless( boundp('tsgSymbolTemplateFile)
;    tsgSymbolTemplateFile = (prependInstallPath "samples/symbolGen/metricPack.tsg")
;)
;unless( boundp('tsgSymbolTemplateFile)
;    tsgSymbolTemplateFile = (prependInstallPath "samples/symbolGen/metric.tsg")
;)
