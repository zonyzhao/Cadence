let( (Dir FileList File)
	Dir = prependNCSUCDKInstallPath( "skill/cdf/Analog_Parts" )
	if( isDir( Dir ) then FileList = getDirFiles( Dir ) )
	unless( FileList == nil 
		foreach( File FileList
			unless( File == "." || File == ".." || File == "RCS" || File == "loadSkill.il"
				;printf( "Loading %s\n" File )
				load( strcat(Dir "/" File) )
			)
		)
	)
)
