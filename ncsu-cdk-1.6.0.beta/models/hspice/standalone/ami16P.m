# run T1AZ SPICE LEVEL3 PARAMETERS
*                                                                               
                                                                               
* DATE: Dec 18/01                                                               
* LOT: T1AZ                  WAF: 5101                                          
* DIE: P_Area_Fring          DEV: P3740/10                                      
* Temp= 27                                                                      
.MODEL ami16P PMOS (                                 LEVEL  = 3                  
+ TOX    = 3.07E-8         NSUB   = 1E17            GAMMA  = 0.4940829          
+ PHI    = 0.7             VTO    = -0.8615406      DELTA  = 0.5236605          
+ UO     = 250             ETA    = 7.55184E-3      THETA  = 0.1344949          
+ KP     = 2.438731E-5     VMAX   = 9.345228E5      KAPPA  = 200                
+ RSH    = 36.5040447      NFS    = 5.518964E11     TPG    = -1                 
+ XJ     = 2E-7            LD     = 9.684773E-12    WD     = 1E-6               
+ CGDO   = 2.09E-10        CGSO   = 2.09E-10        CGBO   = 1E-10              
+ CJ     = 2.965467E-4     PB     = 0.744678        MJ     = 0.4276703          
+ CJSW   = 1.619193E-10    MJSW   = 0.1055522       )                           
*                                                                               

.MODEL ami16P PMOS (                                LEVEL   = 49
+VERSION = 3.1            TNOM    = 27             TOX     = 3.07E-8
+XJ      = 3E-7           NCH     = 2.4E16         VTH0    = -0.8476404
+K1      = 0.4513608      K2      = 2.379699E-5    K3      = 13.3278347
+K3B     = -2.2238332     W0      = 9.577236E-7    NLX     = 3.166569E-7
+DVT0W   = 0              DVT1W   = 0              DVT2W   = 0
+DVT0    = 0.4531522      DVT1    = 0.6231695      DVT2    = -0.5
+U0      = 236.8923827    UA      = 3.833306E-9    UB      = 1.487688E-21
+UC      = -1.08562E-10   VSAT    = 1.275415E5     A0      = 0.6161235
+AGS     = 0.2171952      B0      = 2.51061E-6     B1      = 8.008378E-7
+KETA    = -7.084748E-3   A1      = 0              A2      = 0.364
+RDSW    = 3E3            PRWG    = 0.1936825      PRWB    = -0.0872641
+WR      = 1              WINT    = 7.565065E-7    LINT    = 8.759328E-8
+XL      = 0              XW      = 0              DWG     = -2.13917E-8
+DWB     = 3.857544E-8    VOFF    = -0.0877184     NFACTOR = 0.2508342
+CIT     = 0              CDSC    = 2.924806E-5    CDSCD   = 1.497572E-4
+CDSCB   = 1.091488E-4    ETA0    = 0.15903        ETAB    = 6.381554E-3
+DSUB    = 0.2873         PCLM    = 4.4941362      PDIBLC1 = 6.848725E-3
+PDIBLC2 = 1E-3           PDIBLCB = -1E-3          DROUT   = 4.153603E-3
+PSCBE1  = 3.341988E9     PSCBE2  = 1E-3           PVAG    = 15
+DELTA   = 0.01           RSH     = 76.4           MOBMOD  = 1
+PRT     = 0              UTE     = -1.5           KT1     = -0.11
+KT1L    = 0              KT2     = 0.022          UA1     = 4.31E-9
+UB1     = -7.61E-18      UC1     = -5.6E-11       AT      = 3.3E4
+WL      = 0              WLN     = 1              WW      = 0
+WWN     = 1              WWL     = 0              LL      = 0
+LLN     = 1              LW      = 0              LWN     = 1
+LWL     = 0              CAPMOD  = 2              XPART   = 0.5
+CGDO    = 2.09E-10       CGSO    = 2.09E-10       CGBO    = 1E-9
+CJ      = 2.966784E-4    PB      = 0.741159       MJ      = 0.4269642
+CJSW    = 1.607959E-10   PBSW    = 0.99           MJSW    = 0.1168473
+CJSWG   = 3.9E-11        PBSWG   = 0.99           MJSWG   = 0.1168473
+CF      = 0               )
*
