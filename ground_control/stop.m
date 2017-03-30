function [] = stop()
global send_vicon integral_1 f_des w_ff follow_traj
send_vicon = 0; 
follow_traj = 0;
set_motor_speeds('z');
pause(.01);
sendPkt('stop');
integral_1 = [0 0 0]; f_des = [0 0 0]; w_ff = [0 0 0];
fprintf('STOP\n');
end

            