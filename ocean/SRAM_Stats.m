%% $%$%$%$%$%$%$%$%$%$%$%$%$%$% SRAM_Stats $%$%$%$%$%$%$%$%$%$%$%$%$%$$%$%$%$
%$
%$ Calculates SNM & Pr(bit-errors) from raw data or a .mat workspace
%$ 
%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%
function [Hold, Read, Write, vdd, temp] = SRAM_Stats(filesDir)              % Function Definition 
  set(0,'defaulttextinterpreter','Latex');                                  % Text interpreter
  set(0,'defaultaxesfontsize', 20);                                         % Set axis font size
  set(0,'defaulttextfontsize', 20);                                         % Set text font size  
  format long;

  if (isdir(filesDir))                                                      % Check input is a directory
    [SNMh, SNMr, SNMw, vdd, temp] = noiseMargins(filesDir);                 % Calculate noise margins from *.csv in filesDir
  else                                                                      % Otherwise skip calculating SNMs
    load (filesDir);                                                        % and just load the workspace
  end
  
  Hold  =   multBE(SNMh);                                                   % Hold stats  [nxmx6]
  Read  =   multBE(SNMr);                                                   % Read stats  [nxmx6]
  Write =   multBE(SNMw);                                                   % Write stats [nxmx6] 
  
  %% Plot SNM's
  surf(vdd, temp, Hold(:,:,1)); hold on; grid on;
  surf(vdd, temp, Read(:,:,1));
  surf(vdd, temp, Write(:,:,1));
  xlabel('$V_{DD}$ [mV]');
  ylabel('$Temperature$ [C]');
  zlabel('$SNM$ [V]');
  
  %% Plot Error Probabilities
  %plotError(Read, vdd, temp);
  %plotError(Wite, vdd, temp);
  %plotError(Hold, vdd, temp);
end                                                                         % End Function
%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%
%% $%$%$%$%$%$%$ Probability of multiple Bit Errors %$%$%$%$%$%$%$%$%$%$%$%$%
%$
%$ SNM   = 2D matrix [mxn] of static noise margins.
%$ stats = 3D matrix [mxnx6]  SNM, Pr0errs, Pr1Error, etc 
%$  
%$$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$
function [Stats] = multBE(SNM)                                              % Function definition  
  bSize = 72;                                                               % Block size
  sigma = 50E-18;                                                           % Used to normalize SNM*C
  C     = 4.55E-16;                                                         % Ideal capacitance for better outputs 
% C     = 1.175E-16;                                                        % Measured Capacitance
  
  BE0   = PnBE (SNM, 0, bSize, sigma, C);                                   % Probability of 0 bit errors
  BE1   = PnBE (SNM, 1, bSize, sigma, C);                                   % Probability of 1 bit errors
  BE2   = PnBE (SNM, 2, bSize, sigma, C);                                   % Probability of 2 bit errors
  BE3   = PnBE (SNM, 3, bSize, sigma, C);                                   % Probability of 3 bit errors
  BE4p  = 1 - (BE3 + BE2 + BE1 + BE0);                                      % Probability of 4+ bit errors
  
  %% Setup 3D matrix to return
  Stats(:,:,1) = SNM; 
  Stats(:,:,2) = BE0;
  Stats(:,:,3) = BE1;
  Stats(:,:,4) = BE2;
  Stats(:,:,5) = BE3;
  Stats(:,:,6) = BE4p;
end
%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&&
%% $%$%$%$%$%$%$%$%$% Probability of n bit Errors $%$%$%$%$%$%$%$%$%$%$%$%$
%$  
%$ Computes the Probability of N-bit errors occuring for a given blocksize
%$ 
%$$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%
function PErr = PnBE(SNM, nErrors, bSize, sig, cap)                        % Probability of n bit errors
  digits(2^5);                                                             % Set Matlab Precision
  dQ   =  vpa( cap.*SNM );                                                 % delta Q
  Y    =  vpa( erfc(dQ./sig) );                                            % dQ normalized by sigma
  nck  =  vpa( nchoosek(bSize,nErrors) );                                  % 
  PErr =  vpa (nck.*(Y.^nErrors).*((1-Y).^(bSize-nErrors)) );              % Calculate the probability
