#!/usr/local/bin/perl -I/afs/eos/contrib/perl/lib/5.00503 -I/afs/eos/service/ece/adm/local/lib/perl5/site_perl

# $Id: bitgen.pl,v 1.1.1.1 2006/02/10 16:33:46 slipa Exp $

require 5.000;
# Also, due to Tk-GBARR, Perl/Tk 402.002 or later is required.

use strict "subs";
use strict "vars";

use Tk;                 # Perl/Tk distribution
use Tk::Balloon;        # Perl/Tk distribution
use Tk::Pane;           # Tk-GBARR or Perl/Tk distribution 800.015 (I think)
use Tk::TFrame;         # Tk-GBARR

use vars qw( $opt_b $opt_h );
use Getopt::Std;

sub doExit;
sub doPlot();
sub makeSigviewHeader;
sub doMessageBox;
sub doNewSource;
sub dupSrc;
sub setBalloonHelp;
sub createNewSourceWidgets;
sub resetSrc;
sub deleteSrc;
sub doExport;
sub doSave;
sub doOpen;
sub doBitWave;
sub doBusWave;
sub doClockWave;
sub doDCWave;
sub printBitWave;
sub getParameters;
sub getOutfileHandle;
sub expandDataStream;
sub showSourceListWindow;
sub addToSourceListWindow;
sub setBallonHelpState;
sub setMainWindowTitle;
sub createOptionsWindow;
sub createHelpWindow;
sub createAboutWindow;
sub setupGUI;
sub busyCursor;
sub assignElement;
sub get;

# waveform characteristics' defaults
my $RT_DEFAULT = "1n";         # rise time (seconds)
my $FT_DEFAULT = "1n";         # fall time (seconds)
my $RT_DEFAULT_CLK = "10%";    # rise time (percentage of period, for clock)
my $FT_DEFAULT_CLK = "10%";    # fall time (percentage of period, for clock)
my $PW_DEFAULT = "10n";        # pulse width (seconds)
my $ON_DEFAULT = "3.3";        # logic "1" (volts)
my $OFF_DEFAULT = "0";         # logic "0" (volts)
my $DELAY_DEFAULT = "0";       # initial delay (seconds)
my $NEGNODE_DEFAULT = "0";     # default negative node for voltage source (text string)
my $FREQ_DEFAULT = "50e6";     # default frequency for clock sources
my $DUTYCYCLE_DEFAULT = "50%"; # default duty cycle for clock sources
my $DC_DEFAULT = 3.3;          # default DC voltage

# version string
my $BitGen_Version = "2.0b";

# first line of file to mark native BitGen format
my $BitGen_Signature = "@@@ BitGen input file";

# file types for opening/saving BitGen files
my $BitGen_Filetypes = [ ['BitGen Files', '.bitgen'],
                         ['All Files',    '*'      ] ];

# parameters for waveforms
my( $rt, $ft, $pw, $freq, $dutyCycle, $on, $off, $delay, $initVal, $dc );

# default entry fields
my( $rtDefaultEntry, $ftDefaultEntry, $rtClkDefaultEntry, $ftClkDefaultEntry );
my( $pwDefaultEntry, $onDefaultEntry, $offDefaultEntry );
my( $delayDefaultEntry, $negnodeDefaultEntry, $freqDefaultEntry );
my( $dutycycleDefaultEntry, $dcDefaultEntry );

# use 'x' for meg so we can use single character for all suffixes
my %suffixes = ( 't' => 1e12,  'g' => 1e9,  'x' => 1e6,  'k' => 1e3,
                 'm' => 1e-3,  'u' => 1e-6, 'n' => 1e-9, 'p' => 1e-12,
                 'f' => 1e-15, 'a' => 1e-18 );

my( %srcFrames, %srcLabels, %srcEntries );
my( %descFrames, %descLabels, %descEntries );
my( %vecCompsFrames, %vecCompsLabels, %vecCompsEntries );
my( %posNodeFrames, %posNodeLabels, %posNodeEntries );
my( %negNodeFrames, %negNodeLabels, %negNodeEntries );
my( %dataFrames, %dataLabels, %dataEntries );
my( %dcFrames, %dcLabels, %dcEntries );
my( %rtFrames, %rtLabels, %rtEntries );
my( %ftFrames, %ftLabels, %ftEntries );
my( %pwFrames, %pwLabels, %pwEntries );
my( %freqFrames, %freqLabels, %freqEntries );
my( %dutyCycleFrames, %dutyCycleLabels, %dutyCycleEntries );
my( %onFrames, %onLabels, %onEntries );
my( %offFrames, %offLabels, %offEntries );
my( %delayFrames, %delayLabels, %delayEntries );
my( %initValFrames, %initValLabels, %initValEntries );
my( %resetSrcButtons, %deleteSrcButtons, %dupSrcButtons );
my( %sourceEnclosures, %sourceTypes );
my( %sourceListFrames, %sourceListButtons, %sourceListExpCheckB );
my( %isExportable );

# for keeping all the data before printing out
my @sigviewData;
my $maxTime = 0;
my $sigDataCount = 0;
my $sigviewCommand = "/afs/eos/dist/cad/bin/sigview";
my $makePlotFile;   # boolean flag
my $plotFile = "/tmp/sigviewfile_$<";

# currently selected netlist language
my $netlistLang = "CDS";

# comment characters
my %commentChar = ( "CDS" => "*",
                    "SPICE" => "*",
                    "Spectre" => "*",
                    "2-Column" => "*" );

# types of sources that can be added
my $newSourceTypeList = [qw( single bus clock DC )];
# currently selected source type
my $newSourceType;

# balloon help is initially on
my $doBalloonHelp = 1;

# source list window 
my $showSourceList = 1;

# to see if user has changed anything
my $needSaveFlag = 0;

# start numbering sources at ++$sourceNum
my $sourceNum = "0";

# keep track of how many sources there are
my $numSources = 0;

# if true, when duplicating a (single) source, invert all the bits
# (useful for making a source's complement)
my $invertDupSrc = 0;

# for use when selecting "Save" and "Export" (as opposed to "Save as" and
# "Export as") actions
my $currentFilename = undef;
my $currentNetlistname = undef;

# bitmap file for icon
my $iconBitmap = "/afs/eos/dist/cadence/local/bin/bitgen.xbm";

my( $main, $sourceFrame, $sourcePane, $helpWin, $aboutWin, $optionsWin ); 
my( $fileMenu, $settingsMenu, $helpMenu );
my( $srcTypeMenu, $sourceListWindow, $sourceListPane, $sourceListBalloon, $mainBalloon );
my( $addSrcButton, $saveButton, $exportButton, $plotButton, $exitButton );

my $tty = 0;
my $dataFile = "";

getopt( 'b' );
if( defined( $opt_h ) ) {
    print "Usage: $0 [-h] [-b filename|filename]\n";
    print "     -h          : print this message and exit\n";
    print "     -b filename : convert \"filename\" to SPICE format (no GUI)\n";
    print "     filename    : open \"filename\" with GUI\n";
    exit( 0 );
}
if( defined( $opt_b ) ) {
    $tty = 1;
    $dataFile = $opt_b;
}
elsif( $#ARGV == 0 ) {
    $dataFile = $ARGV[0];
}

setupGUI() unless $tty;

if( $dataFile ne "" ) {
    $main->update() unless $tty;
    doOpen( $dataFile );
}
else {
    setMainWindowTitle();
}

if( $tty ) {
    exit( 0 );
}
else {
    widgetStatus();
    MainLoop;
}

###############################################################

sub setupGUI{
    # main window
    $main = new MainWindow;
    $main->protocol( "WM_DELETE_WINDOW", \&doExit );

    # key bindings
    $main->bind( 'all', '<Control-q>' => sub { doExit(); } );
    $main->bind( 'all', '<Control-p>' => sub { doPlot(); } );
    $main->bind( 'all', '<Control-e>' => sub { doExport( "Export" ); } );
    $main->bind( 'all', '<Control-s>' => sub { doSave( "Save" ); } );
    $main->bind( 'all', '<Control-o>' => sub { doOpen(); } );
    $main->bind( 'all', '<Control-a>' => sub { doNewSource( $newSourceType ); } );

    my $menubar = $main->Frame( -relief => "raised",
                             -borderwidth => 2 )
                    ->pack( -fill => "x" );

    # "File" menu
    $fileMenu = $menubar->Menubutton( -text => "File", -underline => 0, 
                   -menuitems =>
                   [ [Button => "Open...",     -command => sub { doOpen(); },
                                               -underline => 0],
                     [Button => "Save",        -command => sub { doSave( "Save" ); },
                                               -underline => 0],
                     [Button => "Save as...",  -command => sub { doSave( "SaveAs" ); },
                                               -underline => 5],
                     [Separator => ""],
                     [Button => "Export",      -command => sub { doExport( "Export" ); },
                                               -underline => 0],
                     [Button => "Export as...",-command => sub { doExport( "ExportAs" ); }],
                     [Separator => ""],
                     [Button => "Exit",        -command => sub { doExit(); },
                                               -underline => 1 ] ] )
            ->pack( -side => "left" );

    # "Settings" menu
    $settingsMenu = $menubar->Menubutton( -text => "Settings", -underline => 0,
               -menuitems =>
               [ [Cascade => 'Netlist language',
                             -menuitems => [ map( [Radiobutton => "$_",
                                                   -variable => \$netlistLang],
                                                  (qw(CDS SPICE Spectre 2-Column))) ] ],
                 [Checkbutton => "Balloon help", -command => sub { setBallonHelpState(); },
                                                 -variable => \$doBalloonHelp],
                 [Checkbutton => "Show source list", -command => sub {showSourceListWindow();},
                                                     -variable => \$showSourceList],
                 [Separator => ''],
                 [Button => "Source defaults...", -command => sub {$optionsWin->deiconify();}] ] )
            ->pack( -side => "left" );

    # "Help" menu
    $helpMenu = $menubar->Menubutton( -text => "Help", -underline => 0,
                   -menuitems =>
                   [ [Button => "Help...",  -command => sub { $helpWin->deiconify(); }],
                     [Button => "About...", -command => sub { $aboutWin->deiconify(); }]])
            ->pack( -side => "right" );


    # window with list of sources, initially unmapped
    $sourceListWindow = new MainWindow;
    $sourceListWindow->withdraw();
    $sourceListWindow->configure( -title => "Source List" );
    $sourceListWindow->protocol( "WM_DELETE_WINDOW", \sub { $showSourceList = 0;
                                                            showSourceListWindow(); } );
    $sourceListPane = $sourceListWindow->Scrolled( "Pane", Name => "sourceListPane", 
                                                      -scrollbars => "w",
                                                      -sticky => "ew" )
                                           ->pack( -expand => 1,
                                                   -fill => "both" );

    # $multiFrame is to hold the next widgets; need this frame so when we start
    # adding sources, they will go beneath these here widgets, instead of beside
    # them 
    my $multiFrame = $main->Frame()->pack( -fill => "x" );

    my $sourceOpsFrame = $multiFrame->TFrame(-label=>"Source Operations")
                                    ->pack( -pady => 10,
                                            -ipady => 5,
                                            -padx => 10,
                                            -expand => 1,
                                            -anchor => "w",
                                            -side => "left" );
    $addSrcButton = $sourceOpsFrame->Button( -text => "Add source", 
                                             -command=>sub{doNewSource($newSourceType);} )
                                      ->pack( -padx => 10,
                                              -side =>"left" );
    $srcTypeMenu = $sourceOpsFrame->Optionmenu( -options => $newSourceTypeList,
                                                -variable => \$newSourceType )
                                     ->pack( -padx => 15,
                                             -side => "left");

    $exitButton = $multiFrame->Button( -text => "Exit", 
                                       -command => sub { doExit(); } )
                                ->pack( -padx => 10,
                                        -ipady => 5,
                                        -side => "right");
    $plotButton = $multiFrame->Button( -text => "Plot", 
                                       -command => sub { doPlot(); } )
                                ->pack( -padx => 10,
                                        -ipady => 5,
                                        -side => "right");
    $saveButton = $multiFrame->Button( -text => "Save", 
                                       -command => sub { doSave( "Save" ); } )
                                ->pack( -padx => 10,
                                        -ipady => 5,
                                        -side => "right");
    $exportButton = $multiFrame->Button( -text => "Export" )
                               ->pack( -padx => 10,
                                       -ipady => 5,
                                       -side => "right");
    $exportButton->bind( "<Button-1>", sub { doExport( "Export" ); } );
    $exportButton->bind( "<Control-Button-1>", sub { doExport( "Export", "ttyOut" ); } );

    # for balloon help
    $mainBalloon = $main->Balloon();
    $sourceListBalloon = $sourceListWindow->Balloon();
    setBalloonHelp( "initial" );

    createOptionsWindow();
    createHelpWindow();
    createAboutWindow();

    # catch ^C
    $SIG{'INT'} = \&doExit;

    # make icon
    if( -r $iconBitmap ) {
        $main->iconbitmap( "\@$iconBitmap" )
    }
}

# create "about" window
sub createAboutWindow {
my $msg = 
"BitGen $BitGen_Version 
by Toby Schaffer (toby_schaffer\@ieee.org)

BitGen is a program for converting digital
bitstreams to analog voltage sources suitable for
circuit simulation in programs such as SPICE.
Select the \"Help->Help...\" menu entry for usage
instructions and examples.

Please let me know if you have any suggestions,
comments, or questions!";

    $aboutWin = $main->Toplevel();
    $aboutWin->configure( -title => "About BitGen" );
    $aboutWin->protocol( "WM_DELETE_WINDOW", sub {$aboutWin->withdraw();} );
my  $text = $aboutWin->Scrolled( "Text",
                                 -height => 30,
                                 -width => 55,
                                 -scrollbars => "e" )
                     ->pack( -expand => 1,
                             -fill => "both" );
    $text->insert( "0.0", $msg );
    $text->configure( -state => "disabled" );
    $aboutWin->Button( -pady => 10,
                       -text => "Ok",
                       -command => sub{ $aboutWin->withdraw(); } )
             ->pack( -side => "bottom" );

    $aboutWin->withdraw();
}

