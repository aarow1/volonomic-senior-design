function [] = pose_callback(~,msg)
global q_curr_vicon pos_vicon f_des gains

global pos_des
global pos_control_on
persistent err_prev time int ctr
if isempty(err_prev)
    err_prev = [0 0 0];
end
if isempty(int)
    int = [0 0 0];
end
if isempty(time)
    time = 0;
end
if isempty(ctr)
    ctr = 0;
end
T = toc - time;
time = toc; 
q_curr_vicon = [msg.Pose.Pose.Orientation.W;
    msg.Pose.Pose.Orientation.X;
    msg.Pose.Pose.Orientation.Y;
    msg.Pose.Pose.Orientation.Z;]';

pos_vicon = [ msg.Pose.Pose.Position.X;
    msg.Pose.Pose.Position.Y;
    msg.Pose.Pose.Position.Z]';

if pos_control_on
    pos_gains = [gains; gains; gains];
    err = pos_des - pos_vicon;
    der = (err-err_prev)/T;
    int = int + err*T;
    
    err_prev = err;
    
    VI_mass = .50;
    g = 9.8;
    
    f_des = sum(pos_gains.*[err' der' int'],2)' + [0, 0, (VI_mass*g)];
else
    f_des = [0 0 0];
end

global send_vicon
if send_vicon
    ctr = ctr+1;
    sendPkt('all_inputs')
    if mod(ctr, 15) == 0
        fprintf('sending vicon...\t pos_control: %i',pos_control_on);
        ctr = 0;
    end
end

tic;
end

