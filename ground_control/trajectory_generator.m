function [] = trajectory_generator(waypoints) 
disp('generating trajectory...')
global C way_times pos_vicon q_curr_vicon follow_traj waypts traj_start
q_curr = rad2deg(quat2eul(q_curr_vicon,'zyx'));

waypoints = [pos_vicon q_curr; waypoints];
num_waypoints = size(waypoints,1);
num_segments = num_waypoints-1;
deltas = diff(waypoints);

%% Time approximation
v_des = .5; %approximate m/s
w_des = 45;  %approcimate deg/s

t0 = 0;
way_times = zeros(num_waypoints, 1);

for i = 2:num_waypoints
    lin_dist = sqrt(deltas(i-1,1)^2 + deltas(i-1,2)^2 + deltas(i-1,3)^2);
    ang_dist = sqrt(deltas(i-1,4)^2 + deltas(i-1,5)^2 + deltas(i-1,6)^2);

    lin_time = lin_dist / v_des;
    ang_time = ang_dist / w_des;

    way_times(i) = way_times(i-1) + max([lin_time ang_time]);
end


t = way_times;

%% Coefficient calculations
A = zeros(6*num_segments, 6*num_segments);
X = zeros(6*num_segments, 6);

% Start point constraints
A(1,1:6) = [1*t(1)^0 1*t(1)^1 1*t(1)^2 1*t(1)^3  1*t(1)^4  1*t(1)^5]; %position
A(2,1:6) = [0        1*t(1)^0 2*t(1)^1 3*t(1)^2  4*t(1)^3  5*t(1)^4]; %velocity
A(3,1:6) = [0        0        2*t(1)^0 6*t(1)^1 12*t(1)^2 20*t(1)^3]; %acceleration
X(1,:) = waypoints(1,:);

% Mid point continuity constraints
for i = 1:(num_segments-1)
    i1 = i+1;
    A((6*(i-1))+3+1 , (6*(i-1))+(1:6))  = [1*t(i1)^0 1*t(i1)^1  1*t(i1)^2  1*t(i1)^3   1*t(i1)^4    1*t(i1)^5]; %position at end of previous segment
    A((6*(i-1))+3+2 , (6*(i  ))+(1:6))  = [1*t(i1)^0 1*t(i1)^1  1*t(i1)^2  1*t(i1)^3   1*t(i1)^4    1*t(i1)^5]; %position at beginning of next segment
    A((6*(i-1))+3+3 , (6*(i-1))+(1:12)) = [0        1*t(i1)^0   2*t(i1)^1  3*t(i1)^2   4*t(i1)^3    5*t(i1)^4 ...
        0       -1*t(i1)^0  -2*t(i1)^1 -3*t(i1)^2  -4*t(i1)^3   -5*t(i1)^4]; %velocity continuity
    A((6*(i-1))+3+4 , (6*(i-1))+(1:12)) = [0        0           2*t(i1)^0  6*t(i1)^1  12*t(i1)^2   20*t(i1)^3 ...
        0        0          -2*t(i1)^0 -6*t(i1)^1 -12*t(i1)^2  -20*t(i1)^3]; %acceleration continuity
    A((6*(i-1))+3+5 , (6*(i-1))+(1:12)) = [0        0           0          6*t(i1)^0  24*t(i1)^1   60*t(i1)^2 ...
        0        0           0         -6*t(i1)^0 -24*t(i1)^1  -60*t(i1)^2]; %jerk continuity
    A((6*(i-1))+3+6 , (6*(i-1))+(1:12)) = [0        0           0          0          24*t(i1)^0  120*t(i1)^1 ...
        0        0           0          0         -24*t(i1)^0 -120*t(i1)^1]; %snap continuity
    
    X((6*(i-1))+3+1, :) = waypoints(i+1,:);
    X((6*(i-1))+3+2, :) = waypoints(i+1,:);
end

% End point constraints
A((6*num_segments)-2,(6*(num_segments-1))+(1:6)) = [1*t(num_waypoints)^0  1*t(num_waypoints)^1 1*t(num_waypoints)^2 1*t(num_waypoints)^3  1*t(num_waypoints)^4  1*t(num_waypoints)^5]; %position
A((6*num_segments)-1,(6*(num_segments-1))+(1:6)) = [0                     1*t(num_waypoints)^0 2*t(num_waypoints)^1 3*t(num_waypoints)^2  4*t(num_waypoints)^3  5*t(num_waypoints)^4]; %velocity
A((6*num_segments)-0,(6*(num_segments-1))+(1:6)) = [0                     0                    2*t(num_waypoints)^0 6*t(num_waypoints)^1 12*t(num_waypoints)^2 20*t(num_waypoints)^3]; %acceleration

X((6*num_segments)-2,:) = waypoints(num_segments+1,:);

C = A\X;

traj_start = toc;
follow_traj = 1;

disp('following trajectory...');
end