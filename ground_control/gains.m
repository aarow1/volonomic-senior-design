function [] = gains(in_gains)
% sends new attitude gains to VI
% INPUT: [tau_att tau_w] 1x2 array
global gains_store
gains_store.gains = [gains_store.gains; in_gains];
gains_store.time = [gains_store.time; datetime('now')];
sendPkt('gains');
fprintf('tau_att = %2.3f \ttau_w = %2.3f \tki_torque = %2.3f\n',in_gains(1),in_gains(2),in_gains(3))
end

