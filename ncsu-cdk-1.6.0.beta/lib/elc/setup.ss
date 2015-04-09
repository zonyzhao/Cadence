
// Encounter Library Characterizer setup file

// Define voltage and temp for process corners
Process typical{
	voltage = 1.8;
	temp = 25;
	Corner = "tt";
	Vtn = 0.5;
	Vtp = 0.5;
};


Process best{
	voltage = 2.0;
	temp = 0;
	Corner = "FF";
	Vtn = 0.4;
	Vtp = 0.4;
};

Process worst{
	voltage = 0.6;
	temp = 125;
	Corner = "SS";
	Vtn = 0.6;
	Vtp = 0.6;
};

// define measurement percentages for std_cell measurements
Signal std_cell {
	unit = REL;
	Vh=1.0 1.0;
	Vl=0.0 0.0;
	Vth=0.5 0.5;
	Vsh=0.8 0.8;
	Vsl=0.2 0.2;
	tsmax=1.0n;
};



Signal VDD1.8V {
	unit = ABS;
	Vh=1.8 1.8;
	Vl=0.0 0.0;
	Vth=0.9 0.9;
	Vsh=1.44 1.44;
	Vsl=0.36 0.36;
	tsmax=1.0n;
};


// Set some parameters for how the simulation will proceed	
Simulation std_cell{
	transient = 0.1n 80n 10p;
//	dc = 0.1 1.0 0.1;
	bisec = 6.0n 6.0n 10p;
	resistance = 10MEG;
};

// Default indices for the look up tables
Index DEFAULT_INDEX{
	Slew = 20p 50p 100p 200p 500p;
	Load = 0.005p 0.010p 0.020p 0.050p 0.100p;
};

// Indices for cells that are named with Xn where
// n is the drive strength. X1 is a standard unit-sized
// inverter drive. 
Index 1X{
	Slew = 20p 50p 100p 200p 500p;
	Load = 0.005p 0.010p 0.020p 0.050p 0.100p;
};

Index 2X{
	Slew = 20p 50p 100p 200p 500p;
	Load = 0.010p 0.020p 0.040p 0.100p 0.200p;
};

Index 4X{
	Slew = 20p 50p 100p 200p 500p;
	Load = 0.020p 0.040p 0.080p 0.200p 0.400p;
};

Index 8X{
	Slew = 20p 50p 100p 200p 500p;
	Load = 0.040p 0.080p 0.160p 0.400p 0.800p;
};
Index 16X{
	Slew = 20p 50p 100p 200p 500p;
	Load = 0.080p 0.160p 0.320p 0.800p 1.600p;
};

Index Clk_Slew{
	bslew = 20p 50p 100p 200p 500p;
};

Group POWR{
	PIN = *vdd;
};

Group Core_Pins{
	PIN = *.din *.dout *.A *.B *.Y;
};

// Define groups by cell names
// Cells not in these groups will get the default indices 
Group 1X{
	CELL = *1X ;
};

Group 2X{
	CELL = *2X ;
};

Group 4X{
	CELL = *4X ;
};

Group 8X{
	CELL = *8X ;
};

Group 16X{
	CELL = *16X ;
};

Group Clk_Slew{
	PIN = *.clk *.clkn ;
};

// Define derating coefficients for margins 
// 1.0 means no margins. 
Margin m0 {
	setup 	= 1.0 0.0 ;
	hold 	= 1.0 0.0 ;
	release = 1.0 0.0 ;
	removal = 1.0 0.0 ;
	recovery = 1.0 0.0 ;
	width	= 1.0 0.0 ;
	delay 	= 1.0 0.0 ;
	power 	= 1.0 0.0 ;
	cap 	= 1.0 0.0 ;
} ;

Nominal n0 {
	delay = 0.5 0.5 ;
	power = 0.5 0.5 ;
	cap   = 0.5 0.5 ;
} ;

set process(typical,best,worst){
	simulation = std_cell;
	signal = std_cell;
	margin = m0;
	nominal = n0;
};

set index(typical,best,worst){
	Group(1X) = 1X;
	Group(2X) = 2X;
	Group(4X) = 4X;
	Group(8X) = 8X;
	Group(16X) = 16X;
	Group(Core_Pins) = 4X;
	Group(Clk_Slew)  = Clk_Slew;
};

set signal(typical,best,worst){
	Group(POWR) = VDD1.8V;
};
