% must be in ROSBAG folder
% rosbag record /vicon/VI

filepath = '../ROSBAG/test2.bag';
bag = rosbag(filepath);
bagselect = select(bag, 'MessageType','nav_msgs/Odometry');
allmsg = readMessages(bagselect);
[l,~] = size(allmsg);
time = zeros(l,1);
for i = 1:l
    time(i) = allmsg{1}.Header.Stamp.Sec;
end

%need:
%allmsg.Header.Stamp.Sec + allmsg.Header.Stamp.NSec*1E-9
%allmsg.Pos.Pose.Position.X
%allmsg.Pos.Pose.Position.Y
%allmsg.Pos.Pose.Position.Z
%allmsg.Pos.Pose.Orientation.W
%allmsg.Pos.Pose.Orientation.X
%allmsg.Pos.Pose.Orientation.Y
%allmsg.Pos.Pose.Orientation.Z
%allmsg.Twist.Twist.Angular.X
%allmsg.Twist.Twist.Angular.Y
%allmsg.Twist.Twist.Angular.Z