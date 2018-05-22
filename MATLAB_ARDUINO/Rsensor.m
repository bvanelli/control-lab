
function Rsensor(block)
%%
% This block read the value of a One wire sensor conected to the Analog 0   
% using the input paramiter to define the sampling time
setup(block);
end


function setup(block)
block.NumInputPorts  = 0;

block.NumOutputPorts = 1;

block.NumDialogPrms  = 1;

block.OutputPort(1).Dimensions  = 1;
block.OutputPort(1).DatatypeID  = 0; % double
block.OutputPort(1).Complexity  = 'Real';
block.OutputPort(1).SamplingMode = 'sample';

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


tic; % for time control

% Get the Paramiters
param_var = get_param(block.BlockHandle,'UserData');

% Define the output
block.OutputPort(1).Data = param_var.getOneWireTemperature();

% Wait until Ts;
while toc< param_var.Ts
    
end


end


%% clear all variables
function Terminate(block)
param_var = get_param(block.BlockHandle,'UserData');
clear param_var 
param_var = 1;
set_param(gcb,'UserData',param_var);

end% Terminate