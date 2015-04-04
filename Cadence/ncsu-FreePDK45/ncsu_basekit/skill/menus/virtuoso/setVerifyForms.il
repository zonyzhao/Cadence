;==========================================================================
;
; $Id: setVerifyForms.il 3 2007-01-10 22:50:03Z wdavis $
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
