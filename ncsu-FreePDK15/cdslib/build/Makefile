#
#
#


SHELL = /bin/tcsh
TECHDB = ../NCSU_TechLib_FreePDK15/tech.db
#PYCELLSETUP = /local/opt/synopsys/pycell2013.12/quickstart/tcshrc
CDSSETUP = /afs/eos/lockers/research/ece/wdavis/setup/ic615py425_setup.csh

.PHONY: tech
tech: $(TECHDB)

$(TECHDB): cni/Santana.tech cds/FreePDK.tf
	/bin/tcsh -c "pushd run ; \
	source $(CDSSETUP) ; \
	source ../../setup/setup.csh ; \
	cngenlib -c --techfile ../cni/Santana.tech pkg:pycells  NCSU_TechLib_FreePDK15 ../../NCSU_TechLib_FreePDK15 |& tee cngenlib.log ; \
	echo \(pdkAppendTechfile\) \(exit\) >! exe.il ; \
	virtuoso -log CDS.log -nograph -replay exe.il |& tee virtuoso.log ; \
	cp ../cds/FreePDK.layermap ../../NCSU_TechLib_FreePDK15/NCSU_TechLib_FreePDK15.layermap ; \
	popd"

clean:
	-rm -rf run/*
	-rm -rf run/.cadence
	-rm -f run/.cdsinit
	-rm -rf ../NCSU_TechLib_FreePDK15

