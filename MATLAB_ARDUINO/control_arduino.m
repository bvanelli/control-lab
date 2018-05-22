classdef control_arduino 
    %CONTROL_ARDUINO Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        Ts; 
        Arduino_Board
        OneWire_Sensor
        OneWire_Sensor_Addresse
        LastValue = 0;
        PwmPort
        
    end
    
    methods
        function obj = control_arduino(COM,Model,PwmPort,SensorPort,Ts)           
            
            %
            %Create arduino 
            obj.Arduino_Board = arduino(COM, Model, 'Libraries', 'PaulStoffregen/OneWire');  
            %Create one wire sensor
            obj.OneWire_Sensor = addon(obj.Arduino_Board, 'PaulStoffregen/OneWire', SensorPort);            
            obj.OneWire_Sensor_Addresse = obj.OneWire_Sensor.AvailableAddresses;                     
            % PWM control port
            obj.PwmPort = PwmPort;
            %sample Time
            obj.Ts = Ts;
        end
        
        function value = getOneWireTemperature(obj)
            tic
            try
                value = getTemperature( obj.OneWire_Sensor, obj.OneWire_Sensor_Addresse{1});
            catch
                warning('error reading temperature');
                value = obj.LastValue;
            end
            obj.LastValue = value;
            
            while toc < obj.Ts
                % wait until Ts;
            end    
                   
        end
        
        
        function  obj =  writePWMVoltage(obj,value)
            
            % Saturator
            if value > 5
                
                value = 5;
            elseif value < 0
                
                value = 0;            
            end
            
            value = 5 - value;
            
            obj.Arduino_Board.writePWMVoltage(obj.PwmPort,value);
            
        end  
        
        function obj = set.Ts(obj,Ts)
            
            if Ts < 1
                 warning('Sampling time is lower than sensor sample time, auto change to 1 second')
                 obj.Ts = 1;
            else
                obj.Ts = Ts; 
            end  
        end
        
          
    end
    
end

