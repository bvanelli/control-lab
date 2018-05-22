clear all
a = control_arduino('COM9','UNO','A0',1);


ref = 50
k = 1
tic
for i = 1:3000
    
    temp(i) = a.getOneWireTemperature();
    
    error(i) = ref - 24 - (temp(i) - 24);
    
    cont(i) = k*error(i);
    
    a.writePWMVoltage('D9',cont(i));
    t(i) = toc;
    plot(t,temp)
end



