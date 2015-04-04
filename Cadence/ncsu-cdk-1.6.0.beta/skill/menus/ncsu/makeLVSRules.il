;==========================================================================
;
; $Id: makeLVSRules.il,v 1.1.1.1 2006/02/10 16:33:46 slipa Exp $
; 
;--------------------------------------------------------------------------

procedure( combineParallelFET( m1 m2 )
/*
 * combine parallel FETs 
 */
prog( (mt m_m1 m_m2)

    mt = list( nil )

    if( ((m1->l != nil) && (m2->l != nil)) then
        if( (m1->l != m2->l)    ; don't combine different lengths
            return( "doNotCombine" )
        )
        mt->l = m1->l
    )

    ; check for "m" (multiplier) parameters
    if( (m1->m != nil) then 
        m_m1 = m1->m
    else
        m_m1 = 1
    )
    if( (m2->m != nil) then 
        m_m2 = m2->m
    else
        m_m2 = 1
    )
    
    if( ((m1->w != nil) && (m2->w != nil)) then
        mt->w = (m_m1 * m1->w) + (m_m2 * m2->w)
    )

    return( mt )
))

; combine parallel resistors 
procedure( combineParallelRes( r1 r2 )
prog( (rt)

    rt = list( nil )

    if( ((r1->r != nil) && (r2->r != nil))
        rt->r = (r1->r * r2->r) / (r1->r + r2->r)
    )

    return( rt )
))

; combine series resistors 
procedure( combineSeriesRes( r1 r2 )
prog( (rt)

    rt = list( nil )

    if( ((r1->r != nil) && (r2->r != nil))
        rt->r = r1->r + r2->r
    )

    return( rt )
))

procedure( compareResistor( r1 r2 )      ; r1->layout, r2->schematic
/*
 * compare resistance values of two resistors
 */
prog( (errMsg err)

    errMsg = ""
    err = nil
    
    ; check to see if there are missing parameters
    if( (r1->r == nil) then
        errMsg = strcat( errMsg "Missing resistance property \"r\" (layout)\n" )
        err = t
    )
    if( (r2->r == nil) then
        errMsg = strcat( errMsg "Missing resistance property \"r\" (schematic)\n" )
        err = t
    )

    ; if there were, return the err mesg now, since parameter comparison
    ; would be meaningless
    if( err then
        return( errMsg )
    )

    ; if params were all there, check that they match (within "slack")
    if( (abs( r1->r - r2->r ) > NCSU_LVSResSlack * r2->r) then
        sprintf( errMsg "Resistance mismatch: layout %d, schematic %d\n" 
                 round(r1->r) round(r2->r) )
        return( errMsg )
    )

    ; everything's ok, return nil

    return( nil )
))

procedure( compareFET( m1 m2 )          ; m1->layout, m2->schematic
/*
 * compare parameters of two FETs
 */
prog( (errMsg err m)

    errMsg = ""
    err = nil

    ; check to see if any parameters are missing.     
    if( (m1->l == nil) then
        errMsg = strcat( errMsg "Missing transistor length property \"l\" (layout)\n" )
        err = t
    )
    if( (m2->l == nil) then
        errMsg = strcat( errMsg "Missing transistor length property \"l\" (schematic)\n" )
        err = t
    )
    if( (m1->w == nil) then
        errMsg = strcat( errMsg "Missing transistor width property \"w\" (layout)\n" )
        err = t
    )
    if( (m2->w == nil) then
        errMsg = strcat( errMsg "Missing transistor width property \"w\" (schematic)\n" )
        err = t
    )

    ; if params are missing, go ahead and return an error, since the
    ; "mismatch" error messages would be meaningless
    if( err then
        return( errMsg )
    )

    ; if params were there, check for length & width mismatch
    ; XXX - ugly kludge with the constant. can we use a lib. prop or
    ; techparam?
    if( ( abs( m1->l - m2->l ) * 1e6 > 0.01 ) then
        errMsg = strcat( errMsg
                         sprintf( nil "Transistor length mismatch: layout %.2f um, schematic %.2f um\n"
                                  m1->l * 1e6 m2->l * 1e6 ) ) 
        err = t
    )
    
    ; check for "m" (multiplier) parameter on the schematic instance
    if( (m2->m != nil) then
        m = m2->m
    else
        m = 1
    )

    ; XXX - this is an ugly kludge with the constant. it'd be nice to
    ; use a lib prop or techparam.
    if( ( abs( m1->w - ( m2->w * m ) ) * 1e6 > 0.01 ) then
        errMsg = strcat( errMsg
                         sprintf( nil "Transistor width mismatch: layout %.2f um, schematic %.2f um\n"
                                  m1->w * 1e6 m2->w * m * 1e6 ) ) 
        err = t
    )
    
    ; if we had an error, return the error string, otherwise return nil
    if( err then
        return( errMsg )
    else
        return( nil )
    )
))

