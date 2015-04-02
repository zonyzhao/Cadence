###############################################################################
#                                                                             #
# FreePDK Setup Script                                                        #
#    8/23/2013 by Rhett Davis (rhett_davis@ncsu.edu)                           #
#                                                                             #
###############################################################################

# Set the PDK_DIR variable to the root directory of the FreePDK distribution
setenv PDK_DIR /home/wdavis/git/dist/FreePDK15

if !(-f ${PWD}/.cdsinit ) then
  cp ${PDK_DIR}/cdslib/setup/cdsinit ${PWD}/.cdsinit
endif

if !( -f ${PWD}/cds.lib ) then
  cp ${PDK_DIR}/cdslib/setup/cds.lib ${PWD}/cds.lib
endif

if !(-f ${PWD}/.runset.calibre.drc ) then
  cp ${PDK_DIR}/cdslib/setup/runset.calibre.drc ${PWD}/.runset.calibre.drc
endif

set present = `printenv PYTHONPATH`
if ($present == "") then
  setenv PYTHONPATH $PDK_DIR'/cdslib/build/cni'
else
  setenv PYTHONPATH $PYTHONPATH':'$PDK_DIR'/cdslib/build/cni'
endif

setenv MGC_CALIBRE_DRC_RUNSET_FILE ./.runset.calibre.drc