end                                                                        % End Function
%% %&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&
%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&&
%% $%$%$%$%$%$%$%$%$% Plot Probability of n Errors $%$%$%$%$%$%$%$%$%$%$%$%$
%$  
%$ Plot the probability of Error
%$    SNM is an nxmx6 array
%$$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%
function plotError(SNM, vdd, temp)                                          % Plot the probabilitieis
  shading(gca,'interp');
  
  figure(1);
  colormap hsv;
  grid on;
  surf(vdd, temp, SNM(:,:,2));                                              % Plot  Pr(0 Errors) for hold vs. vdd vs temp
  xlabel('$V_{DD}$ [mV]');
  ylabel('$Temperature$ [C]');
  zlabel('$P_R$');
  title('Probability of 0 bit errors vs. $V_{DD}$ vs. $Temperature$');
  
  figure(2);
  surf(vdd, temp, SNM(:,:,3));                                             % Plot  Pr(1 Errors) for hold vs. vdd vs temp
  colordef black;
  colormap hsv;
  grid on;
  xlabel('$V_{DD}$ [mV]');
  ylabel('$Temperature$ [C]');
  zlabel('$P_R$');
  
  figure(3);
  surf(vdd, temp, SNM(:,:,4));                                             % Plot  Pr(1 Errors) for hold vs. vdd vs temp
  colordef black;
  colormap hsv;
  grid on;
  xlabel('$V_{DD}$ [mV]');
  ylabel('$Temperature$ [C]');
  zlabel('$P_R$');
  
  figure(4);
  surf(vdd, temp, SNM(:,:,5));                                             % Plot  Pr(1 Errors) for hold vs. vdd vs temp
  colordef black;
  colormap hsv;
  grid on;
  xlabel('$V_{DD}$ [mV]');
  ylabel('$Temperature$ [C]');
  zlabel('$P_R$');
  
  figure(5);
  surf(vdd, temp, SNM(:,:,6));                                             % Plot  Pr(1 Errors) for hold vs. vdd vs temp
  colordef black;
  colormap hsv;
  grid on;
  xlabel('$V_{DD}$ [mV]');
  ylabel('$Temperature$ [C]');
  zlabel('$P_R$');  
