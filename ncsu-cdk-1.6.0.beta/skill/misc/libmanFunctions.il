;==========================================================================
;
; $Id: libmanFunctions.il,v 1.1.1.1 2006/02/10 16:33:46 slipa Exp $
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
