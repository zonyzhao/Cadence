%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%
%$  Function to Import + plot Results for Async 32b adder
%$
%$  Example Usage:
%$   AsyncPlot('~/Desktop/simData/delaySweep/', '~/Desktop/simData/Asyncleakage.csv', '~/Desktop/simData/SyncLeakage.csv')
%% $%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%
function AsyncPlot(Async_dir, Async_leak, Sync_file)

 set(0,'defaulttextinterpreter','Latex');                                   % Text interpreter
 set(0,'defaultaxesfontsize', 20);                                          % Set axis font size
 set(0,'defaulttextfontsize', 20);                                          % Set text font size  
 shading(gca,'interp')
 
  files = dir([Async_dir '*.csv']);                                         % Only look at csv files in the directory
  nRuns = size(files,1);                                                    % Number of simulation runs. Each run = different vdd.
  vdd = 400:10:990;                                                         % Vdd array
  avgDelay = zeros(1,size(files,1));                                        % Pre-alloc to keep matlab happy
  nullDelay = zeros(1,size(files,1));
  maxDelay = zeros(1,size(files,1));
  varDelay = zeros(1,size(files,1));                                        % Delay variance
  numPts = zeros(1,size(files,1));                                          % Number of delay measurments
  
  minPts = inf;                                                             % Hold minimum number of points
  for i=1:nRuns                                                             % For each csv file
      if vdd(i)==520                                                        % If voltage is NTV
        Dataset(i)=AsyncImport([Async_dir '/' files(i).name],1);            % Import Async delay data, plot for NTV
      else
        Dataset(i)=AsyncImport([Async_dir '/' files(i).name],0);            % Import Async delay data
      end
      delay=Dataset(i).delay(1:2:end);                                      % Remove the null delays
      null=Dataset(i).delay(2:2:end);
      numPts(i) = length(delay);
      if (numPts(i) < minPts)                                               % Keep track of minimum measuremnets taken
          minPts=numPts(i);
      end
      avgDelay(i) = mean(delay);                                            % avdDelay
      varDelay(i) = var(delay);                                             % variance of delay
      nullDelay(i) = mean(Dataset(i).delay(2:2:end));                       % average null delay
      avgTotDelay(i) = mean(delay(1:length(null))+null);
      maxDelay(i) = max(delay);                                             % worst case delay
      maxTotDelay(i) = max(delay(1:length(null))+null);                     % Worse case including null
  end
  
  tau = zeros(minPts,nRuns);                                                % Prealloc
  for i=1:nRuns                                                             % Create matrix with sizing determined in from loop
    dlyMeas = Dataset(i).delay(1:2:end);                                    % Delay measured
    tau(:,i)=dlyMeas(1:minPts);                                             % Truncate measurements so all instances have an equal number taken
  end
 
  [AsyncLeakage, SyncLeakage] = importLeakage(Async_leak, Sync_file);       % Leakage for Async + Sync + Delay for Sync
  AsyncLeakage = AsyncLeakage(:,1:nRuns);                                   % Make sure same number of points for all
  SyncLeakage = SyncLeakage(:,1:nRuns);
  
  
  %% Figure 2
  figure (2);                                                               % Figure 2
  colordef black; grid on; hold on;
  plot(vdd,avgDelay, 'b*');
  plot(vdd, nullDelay, 'm*');                                               % Plot average null delay
  plot(vdd, maxDelay, 'r');                                                 % Plot average max delay
  plot(vdd, sqrt(varDelay), 'g');                                           % Plot the standard dev of delay vs. voltage.
  
  for i=1:length(tau);                                                      % For each measurement @ dist. i
    plot(vdd,tau(i,:), 'c:');                                               % Plot all measurements vs. distance
    hold on;                                                                % On the same graph
  end                                                                       % End Loop
  
  legend('Average Delay', 'Average Null Delay', 'Worst-case Delay',...
         'Std-dev Delay', 'Measured Delay');
  
  % Have to replot curves over measurements                                 % need to plot twice so legend cooperates
  plot(vdd,avgDelay, 'b*');
  plot(vdd, nullDelay, 'm*');                                               % Plot average null delay
  plot(vdd, maxDelay, 'r');                                                 % Plot average max delay
  plot(vdd, sqrt(varDelay), 'g');                                           % Plot the standard dev of delay vs. voltage.

  yL = get(gca,'YLim');                                                     % Cut the y axis @10k psec if necessary
  if (max(yL) > 10E3)                                                       
      ylim([min(yL) 10000]);
  end
  
  line([850 850],yL,'Color','g');                                           % Reference Vdd and NVth lines
  line([525 520],yL,'Color','r');
  
  xlabel('$V_{dd}$ [mV]');
  ylabel('Measured Delay [ps]');
  title(['Measured  Delay vs. $V_{dd}$ for Martin Adder'...
      '[32bit, 16nm, LSTP, ~1000 vectors/V ]']);
  hold off;
  saveFig(2);
  
  %% Figure 3 - leakage 
  figure(3); grid on; hold on;
  plot(vdd, AsyncLeakage(2,:),'g');
  plot(vdd, SyncLeakage(2,:),'b');
  line([850 850],yL,'Color','g');                                           % Reference Vdd and NVth lines
  line([525 520],yL,'Color','r');
  ylim([0 max(AsyncLeakage(2,:))])
  xlabel('$V_{dd}$ [mV]');
  ylabel('Measured Leakage [nA]');
  title(['Measured  Leakage vs. $V_{dd}$ for 32b Adders]'...
         '[Martin vs Manchester, 16nm, LSTP]']);
  hold off;
  legend('Async Martin Leakage', 'Sync Manchester Leakager');
  saveFig(3);
  
    %% Figure 24
  figure (4);                                                               % Figure 4
  colordef black; grid on; hold on;
  plot(vdd,avgTotDelay, 'g*');                                              % Plot average total delay=avg(null+delay)
  plot(vdd, maxTotDelay, 'r*');                                             % Plot maximum total delay including null                                 
  plot(vdd, SyncLeakage(3,:), 'b*');
  
  legend('Average Total Async Delay', 'Worse Case Async Delay', 'Synchronous Worst Case');
  yL = get(gca,'YLim');                                                     % Cut the y axis @10k psec if necessary
  if (max(yL) > 10E3)                                                       
      ylim([min(yL) 10000]);
  end
  
  line([850 850],yL,'Color','g');                                           % Reference Vdd and NVth lines
  line([525 520],yL,'Color','r');
  
  xlabel('$V_{dd}$ [mV]');
  ylabel('Measured Delay [ps]');
  title(['Avg + Worst-case Delay vs. $V_{dd}$ for Async + Sync Adders]'...
         '[32bit, Martin vs Manchester, 16nm, LSTP]']);
  hold off;
  saveFig(4);