end                                                                        % End Function
%% %&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&
%%$%$%$%$%$%$%$%$%$%$ Calculate Noise Margins $%$%$%$%$%$%$%$%$%$%$%$%$%$
%$ Example Usage:   
%$
%$ [SNMH, SNMR, SNMW, vdd, temp] = noiseMargins('~/Desktop/SNMdata/');
%$ surf(vdd,temp,SNMH); hold on; surf(vdd,temp,SNMR); surf(vdd,temp,SNMW);
%$
%$ Function Returns:
%$          vdd     = length m vector   
%$          temp    = length n vector
%$          SNMR    = [m x n] array         
%$          SNMH    = [m x n] array
%$          SNMW    = [m x n] array
%$  
%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%%
function [SNMh, SNMr, SNMw, vdd, temp] = noiseMargins(filesDir)
  if ~strcmp(filesDir(end),'/')                                             % Check for the '/' at the end of the path
    filesDir = [filesDir '/'];                                              % Put it in if its not there
  end
  
  files = dir([filesDir '*.csv']);                                          % Only look at csv files in the directory
  nRuns = size(files,1);                                                    % Number of simulation runs. Each run = different temp
  temp  = zeros(1,nRuns);                                                   % Allocate temperature array
  vdd   = zeros(1,nRuns);                                                   % Allocate vdd array
  
  %% Determine voltage/temperature vector sizes
  wB     = waitbar(0,sprintf('Sorting %d files...', nRuns));                % Start the waitbar
  for  i = 1:nRuns                                                          % For each run
    file = [filesDir '/' files(i).name];                                    % Get the full file path
    [vdd(i), temp(i)] = titleParse(file);                                   % Make a list of all the vdd's & temp's
  end                                                                       % End for 
  
  vdd  = unique(vdd);                                                       % Sort and remove duplicates
  temp = unique(temp);                                                      % Sort and remove duplicates
  
  %% Allocate arrays based on voltage/temp vectors
  SNMh = zeros(length(temp), length(vdd));                                  % Prealloc 2D array
  SNMr = zeros(length(temp), length(vdd));                                  % Prealloc 2D array
  SNMw = zeros(length(temp), length(vdd));                                  % Prealloc 2D array
  
  %% Extract Noise Margins & fill in the arrays
  waitbar(0,wB,'Extracting Static Noise Margins...');   
  for  i = 1:nRuns                                                          % For each sim run  

    file = [filesDir '/' files(i).name];                                    % Get the full file path   
    [vrun, trun] = titleParse(file);                                        % Get the vdd and temp of the run
    [~, vI]      = find(vdd == vrun);                                       % Get vdd index
    [~, tI]      = find(temp == trun);                                      % Get temp index  
    
    %Use parfeval() to multithread this eventually
    [SNMh(tI,vI), SNMr(tI,vI), SNMw(tI,vI)] = noiseMargin(file, 0);         % Calculate satic noise margin
    wBtext = sprintf('Extracting Noise Margins %d / %d', i, nRuns);         % Waitbar text
    waitbar(i/nRuns, wB, wBtext);                                           % Update waitbar
  end                                                                       % End for   
  close(wB);                                                                % Close waitbar
  delete(wB);                                                               % Delete the waitbar
