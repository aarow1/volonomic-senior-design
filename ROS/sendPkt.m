function [] = sendPkt(mot_spds)
global xbee q_curr_vicon q_des w_ff f_des
start_byte = 0; type_byte = 0; data = 0; end_byte = 0;
if nargin == 1
    start_byte = 32;
    type_byte = 34;
    end_byte = 69;
    
    data = mot_spds;
else
    start_byte = 32;
    type_byte = 33;
    end_byte = 69;
    
    data = [q_curr_vicon q_des w_ff f_des];
end
    pkt = [start_byte type_byte data end_byte];
    fwrite(xbee,pkt,'float32');
end

% 
