function [] = estop()
% send motor speeds zero
sendPkt('mot_spd',zeros(1,6));
end

