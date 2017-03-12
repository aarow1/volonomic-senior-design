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

start_byte = [32];
att_curr = [1.23 2 3.14 -2.3]; 
att_des = [5 6 7 8]; 
omegadot_des = [9 10 11];
forcelin_des = [12 13 14]; 
end_byte = [26];

pkt = [start_byte att_curr att_des omegadot_des forcelin_des end_byte];
% pkt = [12, 15, 2];

fwrite(xbee,pkt,'float32');
