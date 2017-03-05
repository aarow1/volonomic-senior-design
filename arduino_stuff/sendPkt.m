% ls /dev/tty.*
%% SETUP 
if ~isvalid(xbee)
xbee = serial('/dev/tty.usbserial-DN02MM5K')
set(xbee,'DataBits',8)
set(xbee,'StopBits',1)
set(xbee,'Parity','none')
set(xbee,'BaudRate',9600)
fopen(xbee);
end
%%curent attitude(4), des att(4), des angular rates(3), des linear force (3)

%% INPUT

att_curr = [1.23 3.14 1 0]; 
att_des = [0 0 0 0]; 
omegadot_des = [0 0 0];
forcelin_des = [0 0 0]; 
pkt = [att_curr att_des omegadot_des forcelin_des];

fwrite(xbee,pkt,'float32');