; combine series caps 
procedure( combineSeriesCap( c1 c2 )
prog( (ct)

    ct = list( nil )

    if( ((c1->c != nil) && (c2->c != nil))
        ct->c = (c1->c * c2->c) / (c1->c + c2->c)
    )

    return( ct )
))

; combine parallel caps 
procedure( combineParallelCap( c1 c2 )
prog( (ct)

    ct = list( nil )

    if( ((c1->c != nil) && (c2->c != nil))
        ct->c = c1->c + c2->c
    )

    return( ct )
))

procedure( compareCapacitor( c1 c2 )      ; c1->layout, c2->schematic
/*
 * compare capacitance values of two caps
 */
prog( (errMsg err)

    errMsg = ""
    err = nil

    ; check to see if there are any missing params
    if( (c1->c == nil) then
        errMsg = strcat( errMsg "Missing capacitance property \"c\" (layout)\n" )
        err = t
    )
    if( (c2->c == nil) then
        errMsg = strcat( errMsg "Missing capacitance property \"c\" (schematic)\n" )
        err = t
    )

    ; if there were, return the err mesg now, since parameter comparison
    ; would be meaningless
    if( err then
        return( errMsg )
    )

    ; if params were all there, check that they match (within "slack")
    if( (abs( c1->c - c2->c ) > NCSU_LVSCapSlack * c2->c) then
        sprintf( errMsg "Capacitance mismatch: layout %f, schematic %f\n" c1->c c2->c )
        return( errMsg )
    )

    ; everything's ok, return nil

    return( nil )
))

/**********************************************************/

