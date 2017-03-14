%rosinit;
%rostopic list

odom_sub = rossubscriber('/vicon/VI/pose', @pose_callback)