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

%% Normal INPUT

start_byte = 32;

normal_type_byte = 33;
att_curr = [.6649 .3300 -.1876 -.6432]; 
att_des = [0 1 0 0]; 
omegadot_des = [0 0 0];
forcelin_des = [0 0 0]; 

end_byte = 69;

pkt = [start_byte normal_type_byte att_curr att_des omegadot_des forcelin_des end_byte];
% pkt = [12, 15, 2];

fwrite(xbee,pkt,'float32');

%% Motor speeds INPUT

start_byte = 32;

mot_spds_type_byte = 34;
mot_spds = [-50, 50, 50, -50, 50, 0];
end_byte = 69;

pkt = [start_byte mot_spds_type_byte mot_spds end_byte];

fwrite(xbee,pkt,'float32');

%% estop INPUT

start_byte = 32;

mot_spds_type_byte = 34;
mot_spds = [0, 0, 0, 0, 0, 0];
end_byte = 69;

pkt = [start_byte mot_spds_type_byte mot_spds end_byte];

fwrite(xbee,pkt,'float32');

%% Shitty input
pkt = [32, 34, 2];

fwrite(xbee,pkt,'float32');


