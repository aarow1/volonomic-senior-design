function [] = goToRelative_Rotation(delta)
global q_curr_vicon q_des
delta = deg2rad(delta);
eul_rot = eul2rotm([delta(3) delta(2) delta(1)], 'zyx');
q_des_rot = quat2rotm(q_des);

new_q_des_rot = eul_rot * q_des_rot;

q_des = rotm2quat(new_q_des_rot);

fprintf('global xyz rotation by: [%2.2f \t%2.2f \t%2.2f]\n',delta(1),delta(2),delta(3));
fprintf('go to quaternion: [%2.2f \t%2.2f \t%2.2f \t%2.2f]\n',q_des(1),q_des(2),q_des(3),q_des(4));
end


