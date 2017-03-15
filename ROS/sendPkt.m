function [] = sendPkt(pkt_type, data)
global xbee q_curr_vicon q_des w_ff f_des
start_byte = 0; type_byte = 0; data = 0; end_byte = 0;
switch (pkt_type)
    case 'mot_spd'
        start_byte = 32;
        type_byte = 34;
        end_byte = 69;
    case 'vicon'
        if data
            start_byte = 32;
            type_byte = 33;
            end_byte = 69;
            
            data = [q_curr_vicon q_des w_ff f_des];
        else
            start_byte = 32;
            type_byte = 22;
            end_byte = 69;
            data = [q_des w_ff f_des];
        end
    case 'gains'
        start_byte = 32;
        type_byte = 15;
        end_byte = 69;
    otherwise
end
pkt = [start_byte type_byte data end_byte];
fwrite(xbee,pkt,'float32');
end