procedure( makeLVSRules()
let( (lib lvsPort rulesFile)

    lib = ddGetObj( lvsRulesForm->libName->value )
    if( lib == nil then
        hiGetAttention()
        error( "Can't find library \"%s\"!" lvsRulesForm->libName->value )
    )
    /*
     * Make new rules file. (The reason to do the delete before making
     * the new file if the current file is a link to the site file is
     * that opening it will actually open the site file, which we don't
     * want to do.)
     */
    rulesFile = strcat( ddGetObjWritePath( lib ) "/divaLVS.rul" )
    if( isLink( rulesFile ) then
        deleteFile( rulesFile )
    )
    lvsPort = outfile( rulesFile "w" )
    if( lvsPort == nil then
        hiGetAttention()
        error( "Can't create LVS rules file. Aborting...." )
    )

    fprintf( lvsPort "/*\n * LVS rules file created by NCSU CDK\n */\n\n" )
    fprintf( lvsPort "lvsRules(\n" )

    /*
     * Print any callback functions first, before the actual LVS rules
     */
    if( lvsRulesForm->compareFetParameters->value then
        pp( combineParallelFET lvsPort ) 
        pp( compareFET lvsPort )
    )
    if( lvsRulesForm->combineParallelRes->value then
        pp( combineParallelRes lvsPort )
    )
    if( lvsRulesForm->combineSeriesRes->value then
        pp( combineSeriesRes lvsPort )
    )
    if( lvsRulesForm->compareRes->value then
        pp( compareResistor lvsPort ) 
    )
    if( lvsRulesForm->combineParallelCap->value then
        pp( combineParallelCap lvsPort )
    )
    if( lvsRulesForm->combineSeriesCap->value then
        pp( combineSeriesCap lvsPort )
    )
    if( lvsRulesForm->compareCap->value then
        pp( compareCapacitor lvsPort ) 
    )

    /* 
     * Print the actual LVS rule commands
     */
    if( lvsRulesForm->combineParallelFET->value then
        if( lvsRulesForm->compareFetParameters->value then
            fprintf( lvsPort "permuteDevice(parallel \"nfet\" combineParallelFET)\n" )
            fprintf( lvsPort "permuteDevice(parallel \"pfet\" combineParallelFET)\n" )
            fprintf( lvsPort "permuteDevice(parallel \"nmos\" combineParallelFET)\n" )
            fprintf( lvsPort "permuteDevice(parallel \"pmos\" combineParallelFET)\n" )
            fprintf( lvsPort "permuteDevice(parallel \"nmos4\" combineParallelFET)\n" )
            fprintf( lvsPort "permuteDevice(parallel \"pmos4\" combineParallelFET)\n" )
        else
            fprintf( lvsPort "permuteDevice(parallel \"nfet\")\n" )
            fprintf( lvsPort "permuteDevice(parallel \"pfet\")\n" )
            fprintf( lvsPort "permuteDevice(parallel \"nmos\")\n" )
            fprintf( lvsPort "permuteDevice(parallel \"pmos\")\n" )
            fprintf( lvsPort "permuteDevice(parallel \"nmos4\")\n" )
            fprintf( lvsPort "permuteDevice(parallel \"pmos4\")\n" )
        )
    )

    if( lvsRulesForm->combineParallelRes->value then
        fprintf( lvsPort "permuteDevice(parallel \"res\" combineParallelRes)\n" )
    )
    if( lvsRulesForm->combineSeriesRes->value then
        fprintf( lvsPort "permuteDevice(series \"res\" combineSeriesRes)\n" )
    )
    if( lvsRulesForm->compareRes->value then
        fprintf( lvsPort "NCSU_LVSResSlack = %.2f\n" NCSU_LVSResSlack )
        fprintf( lvsPort "compareDeviceProperty(\"res\" compareResistor)\n" )
    )

    if( lvsRulesForm->combineParallelCap->value then
        fprintf( lvsPort "permuteDevice(parallel \"cap\" combineParallelCap)\n" )
    )
    if( lvsRulesForm->combineSeriesCap->value then
        fprintf( lvsPort "permuteDevice(series \"cap\" combineSeriesCap)\n" )
    )
    if( lvsRulesForm->compareCap->value then
        fprintf( lvsPort "NCSU_LVSCapSlack = %.2f\n" NCSU_LVSCapSlack )
        fprintf( lvsPort "compareDeviceProperty(\"cap\" compareCapacitor)\n" )
    )

    if( lvsRulesForm->compareFetParameters->value then
        fprintf( lvsPort "compareDeviceProperty(\"nfet\" compareFET)\n" )
        fprintf( lvsPort "compareDeviceProperty(\"pfet\" compareFET)\n" )
        fprintf( lvsPort "compareDeviceProperty(\"nmos\" compareFET)\n" )
        fprintf( lvsPort "compareDeviceProperty(\"pmos\" compareFET)\n" )
        fprintf( lvsPort "compareDeviceProperty(\"nmos4\" compareFET)\n" )
        fprintf( lvsPort "compareDeviceProperty(\"pmos4\" compareFET)\n" )
    )
        
    if( lvsRulesForm->permuteSeriesFET->value then
        fprintf( lvsPort "permuteDevice(MOS \"nfet\")\n" )
        fprintf( lvsPort "permuteDevice(MOS \"pfet\")\n" )
        fprintf( lvsPort "permuteDevice(MOS \"nmos\")\n" )
        fprintf( lvsPort "permuteDevice(MOS \"pmos\")\n" )
        fprintf( lvsPort "permuteDevice(MOS \"nmos4\")\n" )
        fprintf( lvsPort "permuteDevice(MOS \"pmos4\")\n" )
    )

    if( lvsRulesForm->ignoreBodyTerminal->value then
        fprintf( lvsPort "ignoreTerminal(\"nfet\" \"B\" )\n" )
        fprintf( lvsPort "ignoreTerminal(\"pfet\" \"B\" )\n" )
        fprintf( lvsPort "ignoreTerminal(\"nmos\" \"B\" )\n" )
        fprintf( lvsPort "ignoreTerminal(\"pmos\" \"B\" )\n" )
        fprintf( lvsPort "ignoreTerminal(\"nmos4\" \"B\" )\n" )
        fprintf( lvsPort "ignoreTerminal(\"pmos4\" \"B\" )\n" )
    )

    fprintf( lvsPort ")\n" )    ; close lvsRules()
    close( lvsPort )
))

