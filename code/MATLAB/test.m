%% Instrument Connection
% obj1 = visadev('USB0::0x0483::0x7540::SPD3XHCD3R5160::0::INSTR')

% % Find a VISA-USB object.
% obj1 = instrfind('Type', 'visa-usb', 'RsrcName', 'USB0::0x0483::0x7540::SPD3XHCD3R5160::0::INSTR', 'Tag', '');
% 
% % Create the VISA-USB object if it does not exist
% % otherwise use the object that was found.
% if isempty(obj1)
%     obj1 = visa('NI', 'USB0::0x0483::0x7540::SPD3XHCD3R5160::0::INSTR');
% else
%     fclose(obj1);
%     obj1 = obj1(1);
% end
% 
% % Connect to instrument object, obj1.
% fopen(obj1);

% % Disconnect from instrument object, obj1.
% fclose(obj1);

% Example commands:

% % Turn Channels on and off
% fprintf(obj1, 'OUTPut CH1, ON');
% fprintf(obj1, 'OUTPut CH1, OFF');
% 
% % Select the channel that will be operated
% fprintf(obj1, 'INSTRUMENT CH1');
% % Query the current operating channel
% fprintf(obj1, 'INSTRUMENT?');
% fscanf(obj1)
% 
% % Select the Operation Mode,
% % 0: Independant, 1: Series, 2: Parallel
% fprintf(obj1, 'OUTPut:TRACK 1');
% 
% % Set Voltage to 13.37 V
% fprintf(obj1, 'CH1:VOLTage 13.37');
% 
% % Set Current limit to 2.5 A
% fprintf(obj1, 'CH2:CURRent 2.5');
% 
% % Read Set Voltage
% fprintf(obj1, 'CH1:VOLTage?');
% U1 = str2double(fscanf(obj1))
% 
% % Read Set Current
% fprintf(obj1, 'CH1:CURRent?');
% I1 = str2double(fscanf(obj1))
% 
% % Measure actual Voltage
% fprintf(obj1, 'MEAsure:VOLTage? CH1');
% U1 = str2double(fscanf(obj1))
% 
% % Measure actual Current
% fprintf(obj1, 'MEAsure:CURRent? CH1');
% I1 = str2double(fscanf(obj1))





%% Arduino Setup
% serialportlist("available");

clear
arduinoObj = serialport("COM6",9600)
configureTerminator(arduinoObj,"CR/LF");
arduinoObj.UserData = struct("Data",[],"Count",1)
% configureCallback(arduinoObj,"terminator",@readSineWaveData);

tic
arduinoObj.UserData.VoltageData = timeseries([],"Name",'Voltage');%('Name','Voltage');
arduinoObj.UserData.RPMData = timeseries([],"Name",'RPM');%('Name','RPM');

configureCallback(arduinoObj,"terminator",@readDynoData);






function readDynoData(src,~)

    % Read the ASCII data from the serialport object.
    data = readline(src);

    % Convert the string data to numeric type and save it in the UserData
    % property of the serialport object.
    data = split(data);
    data = str2double(data);
    src.UserData.Data(:,end+1) = data;

    src.UserData.VoltageData = addsample(...
        src.UserData.VoltageData,"Data",data(1),"Time",toc);

    src.UserData.RPMData = addsample(...
        src.UserData.RPMData,"Data",data(2),"Time",toc);


    src.UserData.Count = src.UserData.Count + 1;

    if src.UserData.Count > 1001
        configureCallback(src, "off");
    end


end



function readSineWaveData(src, ~)

% Read the ASCII data from the serialport object.
data = readline(src);

data = split(data);


% src.UserData.Data(:,end+1) = str2double(data);


if src.UserData.Count > 1001
    configureCallback(src, "off");
end




% % Update the Count value of the serialport object.
% src.UserData.Count = src.UserData.Count + 1;
% 
% % If 1001 data points have been collected from the Arduino, switch off the
% % callbacks and plot the data.
% if src.UserData.Count > 1001
%     configureCallback(src, "off");
%     hold on
%     plot(src.UserData.Data(1,2:end));
%     plot(src.UserData.Data(2,2:end));
% end
end
