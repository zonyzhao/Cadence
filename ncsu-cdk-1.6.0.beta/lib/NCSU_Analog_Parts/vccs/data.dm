gE#          )                                                       %                     
              �                     \       `       d       l       ��������t       �      �      �      �             @                                                         $       pG                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    2.2-p001 or above           " 8 2.2-p049        2.2p056 linux_rhel21_32 gcc_3.2.3              4�F    4�F                                                                                                                          	   
                      $                                                                     ��������������������������������                           @                  cdfData ILList             �                                                                                                �      �      �      �      �      �      �      �      �      �                   hG                                                                                  TC                                                                                                                                                                                                                                                                                                                                                                                               ����   �         �         �         �          �                                  
                                                                                                    
                                                                                                                         �                                                      �       �       �       �       �       �                                          xB                                        ����   �   	      �         LB   �  KB              (promptWidth nil fieldHeight nil fieldWidth nil buttonFieldWidth nil formInitProc nil doneProc nil parameters ((storeDefault "no" defValue "1" display "artParameterInToolDisplay('ggain)" name "ggain" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Transconductance" units "conductance" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('ic)" name "ic" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Initial condition" units "voltage" propList nil) (storeDefault "no" defValue "1" display "artParameterInToolDisplay('m)" name "m" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Multiplier" units "" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('a)" name "a" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Phase offset" units "angle" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('r1)" name "r1" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Input resistance" units "resistance" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('r2)" name "r2" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Output resistance" units "resistance" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('f3db)" name "f3db" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "3dB frequency" units "frequency" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('td)" name "td" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Delay time" units "time" propList nil) (storeDefault "no" choices ("linear" "pwl" "delay") defValue "linear" display "artParameterInToolDisplay('csType)" name "csType" type "cyclic" parseAsCEL "yes" parseAsNumber "no" prompt "Type" units "" propList nil) (storeDefault "no" defValue "1.0" display "artParameterInToolDisplay('hggain)" name "hggain" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Transconductance" units "" use "cdfgData->csType->value == \"linear\"" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('maxi)" name "maxi" type "string" parseAsCEL "yes" parseAsNumber "no" prompt "Maximum output current" units "" use "cdfgData->csType->value == \"linear\"" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('mini)" name "mini" type "string" parseAsCEL "yes" parseAsNumber "no" prompt "Minimum output current" units "" use "cdfgData->csType->value == \"linear\"" propList nil) (storeDefault "unset" defValue "" display "artParameterInToolDisplay('scale)" name "scale" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Scale factor" units "" propList nil) (storeDefault "no" defValue "1" display "artParameterInToolDisplay('hm)" name "hm" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Multiplier" units "" use "cdfgData->csType->value == \"linear\" || cdfgData->csType->value == \"pwl\"" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('tc1)" name "tc1" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Temperature coefficient 1" units "" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('tc2)" name "tc2" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Temperature coefficient 2" units "" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('habs)" name "habs" type "string" parseAsCEL "yes" parseAsNumber "no" prompt "Absolute value" units "" use "cdfgData->csType->value == \"linear\"" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('hic)" name "hic" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Initial condition" units "voltage" use "cdfgData->csType->value == \"linear\" || cdfgData->csType->value == \"pwl\"" propList nil) (storeDefault "no" choices ("pwl" "npwl" "ppwl") defValue "pwl" display "artParameterInToolDisplay('pwlType)" name "pwlType" type "cyclic" parseAsCEL "yes" parseAsNumber "no" prompt "Pwl type" units "" use "cdfgData->csType->value == \"pwl\"" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('delta)" name "delta" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Delta" units "" use "cdfgData->csType->value == \"pwl\"" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('htd)" name "htd" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Delay time" units "time" use "cdfgData->csType->value == \"delay\"" propList nil) (storeDefault "no" defValue 2 display "artParameterInToolDisplay('xypairs)" name "xypairs" type "int" parseAsCEL "unset" parseAsNumber "unset" prompt "Number of controlling pairs" units "" use "cdfgData->csType->value == \"pwl\"" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('x1)" name "x1" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Controlling Volt 1" units "" use "cdfgData->csType->value == \"pwl\" && cdfgData->xypairs->value >= 1" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('x2)" name "x2" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Controlling Volt 2" units "" use "cdfgData->csType->value == \"pwl\" && cdfgData->xypairs->value >= 2" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('x3)" name "x3" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Controlling Volt 3" units "" use "cdfgData->csType->value == \"pwl\" && cdfgData->xypairs->value >= 3" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('x4)" name "x4" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Controlling Volt 4" units "" use "cdfgData->csType->value == \"pwl\" && cdfgData->xypairs->value >= 4" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('x5)" name "x5" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Controlling Volt 5" units "" use "cdfgData->csType->value == \"pwl\" && cdfgData->xypairs->value >= 5" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('x6)" name "x6" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Controlling Volt 6" units "" use "cdfgData->csType->value == \"pwl\" && cdfgData->xypairs->value >= 6" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('x7)" name "x7" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Controlling Volt 7" units "" use "cdfgData->csType->value == \"pwl\" && cdfgData->xypairs->value >= 7" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('x8)" name "x8" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Controlling Volt 8" units "" use "cdfgData->csType->value == \"pwl\" && cdfgData->xypairs->value >= 8" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('x9)" name "x9" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Controlling Volt 9" units "" use "cdfgData->csType->value == \"pwl\" && cdfgData->xypairs->value >= 9" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('x10)" name "x10" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Controlling Volt 10" units "" use "cdfgData->csType->value == \"pwl\" && cdfgData->xypairs->value >= 10" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('x11)" name "x11" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Controlling Volt 11" units "" use "cdfgData->csType->value == \"pwl\" && cdfgData->xypairs->value >= 11" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('x12)" name "x12" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Controlling Volt 12" units "" use "cdfgData->csType->value == \"pwl\" && cdfgData->xypairs->value >= 12" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('x13)" name "x13" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Controlling Volt 13" units "" use "cdfgData->csType->value == \"pwl\" && cdfgData->xypairs->value >= 13" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('x14)" name "x14" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Controlling Volt 14" units "" use "cdfgData->csType->value == \"pwl\" && cdfgData->xypairs->value >= 14" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('x15)" name "x15" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Controlling Volt 15" units "" use "cdfgData->csType->value == \"pwl\" && cdfgData->xypairs->value >= 15" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('x16)" name "x16" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Controlling Volt 16" units "" use "cdfgData->csType->value == \"pwl\" && cdfgData->xypairs->value >= 16" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('x17)" name "x17" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Controlling Volt 17" units "" use "cdfgData->csType->value == \"pwl\" && cdfgData->xypairs->value >= 17" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('x18)" name "x18" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Controlling Volt 18" units "" use "cdfgData->csType->value == \"pwl\" && cdfgData->xypairs->value >= 18" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('x20)" name "x20" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Controlling Volt 20" units "" use "cdfgData->csType->value == \"pwl\" && cdfgData->xypairs->value >= 20" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('y1)" name "y1" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Corresp Element 1" units "" use "cdfgData->csType->value == \"pwl\" && cdfgData->xypairs->value >= 1" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('y2)" name "y2" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Corresp Element 2" units "" use "cdfgData->csType->value == \"pwl\" && cdfgData->xypairs->value >= 2" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('y3)" name "y3" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Corresp Element 3" units "" use "cdfgData->csType->value == \"pwl\" && cdfgData->xypairs->value >= 3" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('y4)" name "y4" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Corresp Element 4" units "" use "cdfgData->csType->value == \"pwl\" && cdfgData->xypairs->value >= 4" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('y5)" name "y5" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Corresp Element 5" units "" use "cdfgData->csType->value == \"pwl\" && cdfgData->xypairs->value >= 5" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('y6)" name "y6" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Corresp Element 6" units "" use "cdfgData->csType->value == \"pwl\" && cdfgData->xypairs->value >= 6" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('y7)" name "y7" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Corresp Element 7" units "" use "cdfgData->csType->value == \"pwl\" && cdfgData->xypairs->value >= 7" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('y8)" name "y8" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Corresp Element 8" units "" use "cdfgData->csType->value == \"pwl\" && cdfgData->xypairs->value >= 8" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('y9)" name "y9" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Corresp Element 9" units "" use "cdfgData->csType->value == \"pwl\" && cdfgData->xypairs->value >= 9" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('y10)" name "y10" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Corresp Element 10" units "" use "cdfgData->csType->value == \"pwl\" && cdfgData->xypairs->value >= 10" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('y11)" name "y11" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Corresp Element 11" units "" use "cdfgData->csType->value == \"pwl\" && cdfgData->xypairs->value >= 11" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('y12)" name "y12" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Corresp Element 12" units "" use "cdfgData->csType->value == \"pwl\" && cdfgData->xypairs->value >= 12" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('y13)" name "y13" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Corresp Element 13" units "" use "cdfgData->csType->value == \"pwl\" && cdfgData->xypairs->value >= 13" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('y14)" name "y14" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Corresp Element 14" units "" use "cdfgData->csType->value == \"pwl\" && cdfgData->xypairs->value >= 14" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('y15)" name "y15" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Corresp Element 15" units "" use "cdfgData->csType->value == \"pwl\" && cdfgData->xypairs->value >= 15" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('y16)" name "y16" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Corresp Element 16" units "" use "cdfgData->csType->value == \"pwl\" && cdfgData->xypairs->value >= 16" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('y17)" name "y17" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Corresp Element 17" units "" use "cdfgData->csType->value == \"pwl\" && cdfgData->xypairs->value >= 17" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('y18)" name "y18" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Corresp Element 18" units "" use "cdfgData->csType->value == \"pwl\" && cdfgData->xypairs->value >= 18" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('y20)" name "y20" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Corresp Element 20" units "" use "cdfgData->csType->value == \"pwl\" && cdfgData->xypairs->value >= 20" propList nil)) propList (opPointLabelSet "i" paramLabelSet "ggain ic" simInfo (nil spectre (nil termOrder (PLUS MINUS NC\+ NC\-) propMapping (nil gm ggain) termMapping (nil PLUS \:sink MINUS "(FUNCTION minus(root(\"PLUS\")))" NC\+ "(FUNCTION zero(root(\"PLUS\")))" NC\- "(FUNCTION zero(root(\"PLUS\")))") instParameters (gm m) otherParameters (ggain) componentName vccs) mharm (nil netlistProcedure ansMharmCompPrim instParameters (g r1 r2 f t) componentName vcg termOrder (NC\+ PLUS NC\- MINUS) propMapping (nil g ggain f f3db t td) namePrefix "") hpmns (nil netlistProcedure ansHpmnsCompPrim instParameters (m ang t) componentName VDCS termOrder (NC\+ NC\- PLUS MINUS) propMapping (nil m ggain ang a t td) namePrefix "A") hspiceS (nil propMapping nil refTermOrder (NC\+ NC\-) netlistProcedure ansSpiceCompPrimRef instParameters (csType hggain maxi mini scale hm tc1 tc2 habs hic pwlType delta htd xypairs x1 x2 x3 x4 x5 x6 x7 x8 x9 x10 x11 x12 x13 x14 x15 x16 x17 x18 x18 x20 y1 y2 y3 y4 y5 y6 y7 y8 y9 y10 y11 y12 y13 y14 y15 y16 y17 y18 y18 y20) componentName hvccs termOrder (PLUS MINUS) namePrefix "G" current port termMapping (nil PLUS "" MINUS "(FUNCTION minus(root(\"PLUS\")))" NC\+ "(FUNCTION zero(root(\"PLUS\")))" NC\- "(FUNCTION zero(root(\"PLUS\")))") noPortDelimiter t dcSens nil acSens t) spectreS (nil netlistProcedure ansSpectreSCompPrim otherParameters (ggain) instParameters (gm m) termOrder (PLUS MINUS NC\+ NC\-) termMapping (nil PLUS \:sink MINUS "(FUNCTION minus(root(\"PLUS\")))" NC\+ "(FUNCTION zero(root(\"PLUS\")))" NC\- "(FUNCTION zero(root(\"PLUS\")))") propMapping (nil gm ggain) namePrefix "G" componentName vccs noPortDelimiter t current port) auLvs (nil propMapping nil namePrefix "") libra (nil netlistProcedure ansLibraCompPrim ver4NetProc ansLibra4CompPrim instParameters (m a r1 r2 f t) freqParameters (f) componentName VCCS termOrder (NC\+ PLUS NC\- MINUS) propMapping (nil m ggain f f3db t td) namePrefix "") cdsSpice (nil propMapping nil netlistProcedure ansSpiceCompPrim instParameters (ggain ic) componentName vccs termOrder (PLUS MINUS NC\+ NC\-) namePrefix "G" current port termMapping (nil PLUS "" MINUS "(FUNCTION minus(root(\"PLUS\")))" NC\+ "(FUNCTION zero(root(\"PLUS\")))" NC\- "(FUNCTION zero(root(\"PLUS\")))") noPortDelimiter t dcSens nil acSens t))))  d      