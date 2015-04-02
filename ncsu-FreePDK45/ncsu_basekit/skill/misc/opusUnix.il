;==========================================================================
;
; $Id: opusUnix.il 3 2007-01-10 22:50:03Z wdavis $
; 
; Revision History
;
; $Log$
; Revision 1.1.1.1  2006/02/10 16:33:46  slipa
; starting CDK v1.5.0rc1 source file
;
; Revision 1.1  1997/12/18 19:31:50  astanas
; Initial revision
;
;
; 950922 JTS Changed pwd() to getWorkingDir()
;
;--------------------------------------------------------------------------

/****************************************************************/
/*                                                              */
/* Author: Robert Jarolin                                       */
/*         Department of Defense                                */
/*         301-688-0092                                         */
/*         rmjford@romulus.ncsc.mil                             */
/*                                                              */
/* Program: opusUNIX.il                                         */
/*                                                              */
/* Date: 5 August 1994                                          */
/*                                                              */
/* Function Names:                                              */
/*      cd(dir)                                                 */
/*      ls(dir)                                                 */
/*      cat(fileName)                                           */
/*      rm(fileName)                                            */
/*                                                              */
/* Purpose:                                                     */
/*        These routines are for emulating some unix commands   */
/*        in the CI Window (CIW).                               */
/****************************************************************/


nprocedure( cd(dir)
   if(dir then
      dir = car(dir)
      println(dir)
      if(type(dir) == 'list && length(dir) > 1
         dir = buildString(cdr(dir) "."))
   else
      dir = "~"
   )
   changeWorkingDir(dir)
   getWorkingDir()
)

nprocedure( ls(dir)
   let( (list string)
      if(dir then
         dir = car(dir)
         if(isDir(dir) then
            list = getDirFiles(dir)
         else
            list = getDirFiles(getWorkingDir())
            list = rexMatchList(dir list)
         )
      else
         list = getDirFiles(getWorkingDir())
      )
      for(i 1 length(list)
         if( isDir(nth(i-1 list)) then
            string = strcat(nth(i-1 list) "/")
         else
            string =  nth(i-1 list)
         )
         printf("  %25s" string)
         if(mod(i 3) == 0 printf("\n"))
      )
   )
)

nprocedure( cat(fileName)
   let( (file)
      if(fileName then
      println(fileName)
         fileName = car(fileName)
         if(type(fileName) == 'list && length(fileName) > 1
            fileName = buildString(cdr(fileName) "."))
         if(file = infile(fileName) then
            while(gets(string file)
               printf("%s" string)
            )
            close(file)
         else
            printf(File "\"%s\" not found!\n" fileName)
         )
      else
         println("No file specified!")
      )
   )
)

nprocedure( rm(fileName)
   if(fileName then
      fileName = car(fileName)
      if(isFile(fileName) then
         deleteFile(fileName)
      else
         printf("File \"%s\" not found!\n" fileName)
      )
   else
      println("No file specified!")
   )
)

procedure( pwd() getWorkingDir() )
