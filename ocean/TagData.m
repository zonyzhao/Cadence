function TagData(filesDir)                                                  % Function Definition 
  set(0,'defaulttextinterpreter','Latex');                                  % Text interpreter
  set(0,'defaultaxesfontsize', 20);                                         % Set axis font size
  set(0,'defaulttextfontsize', 20);                                         % Set text font size  

  if (isdir(filesDir))                                                      % Check input is a directory
    if ~strcmp(filesDir(end),'/')                                           % Check for the '/' at the end of the path
      filesDir = [filesDir '/'];                                            % Put it in if its not there
    end
    files = dir([filesDir '*.csv']);                                        % Only look at csv files in the directory
    nRuns = size(files,1);                                                  % Number of simulation runs. Each run = different temp
    temp  = zeros(1,nRuns);                                                 % Allocate temperature array
    vdd   = zeros(1,nRuns);                                                 % Allocate vdd array
  else                                                                      % 
    A = importdata (filesDir);                                              %
    vdd               = A.data(:,1);
    temp              = A.data(:,2);
    leakageCur        = A.data(:,3);
    leakagePwr        = A.data(:,4);
    peakCur           = A.data(:,5);
    peakPwr           = A.data(:,6);
    fwdReadLatency    = A.data(:,7);
    fwdReadEnergy     = A.data(:,8);
    revReadLatency    = A.data(:,9);
    revReadEnergy     = A.data(:,10);
    fwdWriteLatency   = A.data(:,14);
    fwdWriteEnergy    = A.data(:,15);
    revWriteLatency   = A.data(:,16);
    revWriteEnergy    = A.data(:,17);
    
    cycleReadLatency  = fwdReadLatency + revReadLatency;
    cycleReadEnergy   = fwdReadEnergy + revReadEnergy;
    cycelReadEDP      = cycleReadEnergy .* cycleReadLatency;
    
    cycleWriteLatency = fwdWriteLatency + revWriteLatency;
    cycleWriteEnergy  = fwdWriteEnergy + revWriteEnergy;
    cycelWriteEDP     = cycleWriteEnergy .* cycleWriteLatency;
    
    %%% Plot Leakage
    figure(1);
    plot(vdd, leakageCur, 'b'); hold on;
    plot(vdd, leakageCur, 'b*'); hold off;
    
    xlabel('$V_{DD}$ [mV]'); grid on;
    ylabel('Leakage Current [mA]')            
    title('Leakage Current vs. Supply Voltage');
    
    %%% Plot Leakage Power
    figure(2);
    plot(vdd, leakagePwr, 'b'); hold on;
    plot(vdd, leakagePwr, 'b*'); hold off;
    
    xlabel('$V_{DD}$ [mV]'); grid on;
    ylabel('Leakage Power [mW]')            
    title('Leakage Power vs. Supply Voltage');
    
    %%% Plot Forward Read/Write Latency
    figure(3);
    plot(vdd, fwdReadLatency, 'b'); hold on;
    plot(vdd, fwdWriteLatency, 'c'); 
    legend('Read', 'Write');
    plot(vdd, fwdReadLatency, 'b*'); 
    plot(vdd, fwdWriteLatency, 'c*'); hold off;
    xlabel('$V_{DD}$ [mV]'); grid on;
    ylabel('Forward Read/Write Latency [ps]')            
    title('Forward Read/Write Latency vs. Supply Voltage');
    
    %%% Plot Forward Read /Write Energy
    figure(4);
    plot(vdd, fwdReadEnergy, 'b'); hold on;
    plot(vdd, fwdWriteEnergy, 'c');
    legend('Read', 'Write'); 
    plot(vdd, fwdReadEnergy, 'b*'); 
    plot(vdd, fwdWriteEnergy, 'c*'); 
    xlabel('$V_{DD}$ [mV]'); grid on;
    ylabel('Forward Read / Write Energy [pJ]')            
    title('Forward Read / Write Energy vs. Supply Voltage');
    
    %%% Plot Reverse Read /Write  Latency
    figure(5);
    plot(vdd, revReadLatency, 'b'); hold on;
    plot(vdd, revWriteLatency, 'c'); 
    legend('Read', 'Write'); 
    plot(vdd, revWriteLatency, 'c*');
    plot(vdd, revReadLatency, 'b*'); hold off;
    xlabel('$V_{DD}$ [mV]'); grid on;
    ylabel('Reverse Read Latency [ps]')            
    title('Reverse Read Latency vs. Supply Voltage');
    
    %%% Plot  Read /Write  Cycle time
    figure(6);
    plot(vdd, cycleReadLatency, 'b'); hold on;
    plot(vdd, cycleWriteLatency, 'c'); 
    legend('Read', 'Write'); 
    plot(vdd, cycleWriteLatency, 'c*');
    plot(vdd, cycleReadLatency, 'b*'); hold off;
    xlabel('$V_{DD}$ [mV]'); grid on;
    ylabel('Cycle Time [ps]')            
    title('Cycle Time vs. Supply Voltage');
    
     %%% Plot Read / Write  Cycle Energy
    figure(7);
    plot(vdd, cycleReadEnergy, 'b'); hold on;
    plot(vdd, cycleWriteEnergy, 'c'); 
    legend('Read', 'Write'); 
    plot(vdd, revWriteEnergy, 'c*');
    plot(vdd, revReadEnergy, 'b*'); hold off;
    xlabel('$V_{DD}$ [mV]'); grid on;
    ylabel('Cycle Energy [ps]')            
    title('Cycle Energy vs. Supply Voltage');
    
     %%% Plot Read / Write  Cycle Energy
    figure(8);
    plot(vdd, cycelReadEDP, 'b'); hold on;
    plot(vdd, cycelWriteEDP, 'c'); 
    legend('Read', 'Write'); 
    plot(vdd, cycelReadEDP, 'c*');
    plot(vdd, cycelWriteEDP, 'b*'); hold off;
    xlabel('$V_{DD}$ [mV]'); grid on;
    ylabel('Cycle EDP [ps]')            
    title('Cycle EDP vs. Supply Voltage');
   
  end

end