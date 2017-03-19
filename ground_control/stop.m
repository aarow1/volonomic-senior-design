function [] = stop()
sendPkt('stop');
global send_vicon
send_vicon = 0;
end

