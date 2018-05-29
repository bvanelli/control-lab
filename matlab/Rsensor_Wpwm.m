
function Rsensor_Wpwm(block)
%%
% This block read the value of a One wire sensor conected to the Analog 0 and Write the input value to the PWM at the digital port 9  
% using the input paramiter to define the sampling time
setup(block);
end


function setup(block)
block.NumInputPorts  = 1;

block.NumOutputPorts = 1;

block.NumDialogPrms  = 1;

% Entrada
block.InputPort(1).Dimensions  = 1;
block.InputPort(1).DatatypeID  = 0;  % double
block.InputPort(1).Complexity  = 'Real';
block.InputPort(1).DirectFeedthrough = false;

% Saida do controlador
block.OutputPort(1).Dimensions  = 1;
block.OutputPort(1).DatatypeID  = 0; % double
block.OutputPort(1).Complexity  = 'Real';


  
Ts = block.DialogPrm(1).Data{5};


    
block.SampleTimes = [Ts 0]; % define de Sampling Time
block.RegBlockMethod('Start', @Start); % inicialization
block.RegBlockMethod('Outputs', @Outputs);     % Required
block.RegBlockMethod('Terminate', @Terminate); % Required


end

function Start(block)


ard = control_arduino(block.DialogPrm(1).Data{1},block.DialogPrm(1).Data{2},block.DialogPrm(1).Data{3},block.DialogPrm(1).Data{4},block.DialogPrm(1).Data{5});
set_param(gcb,'UserData',ard);
end

function Outputs(block)
%% Output

% Get the Paramiters
ard = get_param(block.BlockHandle,'UserData');
% Write the PWM - port 9
ard.writePWMVoltage(block.InputPort(1).Data);




% Define the output
block.OutputPort(1).Data = ard.getOneWireTemperature();

end


%% clear all variables
function Terminate(block)
ard = get_param(block.BlockHandle,'UserData');
clear param_var 
ard = 1;
set_param(gcb,'UserData',ard);

end% Terminate