function [] = goTo(pos)
global pos_des pos_store pos_control_on
if pos_control_on
pos_des = pos;
% pos_now = pos_vicon;
% 
% []

fprintf('go to: [%2.2f \t%2.2f \t%2.2f]\n',pos_des(1),pos_des(2),pos_des(3));
end
end
