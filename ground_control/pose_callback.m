function [] = pose_callback(~,msg)
global q_curr_vicon pos_vicon f_des gains w_vicon

global pos_des
global send_vicon pos_control_on
persistent err_prev time
global integral_1
if isempty(err_prev)
    err_prev = [0 0 0];
end
if isempty(integral_1)
    integral_1 = [0 0 0];
end
if isempty(time)
    time = 0;
end

T = toc - time;
time = toc;
% disp('ppoooppopo');

    q_curr_vicon = [msg.Pose.Pose.Orientation.W;
        msg.Pose.Pose.Orientation.X;
        msg.Pose.Pose.Orientation.Y;
        msg.Pose.Pose.Orientation.Z;]';
    
    pos_vicon = [ msg.Pose.Pose.Position.X;
        msg.Pose.Pose.Position.Y;
        msg.Pose.Pose.Position.Z]';
    
    w_vicon = [msg.Twist.Twist.Angular.X;
        msg.Twist.Twist.Angular.Y;
        msg.Twist.Twist.Angular.Z]';
    if send_vicon
        if pos_control_on
            pos_gains = [gains; gains; gains];
            err = pos_des - pos_vicon;
            der = (err-err_prev)/T;
            
            R_0_1 = quat2rotm(q_curr_vicon);
            integral_1 = integral_1 + ((R_0_1)'*err'*T)';
            integral_0 = (R_0_1 * integral_1')';
            
            err_prev = err;
            
            VI_mass = .73;
            g = 9.8;
            
            f_des = sum(pos_gains.*[err' der' integral_0'],2)' + [0, 0, (VI_mass*g)];
        else
            f_des = [0 0 0];
        end
    sendPkt('all_inputs');
    end
    
end