procedure( showLVSRulesForm()
let( (cv lib rulesFile lvsPort line)

    cv = hiGetCurrentWindow()->cellView
    lvsRulesForm->libName->value = cv->libName

    /*
     * set all nil at first
     */
    lvsRulesForm->combineParallelFET->value = nil
    lvsRulesForm->combineParallelRes->value = nil
    lvsRulesForm->combineSeriesRes->value = nil
    lvsRulesForm->combineParallelCap->value = nil
    lvsRulesForm->combineSeriesCap->value = nil
    lvsRulesForm->compareFetParameters->value = nil
    lvsRulesForm->compareRes->value = nil
    lvsRulesForm->compareCap->value = nil
    lvsRulesForm->permuteSeriesFET->value = nil
    lvsRulesForm->ignoreBodyTerminal->value = nil

    /*
     * use divaLVS.rul from design lib if it's there; if not, go to tech
     * lib
     */
    lib = cv->lib
    rulesFile = strcat( ddGetObjWritePath( lib ) "/divaLVS.rul" )
    unless( isFile( rulesFile )
        lib = GetEditTechLib()
        rulesFile = strcat( ddGetObjWritePath( lib ) "/divaLVS.rul" )
    )

    /*
     * read current rules and set form accordingly
     * BUGLET: does not take comments into account
     */
    if( isFile( rulesFile ) then
        lvsPort = infile( rulesFile )
        while( gets( line lvsPort ) != nil
            cond(
                (rexMatchp( "permuteDevice([ ]*MOS" line )
                 lvsRulesForm->permuteSeriesFET->value = t
                )
                (rexMatchp( "permuteDevice([ ]*parallel[ ]*\"[np]" line )
                 lvsRulesForm->combineParallelFET->value = t
                )
                (rexMatchp( "permuteDevice([ ]*parallel[ ]*\"res" line )
                 lvsRulesForm->combineParallelRes->value = t
                )
                (rexMatchp( "permuteDevice([ ]*series[ ]*\"res" line )
                 lvsRulesForm->combineSeriesRes->value = t
                )
                (rexMatchp( "permuteDevice([ ]*parallel[ ]*\"cap" line )
                 lvsRulesForm->combineParallelCap->value = t
                )
                (rexMatchp( "permuteDevice([ ]*series[ ]*\"cap" line )
                 lvsRulesForm->combineSeriesCap->value = t
                )
                (rexMatchp( "compareDeviceProperty([ ]*\"[np]" line )
                 lvsRulesForm->compareFetParameters->value = t
                )
                (rexMatchp( "compareDeviceProperty([ ]*\"res" line )
                 lvsRulesForm->compareRes->value = t
                )
                (rexMatchp( "compareDeviceProperty([ ]*\"cap" line )
                 lvsRulesForm->compareCap->value = t
                )
                (rexMatchp( "ignoreTerminal([ ]*\"[np]" line )
                 lvsRulesForm->ignoreBodyTerminal->value = t
                )
            )
        )
        close( lvsPort )
    )

    hiDisplayForm( lvsRulesForm )
))

hiCreateAppForm(
                ?name 'lvsRulesForm
                ?formTitle "Modify LVS Rules"
                ?callback "makeLVSRules()"
                ?buttonLayout 'OKCancel
                ?unmapAfterCB t
                ?fields list(
                            hiCreateStringField(
                                ?name 'libName
                                ?prompt "Library: "
                                ?editable nil )
                            hiCreateBooleanButton(
                                ?name 'permuteSeriesFET
                                ?buttonText "Allow FET Series Permutation"
                                ?value t )
                            hiCreateBooleanButton(
                                ?name 'combineParallelFET
                                ?buttonText "Combine Parallel FETs"
                                ?value t )
                            hiCreateBooleanButton(
                                ?name 'combineParallelRes
                                ?buttonText "Combine Parallel Resistors"
                                ?value t )
                            hiCreateBooleanButton(
                                ?name 'combineSeriesRes
                                ?buttonText "Combine Series Resistors"
                                ?value t )
                            hiCreateBooleanButton(
                                ?name 'combineParallelCap
                                ?buttonText "Combine Parallel Capacitors"
                                ?value t )
                            hiCreateBooleanButton(
                                ?name 'combineSeriesCap
                                ?buttonText "Combine Series Capacitors"
                                ?value t )
                            hiCreateBooleanButton(
                                ?name 'compareFetParameters
                                ?buttonText "Compare FET Parameters"
                                ?value nil )
                            hiCreateBooleanButton(
                                ?name 'ignoreBodyTerminal
                                ?buttonText "Ignore FET Body Terminal"
                                ?value nil )
                            hiCreateBooleanButton(
                                ?name 'compareCap
                                ?buttonText "Compare Capacitor Parameters"
                                ?value nil )
                            hiCreateBooleanButton(
                                ?name 'compareRes
                                ?buttonText "Compare Resistor Parameters"
                                ?value nil )
                        )
                ?help ""
                 )
; vim:columns=132:
