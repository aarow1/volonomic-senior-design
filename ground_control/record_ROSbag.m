% must be in ROSBAG folder
% rosbag record /vicon/VI
% 
filepath = '../ROSBAG/to_box.bag';
bag = rosbag(filepath);
bagselect = select(bag, 'MessageType','nav_msgs/Odometry');
allmsg = readMessages(bagselect);
[l,~] = size(allmsg);

%% Initialize Variables
realtimeSec = zeroes(l,1);
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

%%
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
    
%     time_desSec(i) = pos_store{i}.time.Sec;
%     time_desNsec(i) = pos_store{i}.time.Nsec;
%     x_pos_des(i) = pos_store{i}.pos(1);
%     y_pos_des(i) = pos_store{i}.pos(2);
%     z_pos_des(i) = pos_store{i}.pos(3);
    
end

% x_pos_des = pos_store.
% Calulate time
% realtimeSec = realtimeSec - realtimeSec(1);
realtime = realtimeSec - realtimeSec(1) + realtimeNsec;

% %% Plot Position
% tstart = 2000;
% tfinish = 5000;
% figure('Name', 'Position');
% subplot(3,1,1);
% plot(realtime(tstart:tfinish), x_pos(tstart:tfinish));
% ylabel('(m)');
% xlabel('(sec)');
% title('X Position');
% subplot(3,1,2);
% plot(realtime(tstart:tfinish), y_pos(tstart:tfinish));
% ylabel('(m)');
% xlabel('(sec)');
% title('Y Position');
% subplot(3,1,3);
% plot(realtime(tstart:tfinish), z_pos(tstart:tfinish));
% ylabel('(m)');
% xlabel('(sec)');
% title('Z Position');
% hold on
% z_pos_des = ones(l)*z_pos(tstart)+0.1;
% plot(realtime(tstart:tfinish), z_pos_des(tstart:tfinish));

%% Plot Position
us_color= [244 126 54]/255;
them_color = [153 153 153]/255;

x_pos = x_pos - x_pos(1);
y_pos = y_pos - y_pos(1);
z_pos = z_pos - z_pos(1);

x_des = zeros(l,1);
% x_des(2300:l) = x_des(2300:l)-1;
% slope = 2/1300*[1:l-3000+1];
x_slope = 2/1300*[1:1310];
x_slope(1311:2107) = x_slope(1310);
x_des(3000:l) = x_des(3000:l)+x_slope(1:end)';

y_des = zeros(l,1);

