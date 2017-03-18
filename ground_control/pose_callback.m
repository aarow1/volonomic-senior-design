function [] = pose_callback(~,msg)
global q_curr_vicon pos_vicon pos_gains f_des

global pos_des
global pos_control_on
persistent err_prev int

T = toc;
q_curr_vicon(1) = msg.Pose.Orientation.X;
q_curr_vicon(2) = msg.Pose.Orientation.Y;
q_curr_vicon(3) = msg.Pose.Orientation.Z;
q_curr_vicon(4) = msg.Pose.Orientation.W;

pos_vicon(1) = msg.Pose.Position.X;
pos_vicon(2) = msg.Pose.Position.Y;
pos_vicon(3) = msg.Pose.Position.Z;

if pos_control_on
    err = pos_des - pos_vicon;
    der = (err-err_prev)/T;
    int = int + err*T;
    
    err_prev = err;
    
    vi_mass = .750;
    g = 9.8;
    
    f_des = sum(pos_gains.*[err' der' int'],2)' + [0, 0, (vi_mass*g)];
else
    f_des = [0 0 0];
end

sendPkt('all_inputs');

tic;
end

