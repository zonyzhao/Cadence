/* CCScheckAndUpdateCDF.il

Group		Custom IC, Cadence Design Systems
Language	SKILL
Revision No.	1.2
Date Created	Jan 06, 2004 
Last Modified	
Tested in	IC50
Lint score	100 (best is 100)
Description:

This file defines a procedure CCScheckAndUpdateCDF which can be
called directly or as a schematic post-check operation (which this
file registers to be called automatically). The procedure compares
the terminal names from the schematic against those found in the CDF
simInfo sections for each simulator - the user is presented with the
choice of replacing the termOrder simInfo CDF property for each
simulator where the terminal names did not match. The new terminal
order will be based on the alphabetic comparison of the names;
care should be taken to ensure that the terminal order is correct
for that cell, especially with regards to subcircuits/macromodels.

Usage:

  ;; run in a standalone mode
  cv = dbOpenCellViewByType("mylib" "mycell" "schematic")
  CCScheckAndUpdateCDF(cv)


***************************************************

SCCS Info: @(#) CCScheckAndUpdateCDF.il 01/12/04.15:46:29 1.2

********************************************************************
* DISCLAIMER: The following code is provided for Cadence customers *
* to use at their own risk. The code may require modification to   *
* satisfy the requirements of any user. The code and any           *
* modifications to the code may not be compatible with current or  *
* future versions of Cadence products.                             *
* THE CODE IS PROVIDED "AS IS" AND WITH NO WARRANTIES, INCLUDING   *
* WITHOUT LIMITATION ANY EXPRESS WARRANTIES OR IMPLIED WARRANTIES  *
* OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR USE.              *
********************************************************************

*/

/****************************************************************
*                                                               *
*       CCScheckAndUpdateCDF(d_cv [x_numerr] [x_numwarn])       *
*                                                               *
* This procedure requires a cellview db object to be passed in, *
* optionally a number of errors and warnings can be passed in,  *
*  this is only for the post schematic check trigger and these  *
*  arguments are ignored if supplied. The cellviews' terminal   *
* names are compared against the termOrder property in the CDF  *
* for each simulator, and if different can be updated. The user *
* is asked which simulator termOrder properties to update. Any  *
*                 changes to the CDF are saved.                 *
*                                                               *
****************************************************************/

procedure(CCScheckAndUpdateCDF(cv @optional _numerr _numwarn)
let( (terms cdf simInfo info termOrder ask cdfChanged)
  ;; when the cellview passed in is a valid db object
  when(dbIsId(cv)
    ;; get a list of terminal names and sort alphabetically
    setq(terms dbGetq(dbGetq(cv terminals) name))
    setq(terms sort(terms 'alphalessp))
    ;; when the cell has base CDF, get the simInfo for the cell
    when(setq(cdf cdfGetBaseCellCDF(dbGetq(cv cell)))
      when(setq(simInfo getq(cdf simInfo))
	;; for each simulator in the list get the simulator specific 
	;; simulation information (if any) and if it has a termOrder
	;; parameter, compare the contents of this against the list of
	;; terminal names obtained above:
	;; if every terminal is not found in both lists then it might
	;; be a candidate for replacing the termOrder parameter
        foreach(sim '(UltraSim ams auCdl auLvs cdsSpice hspiceD
		      hspiceS spectre spectreS)
	  when(setq(info get(simInfo sim))
	    when(setq(termOrder getq(info termOrder))
	      unless(and(
		      forall(term terms member(term termOrder))
		      forall(term termOrder member(term terms)))
		;; if we asked before and the answer was "All" or "None"
		;; then do not ask again, otherwise ask the user if the
		;; CDF simInfo should be updated for this simulator
		unless(or(eq(ask 3) eq(ask 4))
		  ;; ask the user with a dialog box
		  setq(ask hiDisplayAppDBox(
		    ?name 'blah
		    ?dboxBanner "Change CDF termOrder?"
		    ?dboxText sprintf(nil strcat(
		  "Change CDF termOrder for this simulator\n%s, All or None?"
		  "\nCurrently: \"%s\" \tWill be: \"%s\"")
		      sim buildString(termOrder) buildString(terms))
		    ?buttonLayout 'UserDefined
		    ?buttons '(Yes No All None)
		    ?defaultButton 1))
		); unless
		;; if the user answered "Yes" or "All" then update the
		;; termOrder property for this simulator
		caseq(ask
		  ((1 3)
		    printf("Updating CDF simInfo termOrder for %s\n" sim)
		    putpropq(info terms termOrder)
		    setq(cdfChanged t)
		  )
		  (t nil)
		); case
	      ); unless terminal names are equivalent
	    ); when termOrder exists
	  ); when this simulator is in simInfo
	); foreach simulator
      ); when simInfo exists in CDF
      ;; if the CDF changed save it
      when(cdfChanged
	cdfSaveCDF(cdf)
      )
    ); when the cell has CDF
  ); when a valid db object
); let
); procedure CCScheckAndUpdateCDF

;; register a Post Schematic Check trigger so that CCScheckAndUpdateCDF
;; is called after any schematic check operation.
schRegPostCheckTrigger('CCScheckAndUpdateCDF)
