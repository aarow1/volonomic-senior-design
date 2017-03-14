function [] = sendPkt(mot_spds)
if nargin == 1
    start_byte = 32;
    
    mot_spds_type_byte = 34;
    end_byte = 69;
    
    pkt = [start_byte mot_spds_type_byte mot_spds end_byte];
    
    fwrite(xbee,pkt,'float32');
else
    start_byte = 32;
    
    normal_type_byte = 33;
    end_byte = 69;
    
    pkt = [start_byte normal_type_byte q_curr_vicon q_des w_ff f_des end_byte];
    
    fwrite(xbee,pkt,'float32');
end

end

