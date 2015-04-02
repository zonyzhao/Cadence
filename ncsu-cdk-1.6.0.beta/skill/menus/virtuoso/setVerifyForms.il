;==========================================================================
;
; $Id: setVerifyForms.il,v 1.1.1.1 2006/02/10 16:33:45 slipa Exp $
; 
;--------------------------------------------------------------------------

; set defaults for DRC form
procedure( setDRCForm()
    unless( (boundp( 'ivDRCOptionsForm ) != nil)
        createAndSetForms()
    )
    ivHiDRC()
)

; set defaults for extract form
procedure( setExtForm()
    unless( (boundp( 'ivExtOptionsForm ) != nil)
        createAndSetForms()
    )
    ivHiExtract()
)

procedure( createAndSetForms()
    iviCreateExtForm()
    hiInstantiateForm(ivExtOptionsForm)
    ivExtOptionsForm->echoCommands->value = nil

    iviCreateDRCForm()
    hiInstantiateForm(ivDRCOptionsForm)
    ivDRCOptionsForm->echoCommands->value = nil
)