end                                                                         % End Function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Dataset = AsyncImport(delayFile, enPlot)                           % Function definition
  fileID = fopen(delayFile); 
  formatspec = ['%s %s %s %s %s %s %s %s %s %s %f %f'];                     % Import delay pattern

  dData = textscan(fileID, formatspec, 'Delimiter', ...                     % Import the data
             ',','HeaderLines', 0);
  dHeaders = {'at', 'af', 'bt', 'bf', 'ct', 'cf',  ...                      % Data Headers
            'st', 'sf', 'dt', 'df', 'time', 'delay'};
  fclose(fileID);     
  
  for i=1:length(dHeaders)                                                 
    if i<=10                                                                % If it's a string, don't convert to matrix
      Dataset.(dHeaders{i})=char(dData{1,i});                               % Convert string to hex string
    else                                                                    % Otherwise convert to 1xN matrix
      Dataset.(dHeaders{i}) = cell2mat(dData(:,i));
    end
  end
if (enPlot==1)
  delay   = Dataset.delay(1:2:end);                                         % Remove null delays measured 
  [n, x]  = hist(delay, 50);  
  n       = n / length(delay) / diff( x(1:2) );
  mu      = mean(delay);
  sig     = std(delay);

  figure(1); 
  bar(x,n, 'FaceColor', 'c'); hold on
  plot(x,normpdf(x,mu,sig), 'g');
  %xlim([0 1000]);
 
  [F, XI] = ksdensity(delay);
  plot(XI, F, 'b');
 
  mu2   = mean(log(delay));
  sig2  = std(log(delay));
  ix    = linspace(min(delay),max(delay)); 
  iy    = pdf('lognormal', ix, mu2, sig2); 
  plot(ix,iy,'r');
  
  grid on;
  xlabel('Delay [ps]');
  ylabel('Probability');
  title('Measured + Fitted Delay PDF for NTV Martin Adder [32bit 16 nm LSTP 520mV]')
  legend('Measured', 'Fitted-Normal', 'KS-Density estimate', 'Fitted-LogNormal'); 
  saveFig(1);    
 
  hold off;
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% $%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%$%%$%$%$%$%$%%$%$%$%$%$%$%$%$%
function [Async, Sync] =importLeakage(AsyncFile, SyncFile)
  % Asyncrhonous import
  fileID = fopen(AsyncFile); 
  formatspec = ['%f %f'];                                                  % Import pattern

  Data = textscan(fileID, formatspec, 'Delimiter', ...                     % Import the data
             ',','HeaderLines', 1);
  lHeaders = {'voltage', 'leakage'};
  fclose(fileID);         
  
  for i=1:length(lHeaders)                                                 
      Dataset.(lHeaders{i}) = cell2mat(Data(:,i));
  end
  
  Async(1,:)=Dataset.voltage;
  Async(2,:)=Dataset.leakage;
  
  % Start Syncronous data import
  fileID = fopen(SyncFile); 
  formatspec = ['%f %f %f'];                                               % Import pattern

  Data = textscan(fileID, formatspec, 'Delimiter', ...                     % Import the data
             ',','HeaderLines', 1);
  lHeaders = {'voltage', 'leakage', 'delay'};
  fclose(fileID);         
  
  for i=1:length(lHeaders)                                                 
      Dataset.(lHeaders{i}) = cell2mat(Data(:,i));
  end
  
  Sync(1,:) = Dataset.voltage;
  Sync(2,:) = Dataset.leakage;
  Sync(3,:) = Dataset.delay;
  
