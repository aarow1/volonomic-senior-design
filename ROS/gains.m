function [] = gains(in_gains)
% sends new attitude gains to VI
% INPUT: [tau_att tau_w] 1x2 array
sendPkt([],[],in_gains);
disp('gains',in_gains);
end

