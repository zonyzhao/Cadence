
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
probe -create -emptyok -database ams_database {MC_6TWrite_Test.ValAddr}
probe -create -emptyok -database ams_database {MC_6TWrite_Test.Ack}
probe -create -emptyok -database ams_database {MC_6TWrite_Test.S[0]}
probe -create -emptyok -database ams_database {MC_6TWrite_Test.A[16]}
probe -create -emptyok -database ams_database {MC_6TWrite_Test.B1[0]}
probe -create -emptyok -database ams_database {MC_6TWrite_Test.B0[0]}
probe -create -emptyok -database ams_database {MC_6TWrite_Test.W1[0]}
probe -create -emptyok -database ams_database {MC_6TWrite_Test.W0[0]}
probe -create -emptyok -database ams_database {MC_6TWrite_Test.RW[0]}
probe -create -emptyok -database ams_database {MC_6TWrite_Test.ICHUNK.IARRAY0.ISRAM0.I7.I3.Q0}
probe -create -emptyok -database ams_database {MC_6TWrite_Test.ICHUNK.IARRAY0.ISRAM0.I7.I3.Q1}
probe -create -emptyok -database ams_database {MC_6TWrite_Test.ICHUNK.IARRAY0.B1P1}
probe -create -emptyok -database ams_database {MC_6TWrite_Test.ICHUNK.IARRAY0.B0P1}

