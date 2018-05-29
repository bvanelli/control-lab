function [ t ] = getTemperature( sensor, addr )
%GETTEMPERATURE Summary of this function goes here
%   Detailed explanation goes here
% Reset the device, which is required before any operation. 
% Then, start conversion with command '44' and also turn on parasite power mode.
%     tic;
    reset(sensor);
    write(sensor, addr, hex2dec('44'), true); 

    % Make sure temperature conversion is done. This is necessary if all commands run continuosly in a script.
    pause(0.75);

    %%
    % Read the device's scratchpad memory which is consisted of eight data bytes and another byte of CRC, computed from the data bytes.
    reset(sensor);
    write(sensor, addr, hex2dec('BE')); % read command - 'BE'
    data = read(sensor, addr, 9);
    crc = data(9);
    %sprintf('Data = %x %x %x %x %x %x %x %x  CRC = %x\n', ...
    %    data(1), data(2), data(3), data(4), data(5), data(6), data(7), data(8), crc)
    if ~checkCRC(sensor, data(1:8), crc, 'crc8')
        error('Invalid data read.');
    end

    %%
    % Combine LSB and MSB of the temperature reading into one value using the
    % first and second byte of the scratchpad data. 
    raw = bitshift(data(2),8)+data(1);

    %%
    % Get the R0 and R1 bits in the config register, which is the fifth byte in
    % scratchpad data. R0 and R1 together determines the resolution
    % configuration.
    cfg = bitshift(bitand(data(5), hex2dec('60')), -5);
    switch cfg
        case bin2dec('00')  % 9-bit resolution, 93.75 ms conversion time
            raw = bitand(raw, hex2dec('fff8'));
        case bin2dec('01')  % 10-bit resolution, 187.5 ms conversion time
            raw = bitand(raw, hex2dec('fffC'));
        case bin2dec('10')  % 11-bit resolution, 375 ms conversion time
            raw = bitand(raw, hex2dec('fffE'));
        case bin2dec('11')  % 12-bit resolution, 750 ms conversion time
        otherwise           
            error('Invalid resolution configuration');
    end
    % Convert temperature reading from unsigned 16-bit value to signed 16-bit.
    raw = typecast(uint16(raw), 'int16');

    %%
    % Convert to the actual floating point value since the last bit of LSB
    % represents $2^{-4}$.
    t = double(raw) / 16.0;
   
end

