;*****************************************************************
;  Copyright (C) 1983, 1984, 1985, 1986, 1987, 1988, 1989, 1990  *
;  Cadence Design Systems Inc.  All Rights Reserved.             *
;*****************************************************************
;
;******************************************************************************
;
; file name : tiSTRMIStup.il
;
;******************************************************************************
streamInKeys = list(nil
  'runDir		"."	;input and output directory
  'inFile		""	;stream file will convert to OPUS
  'libName		"changeme"	;the target of OPUS library
;
; output OPUS specify
;
  'scale		0.001
  'units		"micron"	;("micron","millimeter","mil")
; 
; generate ascii technology file
;	to generate new techfile - use keyword "strmtechgen" and
;				   set 'techfileGen to t
;	to load techfile 	 - just specify file name.
;
  'techfileGen		nil	;(t/nil)
  'techfileName		""	;given file will be automatically loaded
;
; input stream specify
;
  'refLib		nil	;(t/nil)
  'refLibSearchPath	"."	;all libraries' search path
;
; select stream data
;
  'primaryCell		""
  'hierDepth		20
;
; mapping opus data to stream 
;
  'caseSensitivity	"lower"		;("lower","upper","preserve")
  'cellMapTable		""
  'layerTable		""
  'textFontTable  	""
  'skipUndefinedLPP	nil
;
; check stream input data
;
  'checkPolygon		t		;(t/nil)
  'snapToGrid		nil		;(t/nil)
  'errFile		"PIPO.LOG"	;log file name
  'dataDump		""
  'reportPrecision	nil
;
; unmatch opus data type handle
;
  'zeroPathToLine	"lines"		;("lines","ignore")
  'arrayToSimMosaic	t		;(t/nil)
  'ignoreBox		nil		;(t/nil), nil to translate BOX to rectangle
  'maxVertices		1024		;apply to path and polygon
; user defined property mapping table
  'propMapTable		""
  'propSeparator	","
;
;
;set default to "no overwrite cell" 
	'noWriteExistCell  t 		;(t/nil)
; user skill file specified here
;
  'userSkillFile	""
;
  'saveAtTheEnd		t
)
