gE#          )                                                       %                     
              �                     \       `       d       l       ��������t       �      �      �      �             @                                                         $       �%                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    2.2-p001 or above           " 8 2.2-p049        2.2p056 linux_rhel21_32 gcc_3.2.3              oE�F    oE�F                                                                                                                          	   
                      $                                                                     ��������������������������������                           @                  cdfData ILList             �                                                                                                �      �      �      �      �      �      �      �      �      �                   �%                                                                                  �!                                                                                                                                                                                                                                                                                                                                                                                               ����   �         �         �         �          �                                  
                                                                                                    
                                                                                                                         �                                                      �       �       �       �       �       �                                          �                                         ����   �   	      �         �    @  �               (promptWidth 190 fieldHeight 35 fieldWidth 350 buttonFieldWidth 340 formInitProc "SetFetDefaultsCB" doneProc nil parameters ((storeDefault "no" defValue "pmos_hv" display "artParameterInToolDisplay('model)" editable "(cdfgData->ModelType->value == \"user\")" name "model" type "string" parseAsCEL "no" parseAsNumber "no" prompt "Model name" units "" propList nil) (storeDefault "no" callback "CheckFetModelCB()" choices ("system" "user") defValue "system" display "t" name "ModelType" type "radio" parseAsCEL "no" parseAsNumber "no" prompt "Model Type" units "" propList nil) (storeDefault "no" defValue "vdd!" display "artParameterInToolDisplay('bn)" editable "t" name "bn" type "string" parseAsCEL "no" parseAsNumber "no" prompt "Bulk node connection" units "" propList nil) (storeDefault "no" callback "ChangeMultiplierCB()" defValue 1 display "t" editable "(cdfgData->fingers->value == 1)" name "m" type "int" parseAsCEL "no" parseAsNumber "no" prompt "Multiplier" units "" propList nil) (storeDefault "no" callback "ChangeFingersCB()" defValue 1 display "t" editable "(cdfgData->m->value == 1)" name "fingers" type "int" parseAsCEL "no" parseAsNumber "no" prompt "Fingers" units "" propList nil) (storeDefault "no" defValue "" display "nil" editable "nil" name "w_microns" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Width (um)" units "" propList nil) (storeDefault "no" callback "CheckGridSizeCB(\"w\")" defValue 0 name "w_grid" type "int" parseAsCEL "no" parseAsNumber "no" prompt "Width (grid units)" units "" propList nil) (storeDefault "no" callback "CheckMicronSizeCB(\"w\")" defValue "" display "artParameterInToolDisplay('w)" name "w" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Width" units "lengthMetric" propList nil) (storeDefault "no" defValue "" display "t" editable "nil" name "MinW" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Width (minimum)" units "lengthMetric" propList nil) (storeDefault "no" callback "CheckGridSizeCB(\"l\")" defValue 0 name "l_grid" type "int" parseAsCEL "no" parseAsNumber "no" prompt "Length (grid units)" units "" propList nil) (storeDefault "no" callback "CheckMicronSizeCB(\"l\")" defValue "" display "artParameterInToolDisplay('l)" name "l" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Length" units "lengthMetric" propList nil) (storeDefault "no" defValue "" display "nil" editable "nil" name "l_microns" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Length (um)" units "" propList nil) (storeDefault "no" defValue "" display "t" editable "nil" name "MinL" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Length (minimum)" units "lengthMetric" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('ad)" name "ad" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Drain diffusion area" units "" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('as)" name "as" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Source diffusion area" units "" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('pd)" name "pd" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Drain diffusion perimeter" units "lengthMetric" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('ps)" name "ps" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Source diffusion perimeter" units "lengthMetric" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('nrd)" name "nrd" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Drain diffusion res squares" units "" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('nrs)" name "nrs" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Source diffusion res squares" units "" propList nil) (storeDefault "no" callback "CheckDLECellName()" defValue "" display "t" editable "t" name "lxUseCell" type "string" parseAsCEL "no" parseAsNumber "no" prompt "Virtuoso-XL layout cell" units "" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('ld)" name "ld" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Drain diffusion length" units "lengthMetric" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('ls)" name "ls" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Source diffusion length" units "lengthMetric" propList nil) (storeDefault "no" defValue nil display "artParameterInToolDisplay('off)" name "off" type "boolean" parseAsCEL "no" parseAsNumber "no" prompt "Device initially off" units "" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('Vds)" name "Vds" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Drain source initial voltage" units "voltage" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('Vgs)" name "Vgs" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Gate source initial voltage" units "voltage" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('Vbs)" name "Vbs" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Bulk source initial voltage" units "voltage" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('trise)" name "trise" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Temp rise from ambient" units "" propList nil) (storeDefault "no" choices ("off" "triode" "sat" "subth") defValue "sat" display "artParameterInToolDisplay('region)" name "region" type "cyclic" parseAsCEL "yes" parseAsNumber "no" prompt "Estimated operating region" units "" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('rdc)" name "rdc" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Additional drain resistance" units "current" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('rsc)" name "rsc" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Additional source resistance" units "current" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('dtemp)" name "dtemp" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Temperature difference" units "" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('geo)" name "geo" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Source/drain selector" units "" propList nil)) propList (paramLabelSet "-model w l m" opPointLabelSet "id vgs vds" modelLabelSet "vto kp gamma" paramDisplayMode "parameter" paramEvaluate "t nil nil nil nil" paramSimType "DC" termDisplayMode "netName" termSimType "DC" netNameType "schematic" instDisplayMode "instName" instNameType "schematic" simInfo (nil spectre (nil termOrder (D G S bn) termMapping (nil D \:d G \:g S \:s B \:b) instParameters (w l as ad ps pd nrd nrs ld ls m trise region) otherParameters (model) componentName mos2) watscad (nil) switcap (nil) spectreS (nil macroArguments nil modelArguments nil propMapping nil netlistProcedure ansSpectreSDevPrim otherParameters (bn model region) instParameters (w l as ad ps pd nrd nrs ld ls m trise) termOrder (D G S progn(bn)) termMapping (nil D d G g S s B b) namePrefix "M" componentName mos2 current port) mharm (nil) libra (nil) hspiceS (nil termMapping nil macroArguments nil modelArguments nil netlistProcedure ansSpiceDevPrim instParameters (l w ad as pd ps nrd nrs rdc rsc off Vds Vgs Vbs dtemp geo m) otherParameters (bn model) componentName hnmos termOrder (D G S progn(bn)) propMapping (nil vds Vds vgs Vgs vbs Vbs) namePrefix "M" current port dcSens t acSens t) hpmns (nil) cdsSpice (nil termMapping nil macroArguments nil modelArguments nil netlistProcedure ansSpiceDevPrim instParameters (m w l ad as pd ps nrd nrs ld ls off vds vgs vbs) otherParameters (model bn) componentName mosfet termOrder (D G S progn(bn)) propMapping (nil vds Vds vgs Vgs vbs Vbs) namePrefix "M" current port dcSens t acSens t) auLvs (nil propMapping nil netlistProcedure ansLvsCompPrim instParameters (m l w) componentName pmos termOrder (D G S progn(bn)) deviceTerminals "D G S B" permuteRule "(p D S)" namePrefix "Q") auCdl (nil netlistProcedure ansCdlCompPrim instParameters (m L W) componentName pmos termOrder (D G S progn(bn)) propMapping (nil L l W w) namePrefix "M" modelName "PM"))))d      