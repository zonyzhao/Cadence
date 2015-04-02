defun(ABbnNetlistProc (inst)
    let((formatter netlister bulk sigs)
        ;----------------------------------------------------------------
        ; Get hold of the formatter and netlister objects
        ;----------------------------------------------------------------
        formatter=nlGetFormatter(inst)
        netlister=nlGetNetlister(formatter)

        nlPrintInstComments(formatter inst)
        nlPrintIndentString(netlister)
        nlPrintInstName(formatter inst)
        ;----------------------------------------------------------------
        ; Print the standard signals. Can't use nlPrintInstSignals
        ; because the parentheses would be around the terminals in
        ; the termOrder, and not include the bulk node
        ;----------------------------------------------------------------
        sigs=nlGetSignalList(inst)
        nlPrintString(netlister " (" car(sigs))
        foreach(sig cdr(sigs)
            nlPrintString(netlister " " sig)
        ) ; foreach
        ;----------------------------------------------------------------
        ; Get the bn parameter and output that as the connection, if
        ; it is set
        ;----------------------------------------------------------------
        bulk=nlGetParamStringValue(inst "bn")
        when(member(bulk '("D" "G" "S"))
            bulk=nlGetTerminalSignalName(inst bulk)
            )
        when(bulk
            nlPrintString(netlister " " bulk)
            )
        ;----------------------------------------------------------------
        ; Write out the close parenthesis, now that the bulk is written
        ;----------------------------------------------------------------
        nlPrintString(netlister ")")

        nlPrintModelName(formatter inst)
        nlPrintInstParameters(formatter inst)
        )
    )


procedure(  W1NetlistProc(inst)
    let((formatter netlister sigs session )
        ;----------------------------------------------------------------
        ; Get hold of the formatter and netlister objects
        ;----------------------------------------------------------------
        ;formatter=nlGetFormatter(inst)
        ;netlister=nlGetNetlister(formatter)
	
	session=asiGetCurrentSession()
	formatter=asiGetFormatter( session )
	netlister=nlGetNetlister(formatter)
	
	nlPrintInstComments(formatter inst)
        nlPrintIndentString(netlister)
        nlPrintInstName(formatter inst)
	nlPrintString(netlister " N=1")
        ;----------------------------------------------------------------
        ; Print the standard signals. 
        ;----------------------------------------------------------------
        sigs=nlGetSignalList(inst)
        nlPrintString(netlister " (" car(sigs))
        foreach(sig cdr(sigs)
            nlPrintString(netlister " " sig)
        ) ; foreach
        
        ;----------------------------------------------------------------
        ; Write out the close parenthesis
        ;----------------------------------------------------------------
        nlPrintString(netlister ")")

        nlPrintModelName(formatter inst)
        nlPrintInstParameters(formatter inst)
        )
    )

