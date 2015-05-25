
# This is the NC-SIM(R) probe command file
# used in the AMS-ADE integration.


#
# Database settings
#
if { [info exists ::env(AMS_RESULTS_DIR) ] } { set AMS_RESULTS_DIR $env(AMS_RESULTS_DIR)} else {set AMS_RESULTS_DIR "../psf"}
database -open ams_database -into ${AMS_RESULTS_DIR} -default

#
# Probe settings
#
probe -create -emptyok -database ams_database {MC_6TWrite_Test.Aline[0]}
probe -create -emptyok -database ams_database {MC_6TWrite_Test.S[0]}
probe -create -emptyok -database ams_database {MC_6TWrite_Test.W1_1[3]}
probe -create -emptyok -database ams_database {MC_6TWrite_Test.W1_1[2]}
probe -create -emptyok -database ams_database {MC_6TWrite_Test.W1_1[1]}
probe -create -emptyok -database ams_database {MC_6TWrite_Test.W1_1[0]}
probe -create -emptyok -database ams_database {MC_6TWrite_Test.B1_1[3]}
probe -create -emptyok -database ams_database {MC_6TWrite_Test.B1_1[2]}
probe -create -emptyok -database ams_database {MC_6TWrite_Test.B1_1[1]}
probe -create -emptyok -database ams_database {MC_6TWrite_Test.B1_1[0]}
probe -create -emptyok -database ams_database {MC_6TWrite_Test.ICHUNK.IARRAY0.ISRAM0.I7.I3.Q1}
probe -create -emptyok -database ams_database {MC_6TWrite_Test.ICHUNK.IARRAY0.ISRAM0.I7.I3.Q0}
probe -create -emptyok -database ams_database {MC_6TWrite_Test.ICHUNK.IARRAY0.B1P1}
probe -create -emptyok -database ams_database {MC_6TWrite_Test.ICHUNK.IARRAY0.B0P1}

