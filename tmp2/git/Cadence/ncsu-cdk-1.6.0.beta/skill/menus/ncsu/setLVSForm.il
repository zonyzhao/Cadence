;==========================================================================
;
; $Id: setLVSForm.il,v 1.1.1.1 2006/02/10 16:33:46 slipa Exp $
; 
;--------------------------------------------------------------------------

procedure( setLVSForm()
let( (lib rulesFile rulesLib)
    unless( isContextLoaded( "LVS" )
        loadContext( prependInstallPath( "etc/context/LVS.cxt" ) )
    )
    ivHiLVS()

    /*
     * use current lib if it has its own divaLVS.rul file; otherwise, use
     * (attached) tech lib
     */
    lib = hiGetCurrentWindow()->editCellView->lib
    rulesFile = strcat( ddGetObjWritePath( lib ) "/divaLVS.rul" )
    if( isFile( rulesFile ) then
        rulesLib = lib->name
    else
        rulesLib = GetEditTechLib()->name
    )

    ; so we don't trigger the callback when we set rulesLibButton below
    ivLVSEnvForm->rulesLibButton->_callback = nil

    ivLVSEnvForm->rulesFilePath->value = "divaLVS.rul"
    ivLVSEnvForm->rulesLibName->value = rulesLib
    ivLVSEnvForm->rulesLibButton->value = t
    ivLVSEnvForm->rulesLibName->editable = t

    ivLVSEnvForm->rulesLibButton->_callback = "
        ivLVSEnvForm->rulesLibName->editable = ivLVSEnvForm->rulesLibButton->value
        if( ivLVSEnvForm->rulesLibButton->value == t then
            ddsSyncWithForm( ivLVSEnvForm 'libBrowse 'rulesLibName 
                                          'nil 'nil nil )
        )"
))