# create help window
sub createHelpWindow {
my $msg = 
'-----------------------
Adding a Voltage Source
-----------------------
There are two methods to add a new source:

- Select the desired type in the source type pop-up menu and click
"Add source" or hit ctrl-a.
- Click the "Duplicate source" button of an existing source to make a
copy of that source. 

*Shortcut*: if you hold the control key while clicking the "Duplicate
source" button, the new source is the *inverse* of the original. For a
"single" source, all bits are inverted. For a "clock", the new source
is 180 degrees out-of-phase. This shortcut has no effect for "bus" or
"DC" sources.

-----------------------
Voltage Source Types
-----------------------
BitGen understands four different digital source types: single, bus,
clock and DC. "Single" is one bit. "Bus" is a vector of bits with a
common name and a numeric suffix, e.g., "data<3:0>". "Clock" is a
single periodic bit with a user-defined duty cycle. "DC" is a DC
(time-invariant) voltage. (See the end of this help for examples of
data patterns.) "Single" and "bus" waveforms are exported as piecewise
linear (PWL) sources, and "clock" waveforms are exported as pulse
sources.

----------------------
The Source List Window
----------------------
When a source is added the source list window is updated with a button
for the new source. Clicking the button scrolls the main window to
make the corresponding source visible. The button in the source list
window uses the text in the source\'s "Description" field as a label,
which is dynamically updated. If the "Description" field is empty, the
source type ("single", "bus", "clock", or "dc" ) is used instead.

If the source list window is unmapped when a source is added, it is
unmapped if the "Settings->Show source list" menu item is selected.

----------------------
Source Characteristics
----------------------
Associated with each source type is a:

    description (optional, saved as a comment in the netlist)
    source name (defines the name of the source in the netlist)
    vector (defines the bus name and components for bus sources)
    + node (defines the positive node; the source name is used if this
            field is left blank)
    - node (defines the negative node)

Additionally, there is a checkbutton which controls whether or not the
source is exported or plotted when those actions occur.

See the "Data Examples" section below for examples of the data field
format.

Waveform characteristics of the single and bus sources are:

    rt (rise time)		Time in seconds for 0-100% transition
    ft (fall time)		Time in seconds for 100%-0 transition
    pw (pulse width)		Width in seconds of a "pulse" (a 0 or 1)
				(includes rt/ft)
    on (on voltage)		Voltage in volts for a logic 1
    off (off voltage)		Voltage in volts for a logic 0
    delay (initial delay)	Time in seconds before waveform begins
    data (digital bitstream to be converted to analog voltage sources)

You can also specify an initial value (0, 1 or X) for a single source.
This can be useful to create an inital ramp that does not have a full
bit duration.

Waveform characteristics of the clock source are:

    rt (rise time)		Time, in seconds or as a percentage of the 
				period, for 0-100% transition
    ft (fall time)		Time, in seconds or as a percentage of the
				period, for 100%-0 transition
    freq (frequency)		Frequency in hertz
    duty cycle			Ratio of high/low time
    on (on voltage)		Voltage in volts for a logic 1
    off (off voltage)		Voltage in volts for a logic 0
    delay (initial delay)	Time in seconds before waveform begins

Characteristics of the DC source are:

    DC				Voltage in volts

Numeric input can be in scientific notation (eg, 10e6, 5e-9) or can use
standard suffixes (eg, 10u, 5.5n) (NOTE: use "m" for milli-, "meg" for
mega-.) 

The characteristics rt, ft, pw, on, off and delay can be assigned
text strings as well as numeric values. Using HSPICE\'s ".param"
statement, you then assign values to those strings in your
netlist.

Click the "Reset source" button to reset the source values to their
defaults. You can change the default values through the
"Settings->Source defaults..." menu entry.

-------------------
Exporting a Netlist
-------------------
To export a netlist, first select the desired netlist format from the
"Settings->Netlist format" menu entry, then either click "Export" or
select the "File->Export" menu entry. The available netlist formats
are:

    CDS             (for spectreS/hspiceS inside Analog Artist or Cadence cdsspice)
    SPICE           (for HSPICE and other SPICE variants)
    Spectre         (for Cadence Spectre)
    2-Column        (time/voltage pairs)

If you control-click the Export button, the netlist will be
written to stdout (i.e., the terminal window), otherwise you will
be prompted for a file name if you have not previously exported
a netlist.

BitGen does fairly little error-checking, so if you get unexpected
output, double-check the input.

---------------------
Plotting Waveforms
---------------------
All waveforms are extended out in time to be of equal duration for
plotting purposes. A source must be exportable to be plotted, since
the purpose of the plot is to indicate what you get when you export
a netlist.

---------------------
Handling BitGen Files
---------------------
BitGen files are saved by clicking "Save" or selecting the
"File->Save" menu entry. BitGen files are opened by selecting the
"File->Open" menu entry or hitting ctrl-o. You can also specify a
filename as a command-line argument when invoking BitGen.

-------------
Data Examples
-------------
Below are some examples of the "Data" field.

* Four different ways to make three 0110 nibbles in a "single" source:

    011001100110		enumerated 0\'s and 1\'s
    0110 0110 0110		whitespace is ok
    3(0 2(1) 0)			repeat factor, can be nested
    3(0x6)			"0x" signifies hex format

* Note that before a repeat factor whitespace is significant:

    1 2(1)			three 1\'s
    12(1)			twelve 1\'s

* Two ways to assign a "marching one" pattern to a four-bit bus, MSB
  high first:

    1000 0100 0010 0001		group bus bits together in binary
    0x8 0x4 0x2 0x1		or in hex
';

    $helpWin = $main->Toplevel();
    $helpWin->configure( -title => "BitGen Help" );
    $helpWin->protocol( "WM_DELETE_WINDOW", sub { $helpWin->withdraw(); } );
my  $text = $helpWin->Scrolled( "Text",
                                -height => 35,
                                -width => 75,
                                -scrollbars => "e" )
                    ->pack( -expand => 1,
                            -fill => "both" );
    $text->insert( "0.0", $msg );
    $text->configure( -state => "disabled" );
    $helpWin->Button( -pady => 10,
                      -text => "Ok",
                      -command => sub { $helpWin->withdraw(); } )
            ->pack( -side => "bottom" );

    $helpWin->withdraw();
}

sub closeOptionsWin {
    my( $mode ) = @_;
    my $tmp;

    if( $mode eq "ok" or $mode eq "apply" ) {
        $tmp = $rtDefaultEntry->get();
        $RT_DEFAULT = $tmp unless $tmp =~ /^\s*$/;

        $tmp = $ftDefaultEntry->get();
        $FT_DEFAULT = $tmp unless $tmp =~ /^\s*$/;         

        $tmp = $rtClkDefaultEntry->get();
        $RT_DEFAULT_CLK = $tmp unless $tmp =~ /^\s*$/;

        $tmp = $ftClkDefaultEntry->get();
        $FT_DEFAULT_CLK = $tmp unless $tmp =~ /^\s*$/;         

        $tmp = $pwDefaultEntry->get();
        $PW_DEFAULT = $tmp unless $tmp =~ /^\s*$/;

        $tmp = $onDefaultEntry->get();
        $ON_DEFAULT = $tmp unless $tmp =~ /^\s*$/;

        $tmp = $offDefaultEntry->get();
        $OFF_DEFAULT = $tmp unless $tmp =~ /^\s*$/;

        $tmp = $delayDefaultEntry->get();
        $DELAY_DEFAULT = $tmp unless $tmp =~ /^\s*$/;

        $tmp = $negnodeDefaultEntry->get();
        $NEGNODE_DEFAULT = $tmp unless $tmp =~ /^\s*$/;

        $tmp = $freqDefaultEntry->get();
        $FREQ_DEFAULT = $tmp unless $tmp =~ /^\s*$/;

        $tmp = $dutycycleDefaultEntry->get();
        $DUTYCYCLE_DEFAULT = $tmp unless $tmp =~ /^\s*$/;

        $tmp = $dcDefaultEntry->get();
        $DC_DEFAULT = $tmp unless $tmp =~ /^\s*$/;
    }
    elsif( $mode eq "cancel" ) {
        setEntryString( $rtDefaultEntry, $RT_DEFAULT );
        setEntryString( $ftDefaultEntry, $FT_DEFAULT );
        setEntryString( $rtClkDefaultEntry, $RT_DEFAULT_CLK );
        setEntryString( $ftClkDefaultEntry, $FT_DEFAULT_CLK );
        setEntryString( $pwDefaultEntry, $PW_DEFAULT );
        setEntryString( $onDefaultEntry, $ON_DEFAULT );
        setEntryString( $offDefaultEntry, $OFF_DEFAULT );
        setEntryString( $delayDefaultEntry, $DELAY_DEFAULT );
        setEntryString( $negnodeDefaultEntry, $NEGNODE_DEFAULT );
        setEntryString( $freqDefaultEntry, $FREQ_DEFAULT );
        setEntryString( $dutycycleDefaultEntry, $DUTYCYCLE_DEFAULT );
        setEntryString( $dcDefaultEntry, $DC_DEFAULT );
    }

    unless( $mode eq "apply" ) {
        $optionsWin->withdraw();
    }
}

# create and show options window
sub createOptionsWindow {
    $optionsWin = $main->Toplevel();
    $optionsWin->configure( -title => "Source Defaults" );
    $optionsWin->transient( $main );
    $optionsWin->protocol( "WM_DELETE_WINDOW", [\&closeOptionsWin, "cancel"] );

my $defaultsFrame = $optionsWin->Frame()
                               ->pack( -fill => "x",
                                        -padx => 5,
                                        -pady => 5 );
my $buttonsContainer = $optionsWin->Frame()->pack( -fill => "x" );

my $rtDefaultContainer = $defaultsFrame->Frame()->pack( -fill => "x" );
my $ftDefaultContainer = $defaultsFrame->Frame()->pack( -fill => "x" );
my $rtClkDefaultContainer = $defaultsFrame->Frame()->pack( -fill => "x" );
my $ftClkDefaultContainer = $defaultsFrame->Frame()->pack( -fill => "x" );
my $pwDefaultContainer = $defaultsFrame->Frame()->pack( -fill => "x" );
my $onDefaultContainer = $defaultsFrame->Frame()->pack( -fill => "x" );
my $offDefaultContainer = $defaultsFrame->Frame()->pack( -fill => "x" );
my $freqDefaultContainer = $defaultsFrame->Frame()->pack( -fill => "x" );
my $delayDefaultContainer = $defaultsFrame->Frame()->pack( -fill => "x" );
my $negnodeDefaultContainer = $defaultsFrame->Frame()->pack( -fill => "x" );
my $dutycycleDefaultContainer= $defaultsFrame->Frame()->pack( -fill => "x" );
my $dcDefaultContainer= $defaultsFrame->Frame()->pack( -fill => "x" );

my $rtDefaultLabel = $rtDefaultContainer->Label( -text => "Rise time (s)" )
                                        ->pack( -padx => 2, 
                                                -pady => 2, 
                                                -side => "left" );
    $rtDefaultEntry = $rtDefaultContainer->Entry( -highlightthickness => 0,
                                                 -width => 6 )
                                        ->pack(  -padx => 2,
                                                 -pady => 2, 
                                                 -side => "right" );

my $ftDefaultLabel = $ftDefaultContainer->Label( -text => "Fall time (s)" )
                                        ->pack(  -padx => 2, 
                                                 -pady => 2, 
                                                 -side => "left" );
   $ftDefaultEntry = $ftDefaultContainer->Entry( -highlightthickness => 0,
                                                 -width => 6 )
                                        ->pack(  -padx => 2,
                                                 -pady => 2, 
                                                 -side => "right" );

my $rtClkDefaultLabel = $rtClkDefaultContainer->Label( -text => "Clock rise time" )
                                              ->pack( -padx => 2, 
                                                      -pady => 2, 
                                                      -side => "left" );
   $rtClkDefaultEntry = $rtClkDefaultContainer->Entry( -highlightthickness => 0,
                                                 -width => 6 )
                                              ->pack( -padx => 2,
                                                      -pady => 2, 
                                                      -side => "right" );

my $ftClkDefaultLabel = $ftClkDefaultContainer->Label( -text => "Clock fall time" )
                                              ->pack( -padx => 2, 
                                                      -pady => 2, 
                                                      -side => "left" );
   $ftClkDefaultEntry = $ftClkDefaultContainer->Entry( -highlightthickness => 0,
                                                       -width => 6 )
                                              ->pack(  -padx => 2,
                                                       -pady => 2, 
                                                       -side => "right" );

my $pwDefaultLabel = $pwDefaultContainer->Label( -text => "Pulse width (s)" )
                                        ->pack( -padx => 2, 
                                                -pady => 2, 
                                                -side => "left" );
   $pwDefaultEntry = $pwDefaultContainer->Entry( -highlightthickness => 0,
                                                 -width => 6 )
                                        ->pack( -padx => 2,
                                                -pady => 2, 
                                                -side => "right" );

my $onDefaultLabel = $onDefaultContainer->Label( -text => "On voltage (V)" )
                                        ->pack( -padx => 2, 
                                                -pady => 2, 
                                                -side => "left" );
   $onDefaultEntry = $onDefaultContainer->Entry( -highlightthickness => 0,
                                                 -width => 6 )
                                        ->pack( -padx => 2,
                                                -pady => 2, 
                                                -side => "right" );

my $offDefaultLabel = $offDefaultContainer->Label( -text => "Off voltage (V)" )
                                          ->pack( -padx => 2, 
                                                  -pady => 2, 
                                                  -side => "left" );
   $offDefaultEntry = $offDefaultContainer->Entry( -highlightthickness => 0,
                                                   -width => 6 )
                                          ->pack( -padx => 2,
                                                  -pady => 2, 
                                                  -side => "right" );

my $delayDefaultLabel = $delayDefaultContainer->Label( -text => "Initial delay (sec)" )
                                              ->pack( -padx => 2, 
                                                      -pady => 2, 
                                                      -side => "left" );
   $delayDefaultEntry = $delayDefaultContainer->Entry( -highlightthickness => 0,
                                                       -width => 6 )
                                              ->pack( -padx => 2,
                                                      -pady => 2, 
                                                      -side => "right" );

my $negnodeDefaultLabel = $negnodeDefaultContainer->Label( -text => "Negnode name" )
                                                  ->pack( -padx => 2, 
                                                          -pady => 2, 
                                                          -side => "left" );
   $negnodeDefaultEntry = $negnodeDefaultContainer->Entry( -highlightthickness => 0,
                                                          -width => 6 )
                                                   ->pack( -padx => 2,
                                                           -pady => 2, 
                                                           -side => "right" );

my $freqDefaultLabel = $freqDefaultContainer->Label( -text => "Frequency (Hz)" )
                                            ->pack( -padx => 2, 
                                                    -pady => 2, 
                                                    -side => "left" );
   $freqDefaultEntry = $freqDefaultContainer->Entry( -highlightthickness => 0,
                                                     -width => 6 )
                                            ->pack( -padx => 2,
                                                    -pady => 2, 
                                                    -side => "right" );

my $dutycycleDefaultLabel = $dutycycleDefaultContainer->Label( -text => "Duty cycle" )
                                                      ->pack( -padx => 2, 
                                                              -pady => 2, 
                                                              -side => "left" );
   $dutycycleDefaultEntry = $dutycycleDefaultContainer->Entry( -highlightthickness => 0,
                                                               -width => 6 )
                                                      ->pack( -padx => 2,
                                                              -pady => 2, 
                                                              -side => "right" );

my $dcDefaultLabel = $dcDefaultContainer->Label( -text => "DC voltage (V)" )
                                        ->pack( -padx => 2, 
                                                -pady => 2, 
                                                -side => "left" );
   $dcDefaultEntry = $dcDefaultContainer->Entry( -highlightthickness => 0,
                                                 -width => 6 )
                                        ->pack( -padx => 2,
                                                -pady => 2, 
                                                -side => "right" );

    setEntryString( $rtDefaultEntry, $RT_DEFAULT );
    setEntryString( $ftDefaultEntry, $FT_DEFAULT );
    setEntryString( $rtClkDefaultEntry, $RT_DEFAULT_CLK );
    setEntryString( $ftClkDefaultEntry, $FT_DEFAULT_CLK );
    setEntryString( $pwDefaultEntry, $PW_DEFAULT );
    setEntryString( $onDefaultEntry, $ON_DEFAULT );
    setEntryString( $offDefaultEntry, $OFF_DEFAULT );
    setEntryString( $delayDefaultEntry, $DELAY_DEFAULT );
    setEntryString( $negnodeDefaultEntry, $NEGNODE_DEFAULT );
    setEntryString( $freqDefaultEntry, $FREQ_DEFAULT );
    setEntryString( $dutycycleDefaultEntry, $DUTYCYCLE_DEFAULT );
    setEntryString( $dcDefaultEntry, $DC_DEFAULT );

    $buttonsContainer->Button( -text => "Ok", 
                               -command => sub { closeOptionsWin( "ok" ); } )
                     ->pack( -padx => 10,
                             -ipady => 5,
                             -side => "left" );
    $buttonsContainer->Button( -text => "Apply", 
                               -command => sub { closeOptionsWin( "apply" ); } )
                     ->pack( -padx => 10,
                             -ipady => 5,
                             -side => "left" );
    $buttonsContainer->Button( -text => "Cancel", 
                               -command => sub { closeOptionsWin( "cancel" ); } )
                     ->pack( -padx => 10,
                             -ipady => 5,
                             -side => "right" );

    $optionsWin->withdraw();
}

