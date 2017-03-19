function [] = pose_callback(~,msg)
global q_curr_vicon pos_vicon pos_gains f_des

global pos_des
global pos_control_on
persistent err_prev int

T = toc;
q_curr_vicon = [msg.Pose.Pose.Orientation.X;
    msg.Pose.Pose.Orientation.Y;
    msg.Pose.Pose.Orientation.Z;
    msg.Pose.Pose.Orientation.W]';

pos_vicon = [ msg.Pose.Pose.Position.X;
    msg.Pose.Pose.Position.Y;
    msg.Pose.Pose.Position.Z]';

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

