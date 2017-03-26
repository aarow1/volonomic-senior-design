function [] = stop()
set_motor_speeds('z');
pause(.01);
sendPkt('stop');
global send_vicon integral_1 f_des w_ff 
send_vicon = 0; integral_1 = [0 0 0]; f_des = [0 0 0]; w_ff = [0 0 0];
fprintf('STOP\n');
end

            