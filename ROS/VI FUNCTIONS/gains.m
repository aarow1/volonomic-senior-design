function [] = gains(in_gains)
% sends new attitude gains to VI
% INPUT: [in_gains] 1x3 array
sendPkt([],[],in_gains);
disp('gains',in_gains);
end