# show or hide source list window depending on...
sub showSourceListWindow{
    if( $showSourceList && $numSources > 0 ) {
        $sourceListWindow->deiconify();
    }

    if( $showSourceList == 0 || $numSources == 0 ) {
        $sourceListWindow->withdraw();
    }
}

# open native BitGen file
sub doOpen {
my $inFileName = $_[0];
my( $line, $name, $posNode, $negNode, $dataStream );
my( $rt, $ft, $on, $off, $delay, $initVal, $freq, $dutyCycle, $dc, $export );
my( $continue, $doneInitialDeletion, $comps, $sourceType, $desc );
my( $tmpCount );

    # when calling bitgen with filename to be opened, the filename gets passed
    # as an argument here. if no argument was passed here, get filename regular
    # ways.
    if( !defined( $inFileName ) ) {
        # pop up the browser
        $inFileName = $main->getOpenFile( -title => "Open BitGen File",
                                          -filetypes => $BitGen_Filetypes );
        if( !defined( $inFileName ) ) {
            return;
        }
    }

    unless( open( IN, $inFileName ) ) {
        doMessageBox( "File Error", "Can't open file \"$inFileName\"", "Error" );
        return;
    }
 
    # make sure it's a valid bitgen file!
    $_ = <IN>;
    unless( /^$BitGen_Signature/ ) {
        doMessageBox( "File Error", "File \"$inFileName\" isn't a BitGen file!", "Error" );
        return;
    }
    $line++;

    if( $needSaveFlag ) {
        my $save = doMessageBox( "Save needed", "Save current data before proceeding?", 
                                 "question", "YesNoCancel" );
        if( $save =~ /^y/i ) {
            close IN, return if doSave( "Save" ) < 0;
        }
        elsif( $save =~ /^c/i ) {
            close IN;
            return;
        }
    }

    $currentFilename = $inFileName;
    setMainWindowTitle();
    busyCursor( 1 );

    $doneInitialDeletion = 0;

    $tmpCount = 0 if $tty;

    while( <IN> ) {
        $line++;
        next if /(^\s*$|^\s*\*)/;

        # get (optional) description
        if( /^\s*#\s*(.+)$/ ) {
            $desc = $1;
            $_ = <IN>;
        }
        else {
            $desc = undef;
        }
        if( /^\s*bit\s+/ ) { 
            $sourceType = "single";
        }
        elsif( /^\s*bus\s+/ ) { 
            $sourceType = "bus";
        }
        elsif( /^\s*clock\s+/ ) { 
            $sourceType = "clock";
        }
        elsif( /^\s*dc\s+/ ) { 
            $sourceType = "dc";
        }
        else {
            $continue = doMessageBox( "Syntax error", 
                                "Syntax error, line $line. Continue reading input file?",
                                "question", "YesNo" );
            last if $continue =~ /^n/i;
            next;
        }
        if( $sourceType =~ /single/i ) {
            /^\s*bit
                \s+([\w-]+)         (?# source name)
                \s+([\w-!\\]+)      (?# pos node)    
                \s+([\w-!\\]+)      (?# neg node)    
                \s+{
                ([\s\d\(\)xa-f]+)   (?# datastream)
                }/xi;
            $name = $1;
            $posNode = $2;
            $negNode = $3;
            $dataStream = $4;
        }
        elsif( $sourceType =~ /bus/i ) {
            /^\s*bus
                \s+"([\w-!]+[\[<][:\d]+[\]>][\w-!]*)" (?# components; use [] or <>)
                \s+([\w-!\\]+)                 (?# neg node)    
                \s+{
                ([\s\d\(\)xa-f]+)              (?# datastream)
                }/xi;
            $comps = $1;
            $negNode = $2;
            $dataStream = $3;
        }
        elsif( $sourceType =~ /clock/i ) {
            /^\s*clock
                \s+([\w-]+)         (?# source name)
                \s+([\w-!\\]+)      (?# pos node)    
                \s+([\w-!\\]+)      (?# neg node)    
                /xi;
            $name = $1;
            $posNode = $2;
            $negNode = $3;
        }
        elsif( $sourceType =~ /dc/i ) {
            /^\s*dc
                \s+([\w-]+)         (?# source name)
                \s+([\w-!\\]+)      (?# pos node)    
                \s+([\w-!\\]+)      (?# neg node)    
                /xi;
            $name = $1;
            $posNode = $2;
            $negNode = $3;
        }
        unless( $doneInitialDeletion ) {
            foreach my $index (sort keys %descLabels) {
                # delete each source but don't resize main window
                # since we're just going to be opening more sources
                deleteSrc( $index, 0 );
            }
            $doneInitialDeletion = 1;
            $sourceNum = "0";
        }

        if( /\brt\s*=\s*([\w-\.\%]+)/ ) {
            $rt = $1;
        }
        else {
            $rt = $sourceType eq "clock" ? $RT_DEFAULT_CLK : $RT_DEFAULT;
        }
        if( /\bft\s*=\s*([\w-\.\%]+)/ ) {
            $ft = $1;
        }
        else {
            $ft = $sourceType eq "clock" ? $FT_DEFAULT_CLK : $FT_DEFAULT;
        }
        if( /\bpw\s*=\s*([\w-\.]+)/ ) {
            $pw = $1;
        }
        else {
            $pw = $PW_DEFAULT;
        }
        if( /\bfreq\s*=\s*([\w-\.]+)/ ) {
            $freq = $1;
        }
        else {
            $freq = $FREQ_DEFAULT;
        }
        if( /\bdutycycle\s*=\s*(\d+)%?/ ) {
            $dutyCycle = $1;
        }
        else {
            $dutyCycle = $DUTYCYCLE_DEFAULT;
        }
        if( /\bon\s*=\s*([\w-\.]+)/ ) {
            $on = $1;
        }
        else {
            $on = $ON_DEFAULT;
        }
        if( /\boff\s*=\s*([\w-\.]+)/ ) {
            $off = $1;
        }
        else {
            $off = $OFF_DEFAULT;
        }
        if( /\bdelay\s*=\s*([\w-\.]+)/ ) {
            $delay = $1;
        }
        else {
            $delay = $DELAY_DEFAULT;
        }
        if( /\binitval\s*=\s*([\w-\.]+)/ ) {
            $initVal = $1;
        }
        if( /\bdc\s*=\s*([\w-\.]+)/ ) {
            $dc = $1;
        }
        else {
            $dc = $DC_DEFAULT;
        }
        if( /\bexport\s*=\s*(\w+)/ ) {
            $export = $1;
        }
        else {
            $export = "on";
        }

        if( $tty ) {
            $sourceNum = "TTY";
            $sourceTypes{"TTY"} = $sourceType;
        }
        else {
            doNewSource( $sourceType, 1 );
        }

        assignElement( $desc, \$descEntries{$sourceNum} );
        assignElement( $negNode, \$negNodeEntries{$sourceNum} );
        if( $sourceType eq "single" or $sourceType eq "clock" or $sourceType eq "dc" ) {
            assignElement( $name, \$srcEntries{$sourceNum} );
            assignElement( $posNode, \$posNodeEntries{$sourceNum} );
        }
        elsif( $sourceType eq "bus" ) {
            assignElement( $comps, \$vecCompsEntries{$sourceNum} );
        }
        if( $sourceType eq "single" or $sourceType eq "bus" ) {
            assignElement( $dataStream, \$dataEntries{$sourceNum} );
            assignElement( $pw, \$pwEntries{$sourceNum} );
        }
        elsif( $sourceType eq "clock" ) {
            assignElement( $freq, \$freqEntries{$sourceNum} );
            assignElement( $dutyCycle, \$dutyCycleEntries{$sourceNum} );
        }
        if( $sourceType eq "dc" ) {
            assignElement( $dc, \$dcEntries{$sourceNum} );
        }
        elsif( $sourceType eq "single" or $sourceType eq "bus" or $sourceType eq "clock" ) {
            assignElement( $rt, \$rtEntries{$sourceNum} );
            assignElement( $ft, \$ftEntries{$sourceNum} );
            assignElement( $on, \$onEntries{$sourceNum} );
            assignElement( $off, \$offEntries{$sourceNum} );
            assignElement( $delay, \$delayEntries{$sourceNum} );
        }
        if( $sourceType eq "single" ) {
            assignElement( $initVal, \$initValEntries{$sourceNum} );
        }
        $isExportable{$sourceNum} = $export;

        # update source list buttons labels
        setSourceListButton( $sourceNum ) unless $tty;

        # if we're in tty mode, go ahead and export sources as they are read in
        $tmpCount++;
        if( $tty && $isExportable{"TTY"} ) {
            my $desc = $descEntries{"TTY"};
            my $fh = "STDOUT";
            print $fh "$commentChar{$netlistLang} $desc\n" if $desc;
            if( $sourceType =~ /single/i ) {
                doBitWave( "TTY", $tmpCount, $fh );
            }
            elsif( $sourceType =~ /bus/i ) {
                doBusWave( "TTY", $tmpCount, $fh );
            }
            elsif( $sourceType =~ /clock/i ) {
                doClockWave( "TTY", $tmpCount, $fh );
            }
            elsif( $sourceType =~ /dc/i ) {
                doDCWave( "TTY", $tmpCount, $fh );
            }
        }
    }

    close( IN );

    $needSaveFlag = 0;

    busyCursor( 0 );
}

sub assignElement {
my( $data, $element ) = @_;
    if( $tty ) {
        $$element = $data;
    }
    else {
        setEntryString( $$element, $data ); 
    }
}

sub busyCursor {
my( $busy ) = @_;

    return if $tty;

    if( $busy ) {
        $main->Busy;
    }
    else {
        $main->Unbusy;
    }
}

# save in native BitGen format
sub doSave {
my( $mode ) = @_;
my( $fileName, $fh, $source, $sourceType, $comps );
my( $desc, $name, $posNode, $negNode, $data );
my( $rt, $ft, $pw, $freq, $on, $off, $delay, $initVal, $dutyCycle, $dc, $export );
my( $rtDefault, $ftDefault );

    return 0 if $numSources == 0;

    if( !defined( $currentFilename ) or $mode eq "SaveAs" ) {
        $currentFilename = $main->getSaveFile( -title => "Save BitGen File",
                                               -filetypes => $BitGen_Filetypes );
        return -1 if !defined( $currentFilename );
    }

    $fh = getOutfileHandle( $currentFilename );

    return -2 if $fh eq "Error";

    setMainWindowTitle();

    print $fh "$BitGen_Signature\n";
    
    # since $sourceNum gets all screwed up when you start deleting sources,
    # just keep count here and use this count for any warning messages about
    # skipping sources.
    my $tmpCount = 0;

    foreach $source (sort keys %descLabels) {
        $tmpCount++;

        $sourceType = $sourceTypes{$source};

        unless( $sourceType =~ /^bus/i ) {
            $name = $srcEntries{$source}->get();
            if( $name =~ /^\s*$/ ) {
                doMessageBox( "Missing name", "Skipping source #$tmpCount: unnamed", "warning" );
                next;
            }
        }
        $negNode = $negNodeEntries{$source}->get();
        if( $negNode =~ /^\s*$/ ) {
            doMessageBox( "Missing node", "Skipping source #$tmpCount: no - node", "warning" );
            next;
        }
        if( $sourceType =~ /^single/i or $sourceType =~ /^bus/i ) {
            $data = $dataEntries{$source}->get();
            if( $data =~ /^\s*$/ ) {
                doMessageBox( "Missing data", "Skipping source #$tmpCount: empty datastream", "warning" );
                next;
            }
        }
        if( $sourceType =~ /^bus/i ) {
            $comps = $vecCompsEntries{$source}->get();
            if( $comps =~ /^\s*$/ ) {
                doMessageBox( "Missing components", 
                              "Skipping source #$source: no vector", "warning" );
                next;
            }
        }

        # use the source name for the pos node if they didn't enter one
        if( $sourceType =~ /^single/i or $sourceType =~ /^clock/i or $sourceType =~ /^dc/i ) {
            $posNode = $posNodeEntries{$source}->get();
            $posNode = $name if $posNode =~ /^\s*$/;
        }
        if( $sourceType =~ /^dc/i ) {
            $dc = $dcEntries{$source}->get();
            $dc = $DC_DEFAULT if $dc =~ /^\s*$/;
        }
        else {
            if( $sourceType =~ /^clock/i ) {
                $rtDefault = $RT_DEFAULT_CLK;
                $ftDefault = $FT_DEFAULT_CLK;
            }
            else {
                $rtDefault = $RT_DEFAULT;
                $ftDefault = $FT_DEFAULT;
            }
            $rt = $rtEntries{$source}->get();
            $rt = $rtDefault if $rt =~ /^\s*$/;
            $ft = $ftEntries{$source}->get();
            $ft = $ftDefault if $ft =~ /^\s*$/;
            if( $sourceType =~ /^clock/i ) {
                $freq = $freqEntries{$source}->get();
                $freq = $FREQ_DEFAULT if $freq =~ /^\s*$/;
                $dutyCycle = $dutyCycleEntries{$source}->get();
                $dutyCycle = $DUTYCYCLE_DEFAULT if $dutyCycle =~ /^\s*$/;
            }
            else {
                $pw = $pwEntries{$source}->get();
                $pw = $PW_DEFAULT if $pw =~ /^\s*$/;
            }
            $on = $onEntries{$source}->get();
            $on = $ON_DEFAULT if $on =~ /^\s*$/;
            $off = $offEntries{$source}->get();
            $off = $OFF_DEFAULT if $off =~ /^\s*$/;
            $delay = $delayEntries{$source}->get();
            $delay = $DELAY_DEFAULT if $delay =~ /^\s*$/;
            if( $sourceType =~ /^single/i ) {
                $initVal = $initValEntries{$source}->get();
            }
        }
        $export = $isExportable{$source};

        $desc = $descEntries{$source}->get();
        print $fh "# $desc\n" if $desc;
        if( $sourceType =~ /^single/i ) {
            printf $fh "bit %s %s %s {%s} rt=%s ft=%s pw=%s on=%s off=%s delay=%s initval=%s export=%s\n",
                        $name, $posNode, $negNode, $data, $rt, $ft, $pw, $on, $off, $delay, $initVal, $export;
        }
        elsif( $sourceType =~ /^bus/i ) {
            printf $fh "bus \"%s\" %s {%s} rt=%s ft=%s pw=%s on=%s off=%s delay=%s export=%s\n",
                        $comps, $negNode, $data, $rt, $ft, $pw, $on, $off, $delay, $export;
        }
        elsif( $sourceType =~ /^clock/i ) {
            printf $fh "clock %s %s %s rt=%s ft=%s freq=%s dutycycle=%s on=%s off=%s delay=%s export=%s\n",
                        $name, $posNode, $negNode, $rt, $ft, $freq, $dutyCycle, $on, $off, $delay, $export;
        }
        elsif( $sourceType =~ /^dc/i ) {
            printf $fh "dc %s %s %s dc=%s export=%s\n", $name, $posNode, $negNode, $dc, $export;
        }
    }

    $needSaveFlag = 0;

    close( $fh ) if $fh eq "OUT";

    return 0;
}

sub getOutfileHandle {
my( $outFileName ) = @_;

    # print to stdout if there's no file name specified
    if( $outFileName eq "" or $outFileName =~ /^\s*$/ ) {
        return( "STDOUT" );
    }
    else {
        unless( open( OUT, ">$outFileName" ) ) {
            doMessageBox( "Write Error", "Can't write to \"$outFileName\"!",
                          "Error", "OK" );
            return( "Error" );
        }
        return( "OUT" );
    }
}

# export netlist
sub doExport {
my( $mode, $ttyOut ) = @_;
my( $source, $fh, $desc );
my $types = [ ['CDS',      '.cds' ],
              ['SPICE',    ['.sp', '.hsp'] ],
              ['Spectre',  '.spectre' ],
              ['2-column', '.2col' ],
              ['All Files',    '*' ] ];

    return 0 if $numSources == 0;

    if( !$ttyOut ) {
        if( !defined( $currentNetlistname ) or $mode eq "ExportAs" ) {
            $currentNetlistname = $main->getSaveFile( -title => "Export Netlist",
                                                      -filetypes => $types );
            return -1 if !defined( $currentNetlistname );
        }

        $fh = getOutfileHandle( $currentNetlistname );

        return -2 if $fh eq "Error";

        setMainWindowTitle();
    }
    else {
        $fh = "STDOUT";
    }

    # since $sourceNum gets all screwed up when you start deleting sources,
    # just keep count here and use this count for any warning messages about
    # skipping sources.
    my $tmpCount = 0;

    foreach $source (sort keys %descLabels) {
       $tmpCount++;

       next if $isExportable{$source} =~ /^off/;
        
       $desc = $descEntries{$source}->get();
        print $fh "$commentChar{$netlistLang} $desc\n" if $desc;
        if( $sourceTypes{$source} =~ /single/i ) {
            doBitWave( $source, $tmpCount, $fh );
        }
        elsif( $sourceTypes{$source} =~ /bus/i ) {
            doBusWave( $source, $tmpCount, $fh );
        }
        elsif( $sourceTypes{$source} =~ /clock/i ) {
            doClockWave( $source, $tmpCount, $fh );
        }
        elsif( $sourceTypes{$source} =~ /dc/i ) {
            doDCWave( $source, $tmpCount, $fh );
        }
    }

    close( $fh ) if $fh eq "OUT";

    return 0;
}

sub doDCWave
{
my( $source, $tmpCount, $OUT ) = @_;
my( $name, $res, $pattern, $period, $highTime, $posNode, $negNode );

    $name = get( $srcEntries{$source} );
    if( $name =~ /^\s*$/ ) {
        doMessageBox( "Missing name", "Skipping source #$tmpCount: unnamed", "warning" );
        return -1;
    }
    
    if( get( $negNodeEntries{$source} ) =~ /^\s*$/ ) {
        doMessageBox( "Missing node", "Skipping source #$tmpCount: no - node", "warning" );
        return -1;
    }

    $res = getParameters( $source, "dc" );
    if( $res != 0 ) {
        doMessageBox( "Syntax Error", "Source #$tmpCount: " . $res, "Error" );
        return -1;
    }

    $posNode = get( $posNodeEntries{$source} );
    # use the source name for the pos node if they didn't enter one
    $posNode = $name if( $posNode =~ /^\s*$/ );
    $negNode = get( $negNodeEntries{$source} );
    if( $netlistLang eq "SPICE" or $netlistLang eq "CDS" ) {
        if( $makePlotFile ) {
            my $plotStr = makeSigviewHeader( $name );
            $plotStr .= "0 0\n  " . $dc . "\n1 MAXTIME\n  " . $dc . "\n";
            $plotStr =~ s/XXX/2/;
            $sigviewData[$sigDataCount++] = $plotStr;
        }
        else {
            print $OUT "V$name $posNode $negNode DC $dc\n";
        }
    }
    elsif( $netlistLang eq "Spectre" ) {
        print $OUT "V$name $posNode $negNode vsource type=dc dc=$dc\n";
    }

    return 0;
}

sub doClockWave
{
my( $source, $tmpCount, $OUT ) = @_;
my( $name, $res, $pattern, $period, $highTime, $posNode, $negNode );

    $name = get( $srcEntries{$source} );
    if( $name =~ /^\s*$/ ) {
        doMessageBox( "Missing name", "Skipping source #$tmpCount: unnamed", "warning" );
        return -1;
    }
    
    if( get( $negNodeEntries{$source} ) =~ /^\s*$/ ) {
        doMessageBox( "Missing node", "Skipping source #$tmpCount: no - node", "warning" );
        return -1;
    }

    $res = getParameters( $source, "clock" );
    if( $res != 0 ) {
        doMessageBox( "Syntax Error", "Source #$tmpCount: " . $res, "Error" );
        return -1;
    }

    # rudimentary error checking
    if( $freq <= 0 ) {
        doMessageBox( "Illegal parameter value", 
                      "Skipping source #$tmpCount: frequency must be positive", "warning" );
        return -1;
    }
    if( $dutyCycle <= 0 or $dutyCycle >= 100 ) {
        doMessageBox( "Illegal parameter value", 
                      "Skipping source #$tmpCount: duty cycle must be between 0-100", "warning" );
        return -1;
    }
    $dutyCycle /= 100;

    # "2-Column" format doesn't make much sense with a clock source,
    # since we don't know how long to make it run (of course, we could
    # find out, but it's not worth the effort; also, in Composer, it's
    # just as easy to use a pulse source as it is to use a pwlf)
    if( $netlistLang eq "2-Column" ) {
        doMessageBox( "Illegal netlist format", 
                      "Skipping source #$tmpCount: clock source not supported in 2-Column format", "warning" );
        return -1;
    }

    $period = 1 / $freq;
    $highTime = ($dutyCycle * $period) - $rt;
    if( $highTime <= 0 ) {
        doMessageBox( "Illegal parameter values", 
                      "Skipping source #$tmpCount: duty cycle, freq and rt result in negative pulse width", "warning" );
        return -1;
    }

    $posNode = get( $posNodeEntries{$source} );
    # use the source name for the pos node if they didn't enter one
    $posNode = $name if( $posNode =~ /^\s*$/ );
    $negNode = get( $negNodeEntries{$source} );
    # take care of plotting clocks in doPlot() instead of here so we can know what $maxTime is
    # i.e., so we know for how long to plot the clock
    if( $makePlotFile ) {
        $sigviewData[$sigDataCount++] = "clock"." ".$off." ".$on." ".$delay." ".$rt." ".$ft." ".$highTime." ".$period;
    }
    else {
        if( $netlistLang eq "SPICE" or $netlistLang eq "CDS" ) {
            print $OUT "V$name $posNode $negNode pulse(";
            print $OUT "$off $on $delay $rt $ft $highTime $period )\n";
        }
        elsif( $netlistLang eq "Spectre" ) {
            print $OUT "V$name $posNode $negNode vsource type=pulse ";
            print $OUT "val0=$off val1=$on delay=$delay rise=$rt fall=$ft width=$highTime period=$period\n";
        }
    }

    return 0;
}

sub doBusWave
{
my( $source, $tmpCount, $OUT ) = @_;
my( $name1, $name2, $start, $stop, $incr, $data, $res );
my( $pattern, $key, $components, $idx, %bitStreams );

    $pattern = get( $dataEntries{$source} );
    $components = get( $vecCompsEntries{$source} );

    if( $pattern =~ /^\s*$/ ) {
        doMessageBox( "Missing data", "Skipping source #$tmpCount: empty datastream", "warning" );
        return -1;
    }
    if( get( $negNodeEntries{$source} ) =~ /^\s*$/ ) {
        doMessageBox( "Missing node", "Skipping source #$tmpCount: no - node", "warning" );
        return -1;
    }
    if( $components =~ /^\s*$/ ) {
        doMessageBox( "Missing components", "Skipping source #$tmpCount: no components", "warning" );
        return -1;
    }

    # expand <start:stop:incr> notation
    if( $components =~ /(\w+)           (?# name)
                        [<\[](\d+):     (?# start index)
                             (\d+)      (?# stop index)
                             :?(\d*)    (?# increment, optional)
                        [>\]](\w*)/x ) {
        # if name is of form x[a:b]y, $name1="x" $name2="y"
        $name1 = $1;
        $name2 = $5;
        $start = $2;
        $stop = $3;
        $incr = $4;
        $incr = 1 if !$incr;
        
        $components = "";
        if( $start > $stop ) {
            # descending
            for( $idx=$start; $idx>=$stop; $idx -= $incr ) {
                $components .= $name1 . $idx . $name2 . " ";
            }
        }
        else {
            # ascending
            for( $idx=$start; $idx<=$stop; $idx += $incr ) {
                $components .= $name1 . $idx . $name2 . " ";
            }
        }
    }

    # expand multiplied patterns
    while( $pattern =~ /\s*((\d+)                (?# $2, the multiplier)
                           \(\s*([a-fx\d ]+)\)   (?# $3, vec to be multiplied)
                           )\s*/ix ) {
        substr($pattern, index($pattern, $1), length($1)) = join("", " ", ($3 . " ") x $2, " " );
    }

    $pattern =~ s/^\s+//;
    foreach my $datum (split( /\s+/, $pattern )) {
        if( $datum =~ /^0x/ ) {
            # hex string
            $datum = oct( $datum );
        }
        else {
            # string of 1's and 0's
            # pad w/0's to make sure we have an integral # of bytes
            $datum = "0" . $datum while( length( $datum ) % 8 != 0 );
            $datum = oct( "0x" . unpack( "H*", pack( "B*", $datum ) ) );
        }
        # - for each signal "name" in the vector, update the 
        #   corresponding bitStream array
        # - reverse() is needed so the vector components are assigned
        #   in the order in which they were defined
        foreach my $comp (reverse split( /[\s,;]+/, $components )) {
            $bitStreams{$comp} .= ($datum & 1) ? "1" : "0";
            $datum >>= 1;   
        }
    }

    $res = getParameters( $source, "bus" );
    if( $res != 0 ) {
        doMessageBox( "Syntax Error", "Source #$tmpCount: " . $res, "Error" );
        return -1;
    }

    # rudimentary error checking
    # if( $rt > $pw or $ft > $pw ) {
        # doMessageBox( "Illegal parameter value", 
                      # "Skipping source #$tmpCount: rt/ft must be <= pw", "warning" );
        # return;
    # }
    # sort the keys so voltage sources are printed in order
    foreach $key (sort keys %bitStreams) {
        printBitWave( $key, $bitStreams{$key}, $source, $OUT );
    }

    return 0;
}

sub get {
my( $element ) = @_;

    if( $tty ) {
        return $element;
    }
    else {
        return $element->get();
    }
}

sub doBitWave { 
my( $source, $tmpCount, $OUT) = @_;
my( $name, $pattern, $bits, $res );

    $name = get( $srcEntries{$source} );
    if( $name =~ /^\s*$/ ) {
        doMessageBox( "Missing name", "Skipping source #$tmpCount: unnamed", "warning" );
        return -1;
    }
    
    $pattern = get( $dataEntries{$source} );
    if( $pattern =~ /^\s*$/ ) {
        doMessageBox( "Missing data", "Skipping source #$tmpCount: empty datastream", "warning" );
        return -1;
    }
    
    if( get($negNodeEntries{$source}) =~ /^\s*$/ ) {
        doMessageBox( "Missing node", "Skipping source #$tmpCount: no - node", "warning" );
        return -1;
    }

    # expand hex numbers
    $pattern = expandDataStream( $pattern );
    if( $pattern =~ /[^01]/ ) {
        doMessageBox( "Error", "Illegal character in datastream #$tmpCount", "Error" );
        return -1;
    }

    $res = getParameters( $source, "single" );
    if( $res != 0 ) {
        doMessageBox( "Syntax Error", "Source #$tmpCount: " . $res, "Error" );
        return -1;
    }

    # rudimentary error checking
    # if( $rt > $pw or $ft > $pw ) {
        # doMessageBox( "Illegal parameter value", 
                      # "Skipping source #$tmpCount: rt/ft must be <= pw", "warning" );
        # return;
    # }

    # now, binary vector is in $pattern
    printBitWave( $name, $pattern, $source, $OUT );

    return 0;
}

sub doPlot() {
    my $count = 0;
    my $plottableSourceFlag = 0;

    return if $numSources == 0;

    unless( open( SIGVIEWFILE, ">$plotFile" ) ) {
        doMessageBox( "File Error", "Can't open file \"$plotFile\"", "Error" );
        return;
    }

    $makePlotFile = 1;

    foreach my $source (sort keys %descLabels) {
       $count++;

       next if $isExportable{$source} =~ /^off/;
        
       if( $sourceTypes{$source} =~ /single/i ) {
            unless( doBitWave( $source, $count, 0 ) < 0 ) {
               $plottableSourceFlag++;
            }
       }
       elsif( $sourceTypes{$source} =~ /bus/i ) {
            unless( doBusWave( $source, $count, 0 ) < 0 ) {
                $plottableSourceFlag++;
            }
       }
       elsif( $sourceTypes{$source} =~ /clock/i ) {
           unless( doClockWave( $source, $count, 0 ) < 0 ) {
                $plottableSourceFlag++;
           }
       }
       elsif( $sourceTypes{$source} =~ /dc/i ) {
           unless( doDCWave( $source, $count, 0 ) < 0 ) {
                $plottableSourceFlag++;
           }
       }
    }

    unless( $plottableSourceFlag ) {
        doMessageBox( "Plot", "No plottable sources found", "warning" );
        return;
    }

    # make sure each signal extends as far as $maxTime
    foreach my $sig (@sigviewData) {
        if( $sig =~ /^clock/ ) {
            $sig =~ s/^clock\s*//;
            my $dataPtCount = 1;
            my ($off,$on,$delay,$rt,$ft,$highTime,$period) = split( /\s+/, $sig);
            my $lowTime = $period - $highTime - $rt - $ft;
            my $numPeriods = ($maxTime - $delay) / $period;
            $sig = makeSigviewHeader( "clock" );
            $sig .= "0 0\n  $off\n";
            for( my $i=0; $i<$numPeriods; $i++ ) {
                my $t = eval "$delay + $lowTime + $period*$i";
                $sig .= "$dataPtCount $t\n  $off\n";
                $dataPtCount++;
                $t = eval "$delay + ($lowTime + $rt) + $period*$i";
                $sig .= "$dataPtCount $t\n  $on\n";
                $dataPtCount++;
                $t = eval "$delay + ($lowTime + $rt + $highTime) + $period*$i";
                $sig .= "$dataPtCount $t\n  $on\n";
                $dataPtCount++;
                $t = eval "$delay + ($lowTime + $rt + $highTime + $ft) + $period*$i";
                $sig .= "$dataPtCount $t\n  $off\n";
                $dataPtCount++;
            }
            $sig =~ s/XXX/$dataPtCount/;
        }

        $sig =~ s/MAXTIME/$maxTime/;
        print SIGVIEWFILE $sig;
    }

    my $pid = fork();
    if( defined( $pid ) && $pid == 0 ) {
        # child
        # when running in rxvt, sigview spews out some bizarro escape sequences
        # so send those to the bit bucket
        open STDOUT, ">/dev/null";
        open STDERR, ">/dev/null";
        exec "$sigviewCommand $plotFile";
        doMessageBox( "Exec Error", "Exec failed ($!) - exiting", "Error" );
        exit 0;
    }

    $makePlotFile = 0;
    $sigDataCount = 0;
    $maxTime = 0;
    @sigviewData = undef;
    close SIGVIEWFILE;
}

sub makeSigviewHeader
{
    my( $name ) = @_;
    my @info = getpwuid $<;

    my $plotStr = "Title: Voltage source $name by BitGen\n";
    $plotStr .= "Date: " . scalar( localtime ) . "\n";
    $plotStr .= "Name: " . shift( @info ) . "\n";
    $plotStr .= "Flags:\n";
    $plotStr .= "No. Variables: 2\n";
    $plotStr .= "No. Points: XXX\n";
    $plotStr .= "Command\nVariables:\n  0 time time\n  1 $name voltage\n";
    $plotStr .= "Values:\n";

    return $plotStr;
}

sub isNumber
{
    my $str = $_[0];

    if( $str =~ /^(-?\d+\.?\d*(e[+-]?\d+)?)([afpnumkxgt]?)$/ ) {
        if( defined( $suffixes{$3} )) {
            return( $1 * $suffixes{$3} );
        }
        else {
            return( $1 );
        }
    }
    else {
        return( -1 );
    }
}

sub printBitWave
{
    my( $name, $pattern, $source, $OUT ) = @_;
    my( $pwCount, $count, $posNode, $negNode, $twoColBreak, $patternBit1 );
    my( $plotStr, $dataPtCount, $t1, $t2 );

    if( $sourceTypes{$source} eq "single" or $sourceTypes{$source} eq "clock") {
        $posNode = get( $posNodeEntries{$source} );
        # use the source name for the pos node if they didn't enter one
        $posNode = $name if( $posNode =~ /^\s*$/ );
    }
    elsif( $sourceTypes{$source} eq "bus" ) {
        $posNode = $name;
    }
    $negNode = get( $negNodeEntries{$source} );

    $pattern =~ /^(.)/;
    $patternBit1 = $1;
    unless( $initVal =~ /[01]/ ) {
        $initVal = $patternBit1;
    }

    if( $makePlotFile ) {
        $dataPtCount = 1;
        $plotStr = makeSigviewHeader( $name );
        $plotStr .= "0 0\n  " . ($initVal == '1' ? $on : $off) . "\n";
    }
    else {
        if( $netlistLang eq "SPICE" ) {
            print $OUT "V$name $posNode $negNode pwl(0 ", $initVal == '1' ? $on : $off,"\n+ ";
        }
        elsif( $netlistLang eq "Spectre" ) {
            print $OUT "V$name $posNode $negNode vsource type=pwl ";
            print $OUT "wave=[0 ", $initVal == '1' ? $on : $off,"\n+ ";
        }
        elsif( $netlistLang eq "CDS" ) {
            print $OUT "V$name $posNode $negNode pwl(0 ", $initVal == '1' ? $on : $off," &\n";
        }
        elsif( $netlistLang eq "2-Column" ) {
            print $OUT "0 ", $initVal == '1' ? $on : $off,"\n";   
        }

        if( $netlistLang eq "2-Column" ) {
            $twoColBreak = "\n";
        }
        else {
            $twoColBreak = " ";
        }
    }

    if( $initVal ne $patternBit1 ) {
        if( $initVal eq '1' ) {   # falling edge
            if( $makePlotFile ) {
                $plotStr .= "$dataPtCount $delay\n  $on\n";
                $dataPtCount++;
                $t1 = eval "$ft+$delay";
                $plotStr .= "$dataPtCount $t1\n  $off\n";
                $dataPtCount++;
            }
            else {
                if( ($t1=isNumber( $delay ))>=0 && ($t2=isNumber( $ft ))>=0) {
                    print $OUT eval("$t1")," $on, " if $delay ne '0';
                    print $OUT eval("$t2+$t1")," $off, ";
                }
                else {
                    print $OUT "\'$delay\' $on, " if $delay ne '0';
                    print $OUT "\'$ft+$delay\' $off, ";
                }
            }
        }
        else {             # rising edge
            if( $makePlotFile ) {
                $plotStr .= "$dataPtCount $delay\n  $off\n";
                $dataPtCount++;
                $t1 = eval "$rt+$delay";
                $plotStr .= "$dataPtCount $t1\n  $on\n";
                $dataPtCount++;
            }
            else {
                print $OUT "\'$delay\' $off, " if $delay ne '0';
                print $OUT "\'$rt+$delay\' $on, ";
            }
        }
    }

    $pwCount = 1;

    while( $pattern =~ s/^(.)(.)/$2/ ) {
        if( $2 eq $1 ) {    # no edge, do only increment time
            $pwCount++;
        }
        else {
            if( $1 eq '1' ) {  # falling edge
                if( $makePlotFile ) {
                    $t1 = eval( "$pwCount*$pw+$delay" );
                    $t2 = eval( "$pwCount*$pw+$ft+$delay" );
                    $plotStr .= "$dataPtCount $t1\n  $on\n";
                    $dataPtCount++;
                    $plotStr .= "$dataPtCount $t2\n  $off\n";
                    $dataPtCount++;
                }
                else {
                    print $OUT "\'$pwCount*$pw+$delay\' $on,$twoColBreak";
                    print $OUT "\'$pwCount*$pw+$ft+$delay\' $off, ";
                }
            }
            else {             # rising edge
                if( $makePlotFile ) {
                    my $t1 = eval( "$pwCount*$pw+$delay" );
                    my $t2 = eval( "$pwCount*$pw+$rt+$delay" );
                    $plotStr .= "$dataPtCount $t1\n  $off\n";
                    $dataPtCount++;
                    $plotStr .= "$dataPtCount $t2\n  $on\n";
                    $dataPtCount++;
                }
                else {
                    print $OUT "\'$pwCount*$pw+$delay\' $off,$twoColBreak";
                    print $OUT "\'$rt+$pwCount*$pw+$delay\' $on, ";
                }
            }

            $pwCount++;

            if( ($netlistLang eq "2-Column" || ++$count == 2)  && !$makePlotFile) {
                $count = 0;
                print $OUT "&" if $netlistLang eq "CDS";
                print $OUT "\n";
                print $OUT "+ " unless( $netlistLang eq "2-Column" || 
                                        $netlistLang eq "CDS" );
            }
       }
    }

    if( $makePlotFile ) {
        my $t1 = eval( "$pwCount*$pw+$delay" );
        $plotStr .= "$dataPtCount $t1\n  " . ($pattern eq '1' ? $on : $off) . "\n";
        $dataPtCount++;
        $plotStr .= "$dataPtCount MAXTIME\n  " . ($pattern eq '1' ? $on : $off) . "\n";
        $dataPtCount++;
        $plotStr =~ s/XXX/$dataPtCount/;
        $maxTime = $t1 if $t1 > $maxTime;
    }
    else {
        print $OUT "\'$pwCount*$pw+$delay\' ", $pattern eq '1' ? $on : $off;
        if( $netlistLang eq "SPICE" || $netlistLang eq "CDS" ) {
            print $OUT ")\n";
        }
        elsif( $netlistLang eq "Spectre" ) {
            print $OUT "]\n";
        }
        elsif( $netlistLang eq "2-Column" ) {
            print $OUT "\n";
        }
    }

    $sigviewData[$sigDataCount++] = $plotStr;
}

# get digital parameters: pw, on, off, rt, ft, delay, initVal
# this applies to both single sources and busses
# clocks need to get freq and duty cycle
sub getParameters
{
my( $source, $type ) = @_; 
my( $parameters );

    if( $type eq "dc" ) {
        $parameters = "dc=" . get( $dcEntries{$source} );

        if( $parameters =~ /dc=(\d+(?:\.\d+)?)%?/i ) { 
            $dc = sprintf( "%f", $1 );
        }
        elsif( $parameters =~ /dc=\s+/ ) {
            $dc = $DC_DEFAULT;
        }
        elsif( $parameters =~ /dc=([a-z]\w*)/i ) {
            $dc = $1;
        }
        else { 
            return( "dc" );
        }
        return( 0 );
    }
    
    if( $type eq "clock" ) {
        $parameters = "freq=" . get( $freqEntries{$source} );
        $parameters .= " dutycycle=" . get( $dutyCycleEntries{$source} );
    }
    else {
        $parameters = "pw=" . get( $pwEntries{$source} );
    }
    $parameters .= " rt=" . get( $rtEntries{$source} );
    $parameters .= " ft=" . get( $ftEntries{$source} );
    $parameters .= " delay=" . get( $delayEntries{$source} );
    $parameters .= " initval=" . get( $initValEntries{$source} ) if $type =~ /single/i;
    $parameters .= " on=" . get( $onEntries{$source} );
    $parameters .= " off=" . get( $offEntries{$source} );

    # change "meg" to the one-character symbol for 1e6
    $parameters =~ s/meg/x/gi;

    if( $type eq "clock" ) {
        # frequency
        if( $parameters =~ /freq=(\d+(?:\.\d+)?e[-\+]?\d+)/i ) { 
            $freq = sprintf( "%e", $1 );
        }
        elsif( $parameters =~ /freq=(\d+(?:\.\d+)?)([afpnumkxgt]?)/i ) {
            $freq = $1;
            $freq *= $suffixes{$2} if $2;
        }
        elsif( $parameters =~ /freq=\s+/ ) {
            $freq = $FREQ_DEFAULT;
        }
        else {
            return( "freq" );
        }

        # duty cycle
        if( $parameters =~ /dutycycle=(\d+(?:\.\d+)?)%?/i ) { 
            $dutyCycle = sprintf( "%f", $1 );
        }
        elsif( $parameters =~ /dutyCycle=\s+/ ) {
            $dutyCycle = $DUTYCYCLE_DEFAULT;
        }
        else { 
            return( "duty cycle" );
        }
    }
    else {
        # pulse width
        if( $parameters =~ /pw=(\d+(?:\.\d+)?e\[-\+]?\d+)/i ) {
            $pw = sprintf( "%e", $1 );
        }
        elsif( $parameters =~ /pw=(\d+(?:\.\d+)?)([afpnumkxgt]?)/i ) {
            $pw = $1;
            $pw *= $suffixes{$2} if $2;
        }
        elsif( $parameters =~ /pw=([a-z]\w*)/i ) {
            $pw = $1;
        }
        elsif( $parameters =~ /pw=\s+/ ) {
            $pw = $PW_DEFAULT;
        }
        else {
            return( "pw" );
        }
    }

    # rise time
    if( $parameters =~ /rt=(\d+(?:\.\d+)?e[-\+]?\d+)/i ) { 
        $rt = sprintf( "%e", $1 );
    }
    elsif( $parameters =~ /rt=(\d+(?:\.\d+)?)([afpnumkxgt%]?)/i ) {
        if( $2 ) {
            if( defined( $suffixes{$2} ) ) {
                $rt = $1 * $suffixes{$2};
            }
            elsif( $type eq "clock" and $2 eq "%" ) {
                $rt = 1/$freq * $1/100; # percentage of period
            }
            else {
                return( "rt" );
            }
        }
        else {
            $rt = $1;
        }
    }
    elsif( $parameters =~ /rt=([a-z]\w*)/i ) {
        $rt = $1;
    }
    else { $rt = $type eq "clock" ? $RT_DEFAULT_CLK : $RT_DEFAULT; }

    # fall time
    if( $parameters =~ /ft=(\d+(?:\.\d+)?e[-\+]?\d+)/i ) { 
        $ft = sprintf( "%e", $1 );
    }
    elsif( $parameters =~ /ft=(\d+(?:\.\d+)?)([afpnumkxgt%]?)/i ) {
        if( $2 ) {
            if( defined( $suffixes{$2} ) ) {
                $ft = $1 * $suffixes{$2};
            }
            elsif( $type eq "clock" and $2 eq "%" ) {
                $ft = 1/$freq * $1/100; # percentage of period
            }
            else {
                return( "ft" );
            }
        }
        else {
            $ft = $1;
        }
    }
    elsif( $parameters =~ /ft=([a-z]\w*)/i ) {
        $ft = $1;
    }
    else { $ft = $type eq "clock" ? $FT_DEFAULT_CLK : $FT_DEFAULT; }

    # initial delay
    if( $parameters =~ /delay=(\d+(?:\.\d+)?e[-\+]?\d+)/i ) { 
        $delay = sprintf( "%e", $1 );
    }
    elsif( $parameters =~ /delay=(\d+(?:\.\d+)?)([afpnumkxgt]?)/i ) {
        $delay = $1;
        $delay *= $suffixes{$2} if $2;
    }
    elsif( $parameters =~ /delay=([a-z]\w*)/i ) {
        $delay = $1;
    }
    elsif( $parameters =~ /delay=\s+/ ) {
        $delay = $DELAY_DEFAULT;
    }
    else {
        return( "delay" );
    }

    # initial value
    if( $parameters =~ /initval=([01X])/i ) {
        $initVal = $1;
    }
    else {
        $initVal = "X";
    }

    # on voltage
    if( $parameters =~ /on=(-?\d+(?:\.\d+)?e[-\+]?\d+)/i ) { 
        $on = sprintf( "%e", $1 );
    }
    elsif( $parameters =~ /on=(-?\d+(?:\.\d+)?)([afpnumkxgt]?)/i ) {
        $on = $1;
        $on *= $suffixes{$2} if $2;
    }
    elsif( $parameters =~ /on=([a-z]\w*)/i ) {
        $on = $1;
    }
    elsif( $parameters =~ /on=\s+/ ) {
        $on = $ON_DEFAULT;
    }
    else {
        return( "on" );
    }

    # off voltage
    if( $parameters =~ /off=(-?\d+(?:\.\d+)?e[-\+]?\d+)/i ) { 
        $off = sprintf( "%e", $1 );
    }
    elsif( $parameters =~ /off=(-?\d+(?:\.\d+)?)([afpnumkxgt]?)/i ) {
        $off = $1;
        $off *= $suffixes{$2} if $2;
    }
    elsif( $parameters =~ /off=\s+/ ) {
        $off = $OFF_DEFAULT;
    }
    elsif( $parameters =~ /off=([a-z]\w*)/i ) {
        $off = $1;
    }
    else {
        return( "off" );
    }

    return( 0 );
}

sub widgetStatus() {
# make sure the save, export, etc. buttons and menu entries have the
# correct enabled/disabled state

    my $state = $numSources > 0 ? "normal" : "disabled";

    $saveButton->configure( -state => $state );
    my $m = $fileMenu->cget( "menu" );
    $m->entryconfigure( 2, -state => $state );
    $m->entryconfigure( 3, -state => $state );

    $state = "disabled";

    foreach my $source (sort keys %descLabels) {
        if( $isExportable{$source} eq "on" ) {
            $state = "normal";
            last;
        }
    }

    $exportButton->configure( -state => $state );
    $plotButton->configure( -state => $state );
    $m->entryconfigure( 5, -state => $state );
    $m->entryconfigure( 6, -state => $state );
}

# create the widgets for another source
# side effect: sourceNum is incremented
sub doNewSource {
my( $type, $noBusyCursor ) = @_;

    busyCursor( 1 ) unless $noBusyCursor;
    $sourceNum++;  # this is an index into the widget arrays, is never decremented
    createNewSourceWidgets( $sourceNum, $type );
    $numSources++; # this keeps track of the current number of sources
    addToSourceListWindow( $sourceNum );
    showSourceListWindow();
    setBalloonHelp( $sourceNum );
    busyCursor( 0 ) unless $noBusyCursor;
    widgetStatus();
}

# add the new source to the "source list" window
sub addToSourceListWindow {
my $sourceIdx = $_[0];

    $sourceListFrames{$sourceIdx} = $sourceListPane->Frame()
                                                   ->pack( -pady => 5,
                                                           -expand => 1,
                                                           -fill => "x" );
    $sourceListButtons{$sourceIdx} = $sourceListFrames{$sourceIdx}->Button();

    # use tmp variable for attempt at readability
    my $tmp = $sourceListButtons{$sourceIdx};
    $tmp->configure( -text => "$sourceTypes{$sourceIdx}",
                     # when button is clicked, see() widgets at both top and bottom
                     # of the source so we get (almost the) whole thing visible
                     -command => sub { $sourcePane->see($resetSrcButtons{$sourceIdx});
                                       $sourcePane->see($descEntries{$sourceIdx}); 
                                       $descEntries{$sourceIdx}->focus();
                                       $descEntries{$sourceIdx}->selectionRange( 0,'end' ); });
    $tmp->pack( -expand => 1, 
                -fill => "both", 
                -padx => 5, 
                -pady => 1,
                -side => "left" );
}

# make button text the same as the "description" field of the corresponding source
sub setSourceListButton{
    my $sourceIdx = $_[0];

    my $text = $descEntries{$sourceIdx}->get();
    if( $text =~ /^$/ ) {
        $text = $sourceTypes{$sourceIdx};
    }

    my $font = $sourceListButtons{$sourceIdx}->cget( "font");
    my $len = $sourceListButtons{$sourceIdx}->fontMeasure( $font, $text );

    $sourceListButtons{$sourceIdx}->geometry =~ /^(\d+)/;
    $sourceListButtons{$sourceIdx}->configure( -text => "$text" ) ;
    $sourceListWindow->update();
    
    # resize source list window if needed
    $sourceListWindow->geometry() =~ /^(\d+)x(\d+)/;
    my $w = $1;
    my $h = $2;
    # $sourceListButtons{$sourceIdx}->geometry =~ /^(\d+)/;
    my $minW = $len + 50;
    if( $w < $minW ) {
        $sourceListWindow->geometry( sprintf( "=%dx%d", $minW, $h ) );
    }
}

# make a copy of a source
sub dupSrc {
my $sourceIdx = $_[0];    
my $destIdx;
my $type;

    $type = $sourceTypes{$sourceIdx};

    doNewSource( $type );

    # $sourceIdx is the index of the source source (sigh);
    # $sourceNum (from doNewSource()) is index of source we just created, i.e,
    # the dest src

    $destIdx = $sourceNum;

    setEntryString( $descEntries{$destIdx}, $descEntries{$sourceIdx}->get() );
    setEntryString( $negNodeEntries{$destIdx}, $negNodeEntries{$sourceIdx}->get() );
    setEntryString( $rtEntries{$destIdx}, $rtEntries{$sourceIdx}->get() );
    setEntryString( $ftEntries{$destIdx}, $ftEntries{$sourceIdx}->get() );

    if( $type eq "single" or $type eq "clock" or $type eq "dc" ) {
        setEntryString( $srcEntries{$destIdx},
                        $srcEntries{$sourceIdx}->get() );
        if( $invertDupSrc ) {
            setEntryString( $posNodeEntries{$destIdx}, 
                            "_".$posNodeEntries{$sourceIdx}->get() );
        }
        else {
            setEntryString( $posNodeEntries{$destIdx}, 
                            $posNodeEntries{$sourceIdx}->get() );
        }
    }
    if( $type eq "bus" ) {
        setEntryString( $vecCompsEntries{$destIdx}, 
                        $vecCompsEntries{$sourceIdx}->get() );
    }
    if( $type eq "single" or $type eq "bus" ) {
        if( $invertDupSrc ) {
            # since data can be in various formats (eg: 5(1), 3( 11 3(0)), 0x8)
            # just write out the complemented form in 1's and 0's
            my $data = expandDataStream( $dataEntries{$sourceIdx}->get() );
            # there has to be a better way to do this...
            $data =~ s/0/a/g;
            $data =~ s/1/0/g;
            $data =~ s/a/1/g;
            setEntryString( $dataEntries{$destIdx}, $data );

            # prepend "_" to source name if we're inverting
            my $str = $srcEntries{$destIdx}->get();
            setEntryString( $srcEntries{$destIdx}, "_" . $str )
                unless $str =~ /^\s*$/;
            $str = $descEntries{$destIdx}->get();
            setEntryString( $descEntries{$destIdx}, "_" . $str )
                unless $str =~ /^\s*$/;
        }
        else {
            setEntryString( $dataEntries{$destIdx},
                            $dataEntries{$sourceIdx}->get() );
        }
        setEntryString( $pwEntries{$destIdx}, $pwEntries{$sourceIdx}->get() );
    }
    if( $type eq "clock" ) {
        setEntryString( $freqEntries{$destIdx},
                        $freqEntries{$sourceIdx}->get() );
        setEntryString( $dutyCycleEntries{$destIdx},
                        $dutyCycleEntries{$sourceIdx}->get() );
        if( $invertDupSrc ) {
            # prepend "_" to source name if we're inverting
            setEntryString( $srcEntries{$destIdx}, 
                            "_".$srcEntries{$destIdx}->get() );
            setEntryString( $descEntries{$destIdx}, 
                            "_".$descEntries{$destIdx}->get() );

            setEntryString( $onEntries{$destIdx}, $offEntries{$sourceIdx}->get() );
            setEntryString( $offEntries{$destIdx}, $onEntries{$sourceIdx}->get() );
        }
        else {
            setEntryString( $onEntries{$destIdx}, $onEntries{$sourceIdx}->get() );
            setEntryString( $offEntries{$destIdx}, $offEntries{$sourceIdx}->get() );
        }
    }
    elsif( $type eq "single" or $type eq "bus" ) {
        setEntryString( $onEntries{$destIdx}, $onEntries{$sourceIdx}->get() );
        setEntryString( $offEntries{$destIdx}, $offEntries{$sourceIdx}->get() );
    }
    elsif( $type eq "dc" ) {
        setEntryString( $dcEntries{$destIdx}, $dcEntries{$sourceIdx}->get() );
    }

    setEntryString( $delayEntries{$destIdx}, $delayEntries{$sourceIdx}->get() );
    setEntryString( $initValEntries{$destIdx}, $initValEntries{$sourceIdx}->get() );
    
    setSourceListButton( $destIdx );

    $invertDupSrc = 0;
}

sub expandDataStream {
my $data = $_[0];
my $bits;

    # expand hex numbers
    while( $data =~ /\s*(0x[a-f\d]+)\s*/i ) {
        # use substr to avoid the leading 0x
        $bits = unpack( "B*", pack( "H*", substr( $1, 2 ) ) );

        # unpack fills in a blank nybble if the number of hex digits is odd,
        # eg, unpack(B*", pack("H*","0x5")) produces 01010000. so, we need to
        # delete these 4 extra zeroes.
        if( length( $1 ) % 2 == 1 ) {
            $bits = substr( $bits, 0, -4 );
        }

        # now substitute $bits back into the $data vector where $1 used to
        # be. since we're using $1 here it's very important not to do any regex
        # searches between here and the "while" statement above
        substr( $data, index($data,$1), length($1) ) = join( "", " ", $bits, " ");
    }

    # expand multiplied datas
    while( $data =~ /\s*((\d+)        (?# $2, the multiplier)
                        \(([01 ]+)\)  (?# $3, the vector to be multiplied)
                       )\s*/x ) {
        # mult/vec pair is $1
        # pad with spaces so we don't get, eg: 4(111)1(1) -> 1111111111111(1)
        substr($data, index($data, $1), length($1)) = join("", " ", $3 x $2, " ");
    }

    # remove whitespace; anything left other than 0 or 1 is illegal
    $data =~ s/[ \{]//g; # } dummy brace to fix syn hilite in vim

    return $data;
}

        
# initialize an entry widget with a text string
sub setEntryString {
my( $entry, $str ) = @_;
     
    $entry->delete( 0, "end" );
    $entry->insert( 0, $str );
}

# initialize source
sub resetSrc {
my $index = $_[0];    

    my $type = $sourceTypes{$index};

    if( $type eq "single" or $type eq "clock" ) {
        setEntryString( $srcEntries{$index}, "" );
        setEntryString( $posNodeEntries{$index}, "" );
    }
    if( $type eq "bus" ) {
        setEntryString( $vecCompsEntries{$index}, "" );
    }
    if( $type eq "single" or $type eq "bus" ) {
        setEntryString( $dataEntries{$index}, "" );
        setEntryString( $pwEntries{$index}, $PW_DEFAULT );
        setEntryString( $rtEntries{$index}, $RT_DEFAULT );
        setEntryString( $ftEntries{$index}, $FT_DEFAULT );
    }
    if( $type eq "clock" ) {
        setEntryString( $freqEntries{$index}, $FREQ_DEFAULT );
        setEntryString( $dutyCycleEntries{$index}, $DUTYCYCLE_DEFAULT);
        setEntryString( $rtEntries{$index}, $RT_DEFAULT_CLK );
        setEntryString( $ftEntries{$index}, $FT_DEFAULT_CLK );
    }
    if( $type =~ /dc/i ) {
        setEntryString( $dcEntries{$index}, $DC_DEFAULT );
    }
    else {
        setEntryString( $onEntries{$index}, $ON_DEFAULT );
        setEntryString( $offEntries{$index}, $OFF_DEFAULT );
        setEntryString( $delayEntries{$index}, $DELAY_DEFAULT );
    }
    if( $type =~ /single/i ) {
        setEntryString( $initValEntries{$index}, "" );
    }
    setEntryString( $descEntries{$index}, "" );
    setEntryString( $negNodeEntries{$index}, $NEGNODE_DEFAULT );
}

sub setBallonHelpState {
    setBalloonHelp( "initial" );
    foreach my $w (keys %descLabels){
        setBalloonHelp( $w );
    }
}

# toggle balloon help
sub setBalloonHelp {
my $index = $_[0];

# items that are always present
if( $index eq "initial" ) {
    my %helpMsgs1 = ( "add new source (ctrl-a)" => $addSrcButton,
                      "type of source to add" => $srcTypeMenu,
                      "save BitGen file (ctrl-s)" => $saveButton,
                      "plot with Sigview (ctrl-p)" => $plotButton,
                      "export netlist (ctrl-e)" => $exportButton,
                      "exit (ctrl-q)" => $exitButton,
                    );

        foreach my $w (keys %helpMsgs1) {
            if( $doBalloonHelp ) {
                $mainBalloon->attach( $helpMsgs1{$w}, -msg => $w );
            }
            else {
                $mainBalloon->detach( $helpMsgs1{$w} );
            }
        }

    return;
}

# source items in main window, not all are always present
my %helpMsgs2 = ( "rise time (seconds or % of period)" => $rtLabels{$index},
                  "fall time (seconds or % of period)" => $ftLabels{$index},
                  "pulse width (seconds)" => $pwLabels{$index},
                  "logic \"1\" voltage (volts)" => $onLabels{$index},
                  "logic \"0\" voltage (volts)" => $offLabels{$index},
                  "initial delay (seconds)" => $delayLabels{$index},
                  "initial value (0, 1 or x)" => $initValLabels{$index},
                  "restore defaults" => $resetSrcButtons{$index},
                  "delete this source" => $deleteSrcButtons{$index},
                  "duplicate this source\n(ctrl-click to invert)" => $dupSrcButtons{$index},
                  "name of source" => $srcLabels{$index},
                  "source's positive node (source\nname is used if this is left blank)" => $posNodeLabels{$index},
                  "source's negative node" => $negNodeLabels{$index},
                  "digital bitstream" => $dataLabels{$index},
                  "vector name and components"  => $vecCompsLabels{$index},
                  "description of source;\nexported as comment" => $descLabels{$index},
                  "frequency (Hz)" => $freqLabels{$index},
                  "duty cycle" => $dutyCycleLabels{$index},
                  "DC voltage (volts)" => $dcLabels{$index},
               );

    foreach my $w (keys %helpMsgs2) {
        if( $doBalloonHelp ) {
            $mainBalloon->attach( $helpMsgs2{$w}, -msg => $w )
                if defined $helpMsgs2{$w};
        }
        else {
            $mainBalloon->detach( $helpMsgs2{$w} )
                if defined $helpMsgs2{$w};
        }
    }

# items in source list window
my %helpMsgs3 = ( "find source" => $sourceListButtons{$index},
                  "let source be exported/plotted" => $sourceListExpCheckB{$index} 
                );

    foreach my $w (keys %helpMsgs3) {
        if( $doBalloonHelp ) {
            $sourceListBalloon->attach( $helpMsgs3{$w}, -msg => $w );
        }
        else {
            $sourceListBalloon->detach( $helpMsgs3{$w} );
        }
    }
}

# create widgets for a new source
sub createNewSourceWidgets {
my( $index, $sourceType ) = @_;

if( $numSources == 0 ) {
    $main->geometry() =~ /^(\d+)x(\d+)/;
    my $width = $1;
    my $height = $2;

    # don't have window size flash back and forth...
    $main->packPropagate( 0 );

    $sourceFrame = $main->TFrame( -label => "Sources" )
                        ->pack( -padx => 10,
                                -expand => 1,
                                -side => "bottom",
                                -fill => "both" );
    $sourcePane = $sourceFrame->Scrolled( "Pane", Name => "sourcePane", 
                                      -scrollbars => "se",
                                      -sticky => "ew" )
                              ->pack( -expand => 1,
                                      -fill => "both" );

    # resize to show (most of) first source
    $height = 375 if $height < 375;
    $width = 725 if $width < 725;
    $main->geometry( sprintf( "=%dx%d", $width, $height ) );
}

$sourceTypes{$index} = $sourceType;

if( $sourceType =~ /dc/i ) {
    $sourceType = "DC";
}
else {
    $sourceType =~ s/^(.)/\u$1/;
}

$sourceEnclosures{$index} = $sourcePane->TFrame( -label => "$sourceType" )
                                       ->pack( -expand => 1, 
                                               -fill => "both", 
                                               -padx => 5, 
                                               -pady => 1 );

my $descContainer = $sourceEnclosures{$index}->Frame()
                                             ->pack( -pady => 1,
                                                     -expand => 1,
                                                     -fill => "x" );
my $srcContainer = $sourceEnclosures{$index}->Frame()
                                            ->pack( -pady => 1,
                                                    -expand => 1,
                                                    -fill => "x" );
my $dataContainer = $sourceEnclosures{$index}->Frame()
                                             ->pack( -pady => 1,
                                                     -expand => 1,
                                                     -fill => "x" );
my $waveParamsContainer = $sourceEnclosures{$index}->Frame()
                                                   ->pack( -pady => 1,
                                                           -expand => 1,
                                                           -fill => "x" );


$descFrames{$index} = $descContainer->Frame( -borderwidth => 1,
                                             -relief => "raised" )
                                    ->pack( -padx => 10,
                                            -pady => 3,
                                            -side => "left" );
$descLabels{$index} = $descContainer->Label( -anchor => "w",
                                             -text => "Description" )
                                    ->pack( -in => $descFrames{$index},
                                            -padx => 2,
                                            -pady => 3,
                                            -side => "left" );
$descEntries{$index} = $descContainer->Entry( -highlightthickness => 0, 
                                              -width => 50 )
                                     ->pack( -in => $descFrames{$index},
                                             -expand => 1,
                                             -fill => "x",
                                             -padx => 2,
                                             -pady => 3, 
                                             -side => "right" );
$descEntries{$index}->bind( '<KeyPress>' => sub{ setSourceListButton( $index ); $needSaveFlag=1; } ); 

$sourceListExpCheckB{$index} = $descContainer->Checkbutton( -text => "Exportable");
my $tmp = $sourceListExpCheckB{$index};
$tmp->configure( -variable => \$isExportable{$index},
                 -command => sub { widgetStatus(); },
                 -onvalue => "on",
                 -offvalue => "off" );
$tmp->select;   # exportable by default
$tmp->pack( -padx => 5,
            -side => "right" );

if( $sourceType =~ /bus/i ) {
    $vecCompsFrames{$index} = $srcContainer->Frame( -borderwidth => 1, 
                                                    -relief => "raised" )
                                           ->pack( -padx=>10,
                                                   -side=>"left" );
    $vecCompsLabels{$index} = $srcContainer->Label( -anchor => "w", 
                                                    -text => "Vector" )
                                           ->pack( -in => $vecCompsFrames{$index},
                                                   -padx => 2,
                                                   -pady => 3,
                                                   -side => "left" );
    $vecCompsEntries{$index} = $srcContainer->Entry( -highlightthickness => 0,
                                                     -width => 20 )
                                            ->pack( -in => $vecCompsFrames{$index},
                                                    -expand => 1,
                                                    -fill => "x",
                                                    -padx => 2,
                                                    -pady => 3,
                                                    -side => "right" );
    $vecCompsEntries{$index}->bind( '<KeyPress>' => sub{ $needSaveFlag=1; } ); 
    $negNodeFrames{$index} = $srcContainer->Frame( -borderwidth => 1,
                                                   -relief => "raised" )
                                          ->pack( -padx => 10,
                                                  -side => "left" );
    $negNodeLabels{$index} = $srcContainer->Label( -anchor => "w", 
                                                   -text => "- node" )
                                          ->pack( -in => $negNodeFrames{$index},
                                                  -padx => 2,
                                                  -pady => 3,
                                                  -side => "left" );
    $negNodeEntries{$index} = $srcContainer->Entry( -highlightthickness => 0, 
                                                    -width => 10 )
                                           ->pack( -in => $negNodeFrames{$index},
                                                   -expand => 1,
                                                   -fill => "x",
                                                   -padx => 2,
                                                   -pady => 3, 
                                                   -side => "right" );
}
else {
    $srcFrames{$index} = $srcContainer->Frame( -borderwidth => 1,
                                               -relief => "raised" )
                                      ->pack( -padx=>10, 
                                              -side=>"left" );
    $srcLabels{$index} = $srcContainer->Label( -anchor => "w", 
                                               -text => "Source name" )
                                      ->pack( -in => $srcFrames{$index},
                                              -padx => 2, 
                                              -pady => 3, 
                                              -side => "left" );
    $srcEntries{$index} = $srcContainer->Entry( -highlightthickness => 0, 
                                                -width=>16 )
                                       ->pack( -in => $srcFrames{$index},
                                               -expand => 1,
                                               -fill => "x",
                                               -padx => 2,
                                               -pady => 3, 
                                               -side => "right" );
    $srcEntries{$index}->bind( '<KeyPress>' => sub{ $needSaveFlag=1; } ); 
    $posNodeFrames{$index} = $srcContainer->Frame( -borderwidth => 1,
                                                   -relief => "raised" );
    $posNodeLabels{$index} = $srcContainer->Label( -anchor => "w",
                                                   -text => "+ node" );
    $posNodeEntries{$index} = $srcContainer->Entry( -highlightthickness => 0, 
                                                    -width=>10 );
    $posNodeFrames{$index}->pack(-padx=>10,-side=>"left");
    $posNodeLabels{$index}->pack( -in => $posNodeFrames{$index},
                                  -padx => 2,
                                  -pady => 3,
                                  -side => "left" );
    $posNodeEntries{$index}->pack( -in => $posNodeFrames{$index},
                                   -expand => 1,
                                   -fill => "x",
                                   -padx => 2,
                                   -pady => 3,
                                   -side => "right" );
    $posNodeEntries{$index}->bind( '<KeyPress>' => sub{ $needSaveFlag=1; } ); 
    $negNodeFrames{$index} = $srcContainer->Frame( -borderwidth => 1, 
                                                   -relief => "raised" );
    $negNodeLabels{$index} = $srcContainer->Label( -anchor => "w",
                                                   -text => "- node" );
    $negNodeEntries{$index} = $srcContainer->Entry( -highlightthickness => 0, 
                                                    -width=>10 );
    $negNodeFrames{$index}->pack( -padx=>10,
                                  -side=>"left" );
    $negNodeLabels{$index}->pack( -in => $negNodeFrames{$index},
                                  -padx => 2, 
                                  -pady => 3, 
                                  -side => "left" );
    $negNodeEntries{$index}->pack( -in => $negNodeFrames{$index},
                                   -expand => 1,
                                   -fill => "x", 
                                   -padx => 2,
                                   -pady => 3,
                                   -side => "right" );
}

$negNodeEntries{$index}->bind( '<KeyPress>' => sub{ $needSaveFlag=1; } ); 

if( $sourceType =~ /dc/i ) {
    $dcFrames{$index} = $waveParamsContainer->Frame( -borderwidth => 1, 
                                                     -relief => "raised" );
    $dcLabels{$index} = $waveParamsContainer->Label( -anchor => "w", 
                                                     -text => "DC" );
    $dcEntries{$index} = $waveParamsContainer->Entry( -highlightthickness => 0, 
                                                      -justify => "right",
                                                      -width => 5 );
    $dcFrames{$index}->pack( -padx => 10,
                             -side => "left" );
    $dcLabels{$index}->pack( -in => $dcFrames{$index},
                             -expand => 0,
                             -fill => "none",
                             -padx => 2,
                             -pady => 3, 
                             -side => "left" );
    $dcEntries{$index}->pack( -in => $dcFrames{$index},
                              -expand => 1,
                              -fill => "x",
                              -padx => 2,
                              -pady => 3,
                              -side => "right" );
    $dcEntries{$index}->bind( '<KeyPress>' => sub{ $needSaveFlag=1; } ); 
}
else {
    if( $sourceType =~ /bus/i or $sourceType =~ /single/i ) {
        $dataFrames{$index} = $dataContainer->Frame( -borderwidth => 1,
                                                     -relief => "raised" )
                                            ->pack( -padx => 10,
                                                    -pady => 3,
                                                    -side => "left",
                                                    -expand => 1, 
                                                    -fill => "x" );
        $dataLabels{$index} = $dataContainer->Label( -anchor => "w",
                                                     -text => "Data" )
                                            ->pack( -in => $dataFrames{$index},
                                                    -padx => 2,
                                                    -pady => 3, 
                                                    -side => "left" );
        $dataEntries{$index} = $dataContainer->Entry( -highlightthickness => 0, 
                                                      -width => 50 )
                                             ->pack( -in => $dataFrames{$index},
                                                     -expand => 1,
                                                     -fill => "x",
                                                     -padx => 2,
                                                     -pady => 3,
                                                     -side => "right" );
        $dataEntries{$index}->bind( '<KeyPress>' => sub{ $needSaveFlag=1; } ); 
    }

    $rtFrames{$index} = $waveParamsContainer->Frame( -borderwidth => 1, 
                                                     -relief => "raised" );
    $rtLabels{$index} = $waveParamsContainer->Label( -anchor => "w", 
                                                     -text => "rt" );
    $rtEntries{$index} = $waveParamsContainer->Entry( -highlightthickness => 0, 
                                                      -justify => "right",
                                                      -width => 5 );
    $rtFrames{$index}->pack( -padx => 10,
                             -side => "left" );
    $rtLabels{$index}->pack( -in => $rtFrames{$index},
                             -expand => 0,
                             -fill => "none",
                             -padx => 2,
                             -pady => 3, 
                             -side => "left" );
    $rtEntries{$index}->pack( -in => $rtFrames{$index},
                              -expand => 1,
                              -fill => "x",
                              -padx => 2,
                              -pady => 3,
                              -side => "right" );
    $rtEntries{$index}->bind( '<KeyPress>' => sub{ $needSaveFlag=1; } ); 
    $ftFrames{$index} = $waveParamsContainer->Frame( -borderwidth => 1,
                                                     -relief => "raised" );
    $ftLabels{$index} = $waveParamsContainer->Label( -anchor => "w", 
                                                     -text => "ft" );
    $ftEntries{$index} = $waveParamsContainer->Entry( -highlightthickness => 0, 
                                                      -justify => "right" ,
                                                      -width => 5);
    $ftFrames{$index}->pack( -padx => 10, 
                             -side => "left" );
    $ftLabels{$index}->pack( -in => $ftFrames{$index},
                             -padx => 2, 
                             -pady => 3, 
                             -side => "left" );
    $ftEntries{$index}->pack( -in => $ftFrames{$index},
                              -expand => 1,
                              -fill => "x",
                              -padx => 2,
                              -pady => 3,
                              -side => "right" );
    $ftEntries{$index}->bind( '<KeyPress>' => sub{ $needSaveFlag=1; } ); 
    if( $sourceType =~ /clock/i ) {
        $freqFrames{$index} = $waveParamsContainer->Frame( -borderwidth => 1, 
                                                           -relief => "raised" )
                                                  ->pack( -padx => 10,
                                                          -side => "left" );
        $freqLabels{$index} = $waveParamsContainer->Label( -anchor => "w",
                                                           -text => "freq" )
                                                  ->pack( -in => $freqFrames{$index},
                                                          -padx => 2,
                                                          -pady => 3, 
                                                          -side => "left" );
        $freqEntries{$index} = $waveParamsContainer->Entry( -highlightthickness => 0,
                                                            -justify => "right",
                                                            -width => 5 )
                                                   ->pack( -in => $freqFrames{$index},
                                                           -expand => 1,
                                                           -fill => "x",
                                                           -padx => 2,
                                                           -pady => 3, 
                                                           -side => "right" );
        $freqEntries{$index}->bind( '<KeyPress>' => sub{ $needSaveFlag=1; } ); 
        $dutyCycleFrames{$index} = $waveParamsContainer->Frame( -borderwidth => 1, 
                                                                -relief => "raised" )
                                                       ->pack( -padx => 10,
                                                               -side => "left" );
        $dutyCycleLabels{$index} = $waveParamsContainer->Label( -anchor => "w",
                                                                -text => "duty cycle" )
                                                       ->pack( -in=>$dutyCycleFrames{$index},
                                                               -padx => 2,
                                                               -pady => 3, 
                                                               -side => "left" );
        $dutyCycleEntries{$index} = $waveParamsContainer->Entry( -highlightthickness => 0,
                                                                 -justify => "right",
                                                                 -width => 5 )
                                                        ->pack( -in=>$dutyCycleFrames{$index},
                                                                -expand => 1,
                                                                -fill => "x",
                                                                -padx => 2,
                                                                -pady => 3, 
                                                                -side => "right" );
        $dutyCycleEntries{$index}->bind( '<KeyPress>' => sub{ $needSaveFlag=1; } ); 
    }
    else {
        $pwFrames{$index} = $waveParamsContainer->Frame( -borderwidth => 1, 
                                                         -relief => "raised" )
                                                ->pack( -padx => 10,
                                                        -side => "left" );
        $pwLabels{$index} = $waveParamsContainer->Label( -anchor => "w",
                                                         -text => "pw" )
                                                ->pack( -in => $pwFrames{$index},
                                                        -padx => 2,
                                                        -pady => 3, 
                                                        -side => "left" );
        $pwEntries{$index} = $waveParamsContainer->Entry( -highlightthickness => 0,
                                                          -justify => "right",
                                                          -width => 5 )
                                                 ->pack( -in => $pwFrames{$index},
                                                         -expand => 1,
                                                         -fill => "x",
                                                         -padx => 2,
                                                         -pady => 3, 
                                                         -side => "right" );
        $pwEntries{$index}->bind( '<KeyPress>' => sub{ $needSaveFlag=1; } ); 
    }

    $onFrames{$index} = $waveParamsContainer->Frame( -borderwidth => 1, 
                                                     -relief => "raised" );
    $onLabels{$index} = $waveParamsContainer->Label( -anchor => "w", 
                                                     -text => "on" );
    $onEntries{$index} = $waveParamsContainer->Entry( -highlightthickness => 0, 
                                                      -justify => "right",
                                                      -width => 5 );
    $onFrames{$index}->pack( -padx => 10,
                             -side => "left" );
    $onLabels{$index}->pack( -in => $onFrames{$index},
                             -padx => 2, 
                             -pady => 3, 
                             -side => "left" );
    $onEntries{$index}->pack( -in => $onFrames{$index},
                              -expand => 1,
                              -fill => "x",
                              -padx => 2,
                              -pady => 3, 
                              -side => "right" );
    $onEntries{$index}->bind( '<KeyPress>' => sub{ $needSaveFlag=1; } ); 
    $offFrames{$index} = $waveParamsContainer->Frame( -borderwidth => 1, 
                                                      -relief => "raised" );
    $offLabels{$index} = $waveParamsContainer->Label( -anchor => "w", 
                                                      -text => "off" );
    $offEntries{$index} = $waveParamsContainer->Entry( -highlightthickness => 0, 
                                                       -justify => "right",
                                                       -width => 5 );
    $offFrames{$index}->pack( -padx => 10,
                              -side => "left" );
    $offLabels{$index}->pack( -in => $offFrames{$index},
                              -padx => 2, 
                              -pady => 3, 
                              -side => "left" );
    $offEntries{$index}->pack( -in => $offFrames{$index},
                               -expand => 1,
                               -fill => "x",
                               -padx => 2,
                               -pady => 3, 
                               -side => "right" );
    $offEntries{$index}->bind( '<KeyPress>' => sub{ $needSaveFlag=1; } ); 
    $delayFrames{$index} = $waveParamsContainer->Frame( -borderwidth => 1, 
                                                        -relief => "raised" );
    $delayLabels{$index} = $waveParamsContainer->Label( -anchor => "w", 
                                                        -text => "delay" );
    $delayEntries{$index} = $waveParamsContainer->Entry( -highlightthickness => 0, 
                                                         -justify => "right",
                                                         -width => 5 );
    $delayFrames{$index}->pack( -padx => 10,
                                -side => "left" );
    $delayLabels{$index}->pack( -in => $delayFrames{$index},
                                -padx => 2, 
                                -pady => 3, 
                                -side => "left" );
    $delayEntries{$index}->pack( -in => $delayFrames{$index},
                                 -expand => 1,
                                 -fill => "x",
                                 -padx => 2,
                                 -pady => 3, 
                                 -side => "right" );
    $delayEntries{$index}->bind( '<KeyPress>' => sub{ $needSaveFlag=1; } ); 
}

if( $sourceType =~ /single/i ) {
    $initValFrames{$index} = $waveParamsContainer->Frame( -borderwidth => 1, 
                                                        -relief => "raised" );
    $initValLabels{$index} = $waveParamsContainer->Label( -anchor => "w", 
                                                        -text => "initVal" );
    $initValEntries{$index} = $waveParamsContainer->Entry( -highlightthickness => 0, 
                                                         -justify => "right",
                                                         -width => 1 );
    $initValFrames{$index}->pack( -padx => 10,
                                -side => "left" );
    $initValLabels{$index}->pack( -in => $initValFrames{$index},
                                -padx => 2, 
                                -pady => 3, 
                                -side => "left" );
    $initValEntries{$index}->pack( -in => $initValFrames{$index},
                                 -expand => 1,
                                 -fill => "x",
                                 -padx => 2,
                                 -pady => 3, 
                                 -side => "right" );
    $initValEntries{$index}->bind( '<KeyPress>' => sub{ $needSaveFlag=1; } ); 
}

$resetSrcButtons{$index} = $sourceEnclosures{$index}->Button( -text => "Reset source",
                                 -command => sub { resetSrc( $index ); } );
$resetSrcButtons{$index}->pack( -padx => 10, 
                                -pady => 5,
                                -side => "left" );
$deleteSrcButtons{$index} = $sourceEnclosures{$index}->Button( -text => "Delete source",
                                 -command => sub { deleteSrc( $index, 1 ); } );
$deleteSrcButtons{$index}->pack( -padx => 10, 
                                 -pady => 5,
                                 -side => "left" );
$dupSrcButtons{$index} = $sourceEnclosures{$index}->Button( -text => "Duplicate source",
                                 -command => sub { dupSrc( $index ); } );
$dupSrcButtons{$index}->bind( '<Control-1>' => sub{ $invertDupSrc = 1; } );
$dupSrcButtons{$index}->pack( -padx => 10, 
                              -pady => 5,
                              -side => "left" );

# initialize entry widgets with defaults
resetSrc( $index );

# scroll pane down to see most recently added widgets
# have to "update" to draw widgets before we can "see" them
$main->update();
$sourcePane->see( $resetSrcButtons{$index} );
}

# delete a source
sub deleteSrc {
my( $source, $doResize) = @_;

    $sourceEnclosures{$source}->destroy();
    $sourceListFrames{$source}->destroy();
    delete $descFrames{$source};
    delete $descLabels{$source};
    delete $descEntries{$source};
    delete $srcFrames{$source};
    delete $srcLabels{$source};
    delete $srcEntries{$source};
    delete $vecCompsFrames{$source};
    delete $vecCompsLabels{$source};
    delete $vecCompsEntries{$source};
    delete $posNodeFrames{$source};
    delete $posNodeLabels{$source};
    delete $posNodeEntries{$source};
    delete $negNodeFrames{$source};
    delete $negNodeLabels{$source};
    delete $negNodeEntries{$source};
    delete $dataFrames{$source};
    delete $dataLabels{$source};
    delete $dataEntries{$source};
    delete $dcFrames{$source};
    delete $dcLabels{$source};
    delete $dcEntries{$source};
    delete $rtFrames{$source};
    delete $rtLabels{$source};
    delete $rtEntries{$source};
    delete $ftFrames{$source};
    delete $ftLabels{$source};
    delete $ftEntries{$source};
    delete $pwFrames{$source};
    delete $pwLabels{$source};
    delete $pwEntries{$source};
    delete $freqFrames{$source};
    delete $freqLabels{$source};
    delete $freqEntries{$source};
    delete $dutyCycleFrames{$source};
    delete $dutyCycleLabels{$source};
    delete $dutyCycleEntries{$source};
    delete $onFrames{$source};
    delete $onLabels{$source};
    delete $onEntries{$source};
    delete $offFrames{$source};
    delete $offLabels{$source};
    delete $offEntries{$source};
    delete $delayFrames{$source};
    delete $delayLabels{$source};
    delete $delayEntries{$source};
    delete $initValFrames{$source};
    delete $initValLabels{$source};
    delete $initValEntries{$source};
    delete $resetSrcButtons{$source};
    delete $deleteSrcButtons{$source};
    delete $sourceEnclosures{$source};
    delete $sourceTypes{$source};
    delete $sourceListButtons{$source};
    delete $sourceListExpCheckB{$source};
    delete $sourceListFrames{$source};
    
    # did we delete them all?
    if(  --$numSources == 0 ) {
        $sourceFrame->destroy();

        # resize height to only show top
        if( $doResize ) {
            $main->geometry( "=580x120" );
        }

        # nothing to save!
        $needSaveFlag = 0;

        # close source list window
        showSourceListWindow();
    }
    else {
        $needSaveFlag = 1;
    }
    widgetStatus();
}

sub setMainWindowTitle {
    return if $tty;

    my $title = "BitGen $BitGen_Version: ";

    if( defined( $currentFilename ) ) {
        $title .= "$currentFilename ";
    }
    else {
        $title .= "(no BitGen file) ";
    }

    if( defined( $currentNetlistname ) ) {
        $title .= "($currentNetlistname)";
    }
    else {
        $title .= "(no netlist file)";
    }

    $main->configure( -title => $title );
    $main->iconname( $title );
}

sub doMessageBox {
my( $title, $msg, $icon, $type ) = @_;

    $type = "OK" if !defined( $type );
    if( $tty ) {
        print STDERR "$type: $msg\n";
    }
    else {
        $main->bell() if $icon =~ /error/i;
        return $main->messageBox( -icon => $icon, -type => $type,
                                  -title => $title, -message => $msg );
    }
}

sub doExit {
    my $save = "no";
    if( $needSaveFlag and $numSources > 0 ) {
        $save = doMessageBox( "Save needed", "Save BitGen file before exit?", 
                              "question", "YesNoCancel" );
    }

    doSave( "Save" ) if $save =~ /^y/i;
        
    exit( 0 ) unless $save =~ /^c/i;
}
# vim:ts=4:columns=90:tw=70:
