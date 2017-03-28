function []  = land()
global pos_vicon pos_control_on pos_des
if pos_control_on
pos_des = [pos_vicon(1) pos_vicon(2) pos_vicon(3)-.1];
fprintf('taking off...\n');
end
end

