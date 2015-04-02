;==========================================================================
;
; $Id: libmanFunctions.il 3 2007-01-10 22:50:03Z wdavis $
;
; SKILL callbacks for Library Manager customizations
; (see local/cdsLibMgr.il)
;--------------------------------------------------------------------------

procedure( libManCreateLib( objname lib cell view file cat )
    hiDisplayForm( NCSU_createLibForm )
)

procedure( libManAttachTechLib( objname lib cell view file cat )
    NCSU_attachTechForm( objname lib cell view file cat ) 
)
