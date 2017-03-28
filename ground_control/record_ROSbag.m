% must be in ROSBAG folder
% rosbag record /vicon/VI
% 
filepath = '../ROSBAG/lalala.bag';
% bag = rosbag(filepath);
bagselect = select(bag, 'MessageType','nav_msgs/Odometry');
allmsg = readMessages(bagselect);
[l,~] = size(allmsg);

realtimeSec = zeros(l,1);
realtimeNsec = zeros(l,1);
x_pos = zeros(l,1);
y_pos = zeros(l,1);
z_pos = zeros(l,1);
w_orient = zeros(l,1);
x_orient = zeros(l,1);
y_orient = zeros(l,1);
z_orient = zeros(l,1);
x_twist_ang = zeros(l,1);
y_twist_ang = zeros(l,1);
z_twist_ang = zeros(l,1);
x_twist_lin = zeros(l,1);
y_twist_lin = zeros(l,1);
z_twist_lin = zeros(l,1);

x_pos_des = zeros(l,1);
y_pos_des = zeros(l,1);
z_pos_des = zeros(l,1);

for i = 1:l
%     time(i) = allmsg{i}.Header.Stamp.Sec;
    realtimeSec(i) = double(allmsg{i}.Header.Stamp.Sec);
    realtimeNsec(i) = double(allmsg{i}.Header.Stamp.Nsec)*1E-9;
    x_pos(i) = allmsg{i}.Pose.Pose.Position.X;
    y_pos(i) = allmsg{i}.Pose.Pose.Position.Y;
    z_pos(i) = allmsg{i}.Pose.Pose.Position.Z;
    w_orient(i) = allmsg{i}.Pose.Pose.Orientation.W;
    x_orient(i) = allmsg{i}.Pose.Pose.Orientation.X;
    y_orient(i) = allmsg{i}.Pose.Pose.Orientation.Y;
    z_orient(i) = allmsg{i}.Pose.Pose.Orientation.Z;
    x_twist_ang(i) = allmsg{i}.Twist.Twist.Angular.X;
    y_twist_ang(i) = allmsg{i}.Twist.Twist.Angular.Y;
    z_twist_ang(i) = allmsg{i}.Twist.Twist.Angular.Z;
    x_twist_lin(i) = allmsg{i}.Twist.Twist.Linear.X;
    y_twist_lin(i) = allmsg{i}.Twist.Twist.Linear.Y;
    z_twist_lin(i) = allmsg{i}.Twist.Twist.Linear.Z;
    
    time_desSec(i) = pos_store{i}.time.Sec;
    time_desNsec(i) = pos_store{i}.time.Nsec;
    x_pos_des(i) = pos_store{i}.pos(1);
    y_pos_des(i) = pos_store{i}.pos(2);
    z_pos_des(i) = pos_store{i}.pos(3);
    
end

x_pos_des = pos_store.
% Calulate time
% realtimeSec = realtimeSec - realtimeSec(1);
realtime = realtimeSec - realtimeSec(1) + realtimeNsec;

%% Plot Position
figure('Name', 'Position');
subplot(3,1,1);
plot(realtime, x_pos);
ylabel('(m)');
xlabel('(sec)');
title('X Position');
subplot(3,1,2);
plot(realtime, y_pos);
ylabel('(m)');
xlabel('(sec)');
title('Y Position');
subplot(3,1,3);
plot(realtime, z_pos);
ylabel('(m)');
xlabel('(sec)');
title('Z Position');

%% Plot Orientation
figure('Name', 'Orientation');
subplot(4,1,1);
plot(realtime, w_orient);
ylabel('(rad)');
xlabel('(sec)');
title('W Orientation');
subplot(4,1,2);
plot(realtime, x_orient);
ylabel('(rad)');
xlabel('(sec)');
title('X Orientation');
subplot(4,1,3);
plot(realtime, y_orient);
ylabel('(rad)');
xlabel('(sec)');
title('Y Orientation');
subplot(4,1,4);
plot(realtime, z_orient);
ylabel('(rad)');
xlabel('(sec)');
title('Z Orientation');

%% Plot Angular Twist
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