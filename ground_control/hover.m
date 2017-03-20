function [] = hover
global pos_des pos_vicon
pos_des = pos_vicon;
fprintf('hover at: [%2.3f \t%2.3f \t%2.3f]\n',pos_des(1),pos_des(2),pos_des(3));
end