z_des = zeros(l,1);
% z_step = ones(
z_des(2480:l) = z_des(2480:l) + 0.05;
z_des(2600:l) = z_des(2600:l) + 0.05;
z_des(2800:l) = z_des(2800:l) + 0.1;
z_des(4400:l) = z_des(4400:l) - 0.2;
z_des(4700:l) = z_des(4700:l) - 0.1;

% tstart = 2340;
% tfinish = 4636;
tstart = 3000;
tfinish = 4000;
figure('Name', 'Position');
subplot(3,1,1);
% x_err = immse(x_des(tstart:tfinish),x_pos(tstart:tfinish));

plot(realtime(tstart:tfinish), x_pos(tstart:tfinish), 'Color', us_color, 'LineWidth', 2);
hold on
plot(realtime(tstart:tfinish), x_des(tstart:tfinish), '--', 'Color', them_color, 'LineWidth', 2);

% ylabel('Position (m)');
% xlabel('Time (sec)');
% title('X Position');
axis([20 55 -0.5 2.5]);

subplot(3,1,2);
plot(realtime(tstart:tfinish), y_pos(tstart:tfinish), 'Color', us_color, 'LineWidth', 2);
hold on
plot(realtime(tstart:tfinish), y_des(tstart:tfinish), '--', 'Color', them_color, 'LineWidth', 2);

% ylabel('Position (m)');
% xlabel('Time (sec)');
% title('Y Position');
axis([20 55 -0.5 2.5]);

subplot(3,1,3);
plot(realtime(tstart:tfinish), z_pos(tstart:tfinish), 'Color', us_color, 'LineWidth', 2);
hold on
plot(realtime(tstart:tfinish), z_des(tstart:tfinish), '--', 'Color', them_color, 'LineWidth', 2);
% ylabel('(m)');
% xlabel('(sec)');
% title('Z Position');
axis([20 55 -0.5 0.5]);
% z_pos_des = ones(l)*z_pos(tstart)+0.1;
% plot(realtime(tstart:tfinish), z_pos_des(tstart:tfinish));
% print( 'back_from_box','-depsc');

x = x_des(tstart:tfinish);
xhat = x_pos(tstart:tfinish);
(x - xhat);    % Errors
(x - xhat).^2;   % Squared Error
mean((x - xhat).^2);   % Mean Squared Error
x_RMSE = sqrt(mean((x - xhat).^2));  % Root Mean Squared Error

y = y_des(tstart:tfinish);
yhat = y_pos(tstart:tfinish);
(y - yhat);    % Errors
(y - yhat).^2;   % Squared Error
mean((y - yhat).^2);   % Mean Squared Error
y_RMSE = sqrt(mean((y - yhat).^2));  % Root Mean Squared Error

z = z_des(tstart:tfinish);
zhat = z_pos(tstart:tfinish);
z_RMSE = sqrt(mean((z - zhat).^2));  % Root Mean Squared Error

x_err = (abs(x_des-x_pos))
y_err = (abs(y_des-y_pos))
z_err = (abs(z_des-z_pos))

x_merr = mean(abs(x_des-x_pos))
y_merr = mean(abs(y_des-y_pos))
z_merr = mean(abs(z_des-z_pos))

%% JUST Z POSITIONS
us_color= [244 126 54]/255;
them_color = [153 153 153]/255;
time_switch = 2500;
time_end = 4915;
figure
plot(realtime(tstart:tfinish), z_pos(tstart:tfinish), 'Color', us_color, 'LineWidth', 2);
ylabel('(m)');
xlabel('(sec)');
% title('Z Position');
hold on
z_pos_des = ones(l,1)*z_pos(tstart);
z_pos_des(time_switch:l) = z_pos_des(time_switch:l) + 0.1;
z_pos_des(time_end:l) = z_pos_des(time_end:l) + 0.5;
plot(realtime(tstart:tfinish), z_pos_des(tstart:tfinish), 'Color', them_color, 'LineWidth', 2);
% set(gcf, 'Color', 'none');
% set(gcf, 'color', 'none',...
%          'inverthardcopy', 'off');

z_error = z_pos_des - z_pos + 0.5;
% plot(realtime(tstart:tfinish), z_error(tstart:tfinish), '--', 'Color', them_color, 'LineWidth', 1);

print( 'Z Position Validation2','-depsc');

%% Plot Orientation
figure('Name', 'Orientation');
subplot(4,1,1);
plot(realtime(tstart:tfinish), w_orient(tstart:tfinish));
ylabel('(rad)');
xlabel('(sec)');
title('W Orientation');
subplot(4,1,2);
plot(realtime(tstart:tfinish), x_orient(tstart:tfinish));
ylabel('(rad)');
xlabel('(sec)');
title('X Orientation');
subplot(4,1,3);
plot(realtime(tstart:tfinish), y_orient(tstart:tfinish));
ylabel('(rad)');
xlabel('(sec)');
title('Y Orientation');
subplot(4,1,4);
plot(realtime(tstart:tfinish), z_orient(tstart:tfinish));
ylabel('(rad)');
xlabel('(sec)');
title('Z Orientation');

%% Plot Angular Twist
figure('Name', 'Angular Twist')
subplot(3,1,1);
plot(realtime(tstart:tfinish), x_twist_ang(tstart:tfinish));
title('X Twist Angle');
subplot(3,1,2);
plot(realtime(tstart:tfinish), y_twist_ang(tstart:tfinish));
title('Y Twist Angle');
subplot(3,1,3);
plot(realtime(tstart:tfinish), z_twist_ang(tstart:tfinish));
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