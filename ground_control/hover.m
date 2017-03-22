function [] = hover
global pos_des pos_vicon q_curr_vicon q_des pos_control_on
q_des = q_curr_vicon;
fprintf('hover at q: \t[%2.3f \t%2.3f \t%2.3f \t%2.3f]\n', ...
    q_des(1), q_des(2), q_des(3), q_des(4));
if pos_control_on
pos_des = pos_vicon;
fprintf('hover at pos: \t[%2.3f \t%2.3f \t%2.3f]\n',pos_des(1),pos_des(2),pos_des(3));
end
end
