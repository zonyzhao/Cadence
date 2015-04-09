# run T1AZ SPICE LEVEL3 PARAMETERS
*                                                                               
* DATE: Dec 18/01                                                               
* LOT: T1AZ                  WAF: 5101                                          
* DIE: N_Area_Fring          DEV: N3740/10                                      
* Temp= 27                                                                      

.MODEL ami16N NMOS (                                 LEVEL  = 3                  
+ TOX    = 3.07E-8         NSUB   = 2.75325E15      GAMMA  = 0.7620845          
+ PHI    = 0.7             VTO    = 0.6298903       DELTA  = 0.8569392          
+ UO     = 702.9336344     ETA    = 9.99916E-4      THETA  = 0.0734963          
+ KP     = 7.195017E-5     VMAX   = 2.766785E5      KAPPA  = 0.5                
+ RSH    = 0.0474566       NFS    = 6.567094E11     TPG    = 1                  
+ XJ     = 3E-7            LD     = 4.271014E-12    WD     = 7.34313E-7         
+ CGDO   = 1.75E-10        CGSO   = 1.75E-10        CGBO   = 1E-10              
+ CJ     = 2.944613E-4     PB     = 0.9048351       MJ     = 0.5                
+ CJSW   = 1.236957E-10    MJSW   = 0.05            )                           

.MODEL ami16N NMOS (                                LEVEL   = 49
+VERSION = 3.1            TNOM    = 27             TOX     = 3.07E-8
+XJ      = 3E-7           NCH     = 7.5E16         VTH0    = 0.5946428
+K1      = 0.9317355      K2      = -0.0642401     K3      = 8.1988053
+K3B     = -1.6036239     W0      = 1E-7           NLX     = 1E-8
+DVT0W   = 0              DVT1W   = 0              DVT2W   = 0
+DVT0    = 0.6287112      DVT1    = 0.3396         DVT2    = -0.3380439
+U0      = 690.3302409    UA      = 2.107409E-9    UB      = 1.45864E-18
+UC      = 5.597668E-11   VSAT    = 1.101194E5     A0      = 0.6538174
+AGS     = 0.1405777      B0      = 2.36604E-6     B1      = 5E-6
+KETA    = -5.491058E-3   A1      = 0              A2      = 1
+RDSW    = 3E3            PRWG    = -0.0257109     PRWB    = -0.0343409
+WR      = 1              WINT    = 7.640524E-7    LINT    = 2.383339E-7
+XL      = 0              XW      = 0              DWG     = -2.045861E-8
+DWB     = 3.86526E-8     VOFF    = -0.052426      NFACTOR = 0.7700134
+CIT     = 0              CDSC    = 0              CDSCD   = 2.966891E-6
+CDSCB   = 5.248867E-5    ETA0    = -1             ETAB    = -0.4998094
+DSUB    = 1              PCLM    = 1.1865082      PDIBLC1 = 7.872555E-3
+PDIBLC2 = 1.779838E-3    PDIBLCB = -0.1           DROUT   = 0.0559194
+PSCBE1  = 2.6186E9       PSCBE2  = 5.988929E-10   PVAG    = 0.2015173
+DELTA   = 0.01           RSH     = 51.8           MOBMOD  = 1
+PRT     = 0              UTE     = -1.5           KT1     = -0.11
+KT1L    = 0              KT2     = 0.022          UA1     = 4.31E-9
+UB1     = -7.61E-18      UC1     = -5.6E-11       AT      = 3.3E4
+WL      = 0              WLN     = 1              WW      = 0
+WWN     = 1              WWL     = 0              LL      = 0
+LLN     = 1              LW      = 0              LWN     = 1
+LWL     = 0              CAPMOD  = 2              XPART   = 0.5
+CGDO    = 1.75E-10       CGSO    = 1.75E-10       CGBO    = 1E-9
+CJ      = 2.922743E-4    PB      = 0.9688488      MJ      = 0.5144895
+CJSW    = 1.31563E-10    PBSW    = 0.99           MJSW    = 0.1
+CJSWG   = 6.4E-11        PBSWG   = 0.99           MJSWG   = 0.1
+CF      = 0               )

