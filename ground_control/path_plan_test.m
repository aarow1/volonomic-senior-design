% States are [x y z yaw(z, degrees) pitch(y, degrees) roll(x, degrees)
% All derivatives at end points are zero (for now?)
% TODO figure out how to wrap angles
waypoints = [
    0  0  0  0   0  0;
    1  0  0  0   180  0;
    0  1  0  0   0  0;
    -1  0  0  180   0  0;
    0  -1  0  0   0  0;
    0  0  0  0   0  180];
t = [0 1 2 3 4 5];

num_segments = size(deltas,1);
num_waypoints = size(waypoints,1);

deltas = diff(waypoints);

% %% Time approximation
% v_des = 2; %approximate m/s
% w_des = 90;  %approcimate deg/s
%
% way_times = zeros(num_segments+1, 1);
%
% for i = 1:num_segments
%     lin_dist = sqrt(deltas(i,1)^2 + deltas(i,2)^2 + deltas(i,3)^2);
%     ang_dist = sqrt(deltas(i,4)^2 + deltas(i,5)^2 + deltas(i,6)^2);
%
%     lin_time = lin_dist / v_des;
%     ang_time = ang_dist / w_des;
%
%     way_times(i) = t_0 + max([lin_time ang_time])
% end

%% Calculate coefficients
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

X((6*num_segments)-2,:) = waypoints(num_segments+1,:)


%%
% position constraints
% A(1,1:6) = [1 0 0 0 0 0]; % start position
% A(2*num_segments,(num_segments-1)*6+1) = [1 1 1 1 1 1];
%
% midpoint positions
% for i = 2:num_segments-1
%   A(i+1,(6*i) + 1:6) = [1 1 1 1 1 1]; % position end of segment
%   A(i+2, (6*i) + 1:6) = [1 0 0 0 0 0]; % position beginning of segment
% end
%
% endpoint velocities
% A((2*num_segments)+1, 1:6) = [0 1 0 0 0 0];
% A((2*num_segments)+2,(num_segments-1)*6+1) = [0 1 2 3 4 5];
%
% endpoint accelerations
% A((2*num_segments)+3, 1:6) = [0 0 1 0 0 0];
% A((2*num_segments)+2,(num_segments-1)*6+1) = [0 0 2 6 12 20];
%
% X = [state_0; state_1; zeros(4,6)];

C = A\X;

%% plot over time
close all
axis equal;
grid on;
axis([-4 4 -4 4 -4 4]);
hold on;
dt = .1
R = eye(3);
for t_path = 0:dt:10
    clf();
    t_vec = zeros(6*num_segments,1);
    t_vec_basic = [1 t_path t_path^2 t_path^3 t_path^4 t_path^5]';
    
    for seg = 1:num_segments
        if ((t_path >= t(seg)) && (t_path < t(seg+1)))
            t_vec((6*(seg-1)+1):(6*(seg-1)+6)) = t_vec_basic;
        end
    end
    
    state = zeros(1,6);
    for dim = 1:6
        num =  C(:,dim)' * t_vec;
        state(dim) = num;
    end
    t_vec;
    state;
    R = eul2rotm(deg2rad(state(4:6)), 'zyx');
    
    h0 = plotCoordinateFrameOff(state(1:3), R, 0, [0 0 1]);
    
    axis equal;
    grid on;
    axis([-4 4 -4 4 -4 4]);
%     view(2);
    title(t_path);
    drawnow();
    pause(dt);
end



