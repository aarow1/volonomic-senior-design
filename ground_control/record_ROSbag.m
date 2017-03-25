% must be in ROSBAG folder
% rosbag record /vicon/VI

filepath = '../ROSBAG/test2.bag';
bag = rosbag(filepath);
bagselect = select(bag, 'MessageType','nav_msgs/Odometry');
allmsg = readMessages(bagselect);
[l,~] = size(allmsg);
time = zeros(l,1);
% for i = 1:l
%     time(i) = allmsg{i}.Header.Stamp.Sec;
%     realtimeSec(i) = double(allmsg{i}.Header.Stamp.Sec);
%     realtimeNsec(i) = double(allmsg{i}.Header.Stamp.Nsec)*1E-9;
%     x_pos(i) = allmsg{i}.Pose.Pose.Position.X;
%     y_pos(i) = allmsg{i}.Pose.Pose.Position.Y;
%     z_pos(i) = allmsg{i}.Pose.Pose.Position.Z;
%     w_orient(i) = allmsg{i}.Pose.Pose.Orientation.W;
%     x_orient(i) = allmsg{i}.Pose.Pose.Orientation.X;
%     y_orient(i) = allmsg{i}.Pose.Pose.Orientation.Y;
%     z_orient(i) = allmsg{i}.Pose.Pose.Orientation.Z;
%     x_twist_ang(i) = allmsg{i}.Twist.Twist.Angular.X;
%     y_twist_ang(i) = allmsg{i}.Twist.Twist.Angular.Y;
%     z_twist_ang(i) = allmsg{i}.Twist.Twist.Angular.Z;
%     x_twist_lin(i) = allmsg{i}.Twist.Twist.Linear.X;
%     y_twist_lin(i) = allmsg{i}.Twist.Twist.Linear.Y;
%     z_twist_lin(i) = allmsg{i}.Twist.Twist.Linear.Z;
% end
% realtimeSec = realtimeSec - realtimeSec(1);
% realtime = realtimeSec + realtimeNsec;

figure('Name', 'Position');
subplot(3,1,1);
plot(realtime, x_pos);
title('X Position');
subplot(3,1,2);
plot(realtime, y_pos);
title('Y Position');
subplot(3,1,3);
plot(realtime, z_pos);
title('Z Position');

figure('Name', 'Orientation');
subplot(4,1,1);
plot(realtime, w_orient);
title('W Orientation');
subplot(4,1,2);
plot(realtime, x_orient);
title('X Orientation');
subplot(4,1,3);
plot(realtime, y_orient);
title('Y Orientation');
subplot(4,1,4);
plot(realtime, z_orient);
title('Z Orientation');

figure('Name', 'Angular Twist')
subplot(3,1,1);
plot(realtime, x_twist_ang);
title('X Twist Angle');
subplot(3,1,2);
plot(realtime, y_twist_ang);
title('Y Twist Angle');
subplot(3,1,3);
plot(realtime, z_twist_ang);
title('Z Twist Angle');


%need:
%allmsg.Header.Stamp.Sec + allmsg.Header.Stamp.NSec*1E-9
%allmsg.Pose.Pose.Position.X
%allmsg.Pose.Pose.Position.Y
%allmsg.Pose.Pose.Position.Z
%allmsg.Pose.Pose.Orientation.W
%allmsg.Pose.Pose.Orientation.X
%allmsg.Pose.Pose.Orientation.Y
%allmsg.Pose.Pose.Orientation.Z
%allmsg.Twist.Twist.Angular.X
%allmsg.Twist.Twist.Angular.Y
%allmsg.Twist.Twist.Angular.Z