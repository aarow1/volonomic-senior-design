function [] = pose_callback(~,msg)
global q_curr_vicon pos_vicon pos_gains f_des

global pos_des
global pos_control_on
persistent err_prev int

T = toc;
q_curr_vicon = [msg.Pose.Pose.Orientation.W;
    msg.Pose.Pose.Orientation.X;
    msg.Pose.Pose.Orientation.Y;
    msg.Pose.Pose.Orientation.Z;]';

pos_vicon = [ msg.Pose.Pose.Position.X;
    msg.Pose.Pose.Position.Y;
    msg.Pose.Pose.Position.Z]';

if pos_control_on
    err = pos_des - pos_vicon;
    der = (err-err_prev)/T;
    int = int + err*T;
    
    err_prev = err;
    
    VI_mass = .750;
    g = 9.8;
    
    f_des = sum(pos_gains.*[err' der' int'],2)' + [0, 0, (VI_mass*g)];
else
    f_des = [0 0 0];
end

global send_vicon
if send_vicon
    sendPkt('all_inputs')
    disp('sending vicon')
end

tic;
end

