gE#          4                                                       %                     
              (       �                     \       `       d       l       ��������t       �            P      (                    @                                           |      $       @       �                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           2.2-p001 or above           / A 22.04.065       22.04.065       linux_rhel40 gcc_4.1.2         ��L    �L                                                                                                                                 	   
                         $                                                                                                                       $             ��������                        	   
            ����                  &             @   )               techLibName cdsDefTechLib cdfData ILList           �                                                                                                      �      �      �      �      �      �      �                               ,      �      �                                                                                  �       �                                                                                                                                                                                                                                                                                                                                                                                               ����   �        �        �        �          �                               
                                                                                                    
                                                                                                                         �                                                �       �       �       �       �                                                                            ����   �         �                                                      �       �       �       �       �       �                                                                                      ����   �   #      �         �      �              (promptWidth 175 fieldHeight 35 fieldWidth 350 buttonFieldWidth 340 formInitProc "SetFetDefaultsCB" doneProc nil parameters ((storeDefault "no" defValue t display "nil" name "DisplayGateProps" type "boolean" parseAsCEL "no" parseAsNumber "no" prompt "Display Gate Type Part" units "" propList nil) (storeDefault "no" defValue "pmos" display "(cdfgData->DisplayGateProps->value == t)" editable "(cdfgData->ModelType->value == \"user\")" name "pModel" type "string" parseAsCEL "no" parseAsNumber "no" prompt "PMOS Model" units "" propList nil) (storeDefault "no" defValue "nmos" display "(cdfgData->DisplayGateProps->value == t)" editable "(cdfgData->ModelType->value == \"user\")" name "nModel" type "string" parseAsCEL "no" parseAsNumber "no" prompt "NMOS Model" units "" propList nil) (storeDefault "no" callback "CheckFetModelCB()" choices ("system" "user") defValue "system" display "(cdfgData->DisplayGateProps->value == t)" name "ModelType" type "radio" parseAsCEL "no" parseAsNumber "no" prompt "Model Type" units "" propList nil) (storeDefault "no" defValue "" display "nil" name "wp_microns" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "PMOS Width (um)" units "" propList nil) (storeDefault "no" callback "CheckGridSizeCB(\"wp\")" defValue 0 display "(cdfgData->DisplayGateProps->value == t)" editable "t" name "wp_grid" type "int" parseAsCEL "no" parseAsNumber "no" prompt "PMOS Width (grid units)" units "" propList nil) (storeDefault "no" callback "CheckMicronSizeCB(\"wp\")" defValue "" display "(cdfgData->DisplayGateProps->value == t)" editable "t" name "wp" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "PMOS Width" units "lengthMetric" propList nil) (storeDefault "no" defValue "" display "nil" name "wn_microns" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "NMOS Width (um)" units "" propList nil) (storeDefault "no" callback "CheckGridSizeCB(\"wn\")" defValue 0 display "(cdfgData->DisplayGateProps->value == t)" editable "t" name "wn_grid" type "int" parseAsCEL "no" parseAsNumber "no" prompt "NMOS Width (grid units)" units "" propList nil) (storeDefault "no" callback "CheckMicronSizeCB(\"wn\")" defValue "" display "(cdfgData->DisplayGateProps->value == t)" editable "t" name "wn" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "NMOS Width" units "lengthMetric" propList nil) (storeDefault "no" defValue "" display "(cdfgData->DisplayGateProps->value == t)" editable "nil" name "MinW" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Minimum Width" units "lengthMetric" propList nil) (storeDefault "no" callback "CheckGridSizeCB(\"lp\")" defValue 0 display "(cdfgData->DisplayGateProps->value == t)" editable "t" name "lp_grid" type "int" parseAsCEL "no" parseAsNumber "no" prompt "PMOS Length (grid units)" units "" propList nil) (storeDefault "no" callback "CheckMicronSizeCB(\"lp\")" defValue "" display "(cdfgData->DisplayGateProps->value == t)" editable "t" name "lp" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "PMOS Length" units "lengthMetric" propList nil) (storeDefault "no" callback "CheckGridSizeCB(\"ln\")" defValue 0 display "(cdfgData->DisplayGateProps->value == t)" editable "t" name "ln_grid" type "int" parseAsCEL "no" parseAsNumber "no" prompt "NMOS Length (grid units)" units "" propList nil) (storeDefault "no" callback "CheckMicronSizeCB(\"ln\")" defValue "" display "(cdfgData->DisplayGateProps->value == t)" editable "t" name "ln" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "NMOS Length" units "lengthMetric" propList nil) (storeDefault "no" defValue "" display "(cdfgData->DisplayGateProps->value == t)" editable "nil" name "MinL" type "string" parseAsCEL "yes" parseAsNumber "yes" prompt "Minimum Length" units "lengthMetric" propList nil) (storeDefault "no" defValue "vdd!" display "(cdfgData->DisplayGateProps->value == t)" editable "t" name "bp" type "string" parseAsCEL "no" parseAsNumber "no" prompt "PMOS Bulk Node" units "" propList nil) (storeDefault "no" defValue "gnd!" display "(cdfgData->DisplayGateProps->value == t)" editable "t" name "bn" type "string" parseAsCEL "no" parseAsNumber "no" prompt "NMOS Bulk Node" units "" propList nil) (storeDefault "no" callback "CheckDLECellName()" defValue "" display "(cdfgData->DisplayGateProps->value == t)" name "pDLEcell" type "string" parseAsCEL "yes" parseAsNumber "no" prompt "PMOS DLE layout cell" units "" propList nil) (storeDefault "no" callback "CheckDLECellName()" defValue "" display "(cdfgData->DisplayGateProps->value == t)" name "nDLEcell" type "string" parseAsCEL "yes" parseAsNumber "no" prompt "NMOS DLE layout cell" units "" propList nil)) propList (simInfo (nil watscad (nil) switcap (nil) spectreS (nil) spectre (nil) mharm (nil) libra (nil) hspiceS (nil) hpmns (nil) cdsSpice (nil) auLvs (nil) auCdl (nil))))  d      gE#