function [] = gains(in_gains)
% sends new attitude gains to VI
% INPUT: [tau_att tau_w] 1x2 array
sendPkt([],[],in_gains);
fprintf('tau_att = %2.2f \ttau_w = %2.2f\n',in_gains(1),in_gains(2))
end

