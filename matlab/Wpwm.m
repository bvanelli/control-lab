
function Rsensor_Wpwm(block)
%%
% This block write the input value to the PWM at the digital port 9  
% using the input paramiter to define the sampling time
setup(block);
end


function setup(block)
block.NumInputPorts  = 1;

block.NumOutputPorts = 0;

block.NumDialogPrms  = 1;

% Entrada
block.InputPort(1).Dimensions  = 1;
block.InputPort(1).DatatypeID  = 0;  % double
block.InputPort(1).Complexity  = 'Real';
block.InputPort(1).DirectFeedthrough = false;



%%
% Register parameters

param_var = get_param(block.BlockHandle,'UserData');

Ts = block.DialogPrm(1).Data{4};   

block.SampleTimes = [Ts 0]; % define de Sampling Time
block.RegBlockMethod('Start', @Start); % inicialization
block.RegBlockMethod('Outputs', @Outputs);     % Required
block.RegBlockMethod('Terminate', @Terminate); % Required


end

function Start(block)


ard = arduino(block.DialogPrm(1).Data{1},block.DialogPrm(1).Data{2});
set_param(gcb,'UserData',ard);
end



function Outputs(block)
%% Output 


tic; % for time control

% Get the Paramiters
param_var = get_param(block.BlockHandle,'UserData');

% Saturator
if block.InputPort(1).Data > 5
    
    value = 5;
elseif block.InputPort(1).Data < 0
    
    value = 0;
else
    
   value =  block.InputPort(1).Data;
end

% Write the PWM - port 9
param_var.writePWMVoltage(block.DialogPrm(1).Data{3}, value);


% Wait until Ts;
while toc<block.DialogPrm(1).Data{4}
    
end

end


%% clear all variables
function Terminate(block)
param_var = get_param(block.BlockHandle,'UserData');
clear param_var 
param_var = 1;
set_param(gcb,'UserData',param_var);

end% Terminate