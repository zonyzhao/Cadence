; ==========================================================================
;
; $Id: ami_16.tf,v 1.1.1.1 2006/02/10 16:32:38 slipa Exp $
; 
; --------------------------------------------------------------------------

; AMI ABN 1.2um
; 12 Oct 1999 -- lambda is now 0.8um (Ldmin=2lambda, Wdmin=5lambda); see
; http://www.mosis.com/Whatsnew/1999/990929-ami_abn.html for details.

controls(
    techParams(
        ( lambda                0.8 )
        ( technology            "AMI_ABN" )
        ( elecAvailable         t )
        ( npnAvailable          t )
    )
)
