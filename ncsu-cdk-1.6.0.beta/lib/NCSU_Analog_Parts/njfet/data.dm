gE#          )                                                       %                     
              �                     \       `       d       l       ��������t       �      �      �      �             @                                                         $       l                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    2.2-p001 or above           " 8 2.2-p049        2.2p056 linux_rhel21_32 gcc_3.2.3              4�F    4�F                                                                                                                          	   
                      $                                                                     ��������������������������������                           @                  cdfData ILList             �                                                                                                �      �      �      �      �      �      �      �      �      �                   d                                                                                  P                                                                                                                                                                                                                                                                                                                                                                                               ����   �         �         �         �          �                                  
                                                                                                    
                                                                                                                         �                                                      �       �       �       �       �       �                                          t                                        ����   �   	      �         G      F              (promptWidth nil fieldHeight nil fieldWidth nil buttonFieldWidth nil formInitProc nil doneProc nil parameters ((storeDefault "no" defValue "" display "artParameterInToolDisplay('model)" name "model" type "string" parseAsCEL "yes" parseAsNumber "no" prompt "Model name" units "" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('bn)" name "bn" type "string" parseAsCEL "yes" parseAsNumber "no" prompt "Bulk node connection" units "" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('area)" name "area" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Device area" units "" propList nil) (storeDefault "no" defValue nil display "artParameterInToolDisplay('off)" name "off" type "boolean" parseAsCEL "unset" parseAsNumber "unset" prompt "Device initially off" units "" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('Vds)" name "Vds" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Drain source initial voltage" units "voltage" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('Vgs)" name "Vgs" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Gate source initial voltage" units "voltage" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('Vgbs)" name "Vgbs" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Gate to bulk and src voltage" units "voltage" propList nil) (storeDefault "no" defValue "1" display "artParameterInToolDisplay('m)" name "m" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Multiplier" units "" propList nil) (storeDefault "no" choices ("off" "triode" "sat" "subth") defValue "triode" display "artParameterInToolDisplay('region)" name "region" type "cyclic" parseAsCEL "yes" parseAsNumber "no" prompt "Estimated operating region" units "" propList nil) (storeDefault "no" choices ("Yes" "No") defValue "No" display "artParameterInToolDisplay('mode)" name "mode" type "cyclic" parseAsCEL "yes" parseAsNumber "no" prompt "Linearized Region" units "" propList nil) (storeDefault "no" defValue "bjt" display "artParameterInToolDisplay('dataFile)" name "dataFile" type "string" parseAsCEL "yes" parseAsNumber "no" prompt "S-parameter data file" units "" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('w)" name "w" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Width" units "lengthMetric" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('l)" name "l" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Length" units "lengthMetric" propList nil) (storeDefault "no" defValue "" display "artParameterInToolDisplay('dtemp)" name "dtemp" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Temperature difference" units "" propList nil)) propList (modelLabelSet "vto beta lambda" opPointLabelSet "id vgs vds" paramLabelSet "-model Vds Vgs" simInfo (nil spectre (nil termOrder (D G S bn) termMapping (nil D \:d G \:g S \:s) instParameters (area m region) otherParameters (model) componentName jfet) mharm (nil propMapping nil netlistProcedure ansMharmCompPrim componentName fet otherParameters (area model) instParameters ((expr '(area model name))) typeMapping (nil model model name instName) termOrder (G D S) namePrefix "J") hpmns (nil propMapping nil netlistProcedure ansHpmnsCompPrim otherParameters (model) instParameters (model area) typeMapping (nil model model) componentName (expr (iPar 'model)) termOrder (D G S) current port namePrefix "J") hspiceS (nil netlistProcedure ansSpiceDevPrim instParameters (Vds Vgs Vgbs area w l off m dtemp) otherParameters (bn model) componentName hnjfet termOrder (D G S progn(bn)) propMapping (nil vds Vds vgs Vgs vgbs Vgbs) namePrefix "J" current port dcSens t acSens t) spectreS (nil propMapping nil netlistProcedure ansSpectreSDevPrim otherParameters (bn model region) instParameters (area m) termOrder (D G S progn(bn)) termMapping (nil D d G g S s) namePrefix "J" componentName jfet current port) auLvs (nil propMapping nil netlistProcedure ansLvsCompPrim componentName njfet termOrder (D G S progn(bn)) deviceTerminals "D G S B" permuteRule "(p D S)" namePrefix "Q") auCdl (nil propMapping nil netlistProcedure ansCdlCompPrim componentName njfet termOrder (D G S) namePrefix "J" modelName "NJ") libra (nil propMapping nil netlistProcedure ansLibraCompPrim ver4NetProc ansLibra4CompPrim instParameters (dataFile model area) inst4Parameters (area model mode temp) otherParameters (mode) typeMapping (nil model model mode mode temp temp dataFile fileName) componentName JFET current port termOrder (G D S) namePrefix "J") cdsSpice (nil netlistProcedure ansSpiceDevPrim instParameters (area off vds vgs vgbs) otherParameters (model bn) componentName jfet termOrder (D G S progn(bn)) propMapping (nil vds Vds vgs Vgs vgbs Vgbs) namePrefix "J" current port dcSens t acSens t))))   d          