function [] = pose_callback(src,msg)

    q_curr_vicon(1) = msg.Pose.Orientation.X;
    q_curr_vicon(2) = msg.Pose.Orientation.Y;
    q_curr_vicon(3) = msg.Pose.Orientation.Z;
    q_curr_vicon(4) = msg.Pose.Orientation.W;
    q_curr_vicon
    
    p_vicon = zeros(1,3);
end