end
%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&&%&
%% $%$%$%$%$%$%$%$%$%$%$ saveFigure %$%$%$%$%$%$%$%$%$%$%$%$%%$%$%$%$%$%%$%$%
function saveFig(varargin)                                                  % Function: Save Figure
    grid on;                                                                % Set Plot Grid On
    set(gcf, 'PaperPositionMode', 'auto');                                  % Set PaperPositionMode to auto
    set(gcf, 'PaperSize', [16 9]);                                          % Set paper to width 16 and height 9.
    set(gcf, 'PaperPosition', [0 0 16 9]);                                  % Position plot at left hand corner
    set(gcf, 'InvertHardCopy', 'off');                                      % Save Figure with Black Background
    if (nargin>1)                                                           % If Legend Handle passed in
        set(varargin{2},'Position', [.7 .8 .24 .05]);                       % Set Legend Position
    end                                                                     % End if
    if ischar(varargin{1})                                                  % Check for save title
        sName = strcat(varargin{1},'');                                     % Set savename from argument
    else                                                                    % Otherwise
        sName = sprintf('Fig %d', varargin{1});                             % Call Figure 'Figure #'
    end                                                                     % End If
    print('-depsc',sName)                                                   % Save as post-script file
    %saveas(gcf, sName, 'pdf')                                              % Save figure
end                                                                         % End Function
%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&%&&%&
