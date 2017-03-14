function [] = pose_callback(src,msg)
    persistent pos_vicon_prev err_prev int
    T = toc;
    q_curr_vicon(1) = msg.Pose.Orientation.X;
    q_curr_vicon(2) = msg.Pose.Orientation.Y;
    q_curr_vicon(3) = msg.Pose.Orientation.Z;
    q_curr_vicon(4) = msg.Pose.Orientation.W;
    q_curr_vicon
    
    pos_vicon(1) = msg.Pose.Position.X;
    pos_vicon(2) = msg.Pose.Position.Y;
    pos_vicon(3) = msg.Pose.Position.Z;
    
    err = pos_vicon-pos_vicon_prev;
    err_prev = err;
    der = (err-err_prev)/T; 
    int = int + err*T;
    
    pos_vicon = sum(pos_gains.*[err' der' int'],2)';
    pos_vicon_prev = pos_vicon; 
    
    sendPkt();
    tic; 
end

% a bunch of listeners 