end                                                                         % End Function
%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&&%&
%% $%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%
function[SNMH, SNMR, SNMW] =  noiseMargin(file, enPlot)                     % Function Definition
%% Data Parsing
A       = importdata(file);                                                 % Time, nVtc, SNMh, SNMr SNMw0 
tCurves = [A.data(:,2),A.data(:,3),A.data(:,4),A.data(:,5)];                % test curves, just care about nvtc, SNMh, SNMr SNMw0 
nVTC    = tCurves(:,1);                                                     % nodeVector - vddRun transfer characteristic
nSNMh   = tCurves(:,2)`;                                                     % nodeVector - Static noise margin hold
nSNMr   = tCurves(:,3);                                                     % nodeVector - Static noise margin write
nSNMw   = tCurves(:,4);                                                     % nodeVector - Static noise margin write 0

%% Static Noise Margin Calculation
  SNMH = calcLargestSquare(nVTC, nSNMh);                                    % Calculate largest square in the 'eye'
  SNMR = calcLargestSquare(nVTC, nSNMr);                                    % Calculate largest square in the 'eye'
  SNMW = calcLargestSquare(nVTC, nSNMw);                                    % Calculate largest square in the 'eye'

  if (enPlot)  
    [vddRun, tempRun] = titleParse(file);                                   % Grab vdd and temperature from the title
    [SNMH, maxPointMatrix, bMax] = findLargestSquare(nVTC, nSNMh, vddRun);  % Search for largest square in the 'eye'
    SNMPlot(nVTC, nSNMh, vddRun, tempRun, SNMH, maxPointMatrix, bMax, 1);   % Plot
  
    [SNMR, maxPointMatrix, bMax] = findLargestSquare(nVTC, nSNMr, vddRun);  % Search for largest square in the 'eye'
    SNMPlot(nVTC, nSNMr, vddRun, tempRun, SNMR, maxPointMatrix, bMax, 2);   % Plot
  
    [SNMW, maxPointMatrix, bMax] = findLargestSquare(nVTC, nSNMw, vddRun);  % Search for largest square in the 'eye'
    SNMPlot(nVTC, nSNMw, vddRun, tempRun, SNMW, maxPointMatrix, bMax, 3);   % Plot
  end                                                                       % End If
  
end                                                                         % End Function
%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&&%&
%% $%$%$%$%$%$%$%$%$%$%$%$%$%$%$ Title Parsing $%$%$%$%$%$%$%$%$%$%$%$%$%$%$%
function [vdd, temp] = titleParse(file)
  [~, fname, ~] = fileparts (file);                                         % Separate the file path
  s1   = strsplit(fname, {'_','C'},'CollapseDelimiters',true);              % Split file name to extract the vdd and tempRunerature of the run
  s2   = strsplit(s1{2}, 'mV','CollapseDelimiters',true);                   % Split it again for vdd
  temp = str2double(s1{1});                                                 % Temperature of the run
  vdd  = str2double(s2{1});                                                 % vdd of the Run
end
%%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&
%% %$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$
function [sideLength, maxPointMatrix, bMax] = findLargestSquare(X, Y, vddRun)
  vdd = vddRun/1000;
  vBase = 0:0.1:vdd;
  maxDist = 0;
  for b=-vdd:.01:vdd
    y=vBase+b;
    [x1,y1]=intersections(X,Y,vBase,y);
    [x2,y2]=intersections(Y,X,vBase,y);
    pointmatrix=[x1,y1;x2,y2];
    dist=pdist(pointmatrix);
    if dist > maxDist
        maxDist=dist;
        maxPointMatrix=pointmatrix;
        bMax=b;
    end
  end
  sideLength=maxDist/sqrt(2);
end
%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&&%&
%% $%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Algorithm from paper titled:
% "The Static Noise Margin of SRAM cells" 1986
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function sideLength = calcLargestSquare(X, Y)                               % Analytical method
  R  = [cos(pi/4), -sin(pi/4); sin(pi/4) cos(pi/4)];                        % Rotation Matrix (45 degrees)
  M  = [0 1; 1 0];                                                          % Mirror Matrix
  U1 = [X'; Y'];                                                            % 2xn vector to hold X, Y
  U2 = [Y'; X'];                                                            % 2xn vector to hold Y, X
  V1 = R*M*U1;                                                              % Rotate mirrored version of X by 45 degrees
  V2 = R*M*U2;                                                              % Rotate mirrored inverse of X by 45 degrees
  V  = V2-V1;                                                               % To find largest diagonal, just subtract
  diag1 = max(V(1,:))/sqrt(2);                                              % Then look at the local maxima
  diag2 = abs(min(V(1,:)))/sqrt(2);                                         % and absolute value of local minima
  sideLength = min(diag1,diag2);                                            % Use the smaller of the two     
end                                                                         % End Function
%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&&%&
%% $%$%$%$%$%$%$%$%$%$%$%$%$ Plot Noise Margins %$%$%$%$%$%$%$%$%$%$%$%$%$%$%
function SNMPlot(X, Y, vddRun, tempRun, SNM, maxPointMatrix, bMax, HoldReadorWrite)  
  if HoldReadorWrite==1
    titleString=strcat('$SNM _{Hold}$');
  elseif HoldReadorWrite==2
    titleString=strcat('$SNM_{Read}$');
  elseif HoldReadorWrite==3
    titleString=strcat('$SNM_{Write}$');
  else display ('RWorHold must equal 1, 2, or 3!'); exit 1;
  end
  
  vdd = vddRun/1000;
  vBase = 0:0.1:vdd; 
  subplot(3,1,HoldReadorWrite);

  plot(X,Y,vBase,vBase-bMax, Y,X); 
  titleString=[titleString ' @ ' num2str(vddRun) 'mV, ' num2str(tempRun) 'C = ' num2str(SNM)];
  title(titleString);
  axis([0 vdd 0 vdd]);
  rectY=min(maxPointMatrix(1,1),maxPointMatrix(2,1));
  rectX=min(maxPointMatrix(2,2),maxPointMatrix(1,2));
  rectangle('Position',[rectX,rectY,SNM,SNM])
  hold off;

end
%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&&%&