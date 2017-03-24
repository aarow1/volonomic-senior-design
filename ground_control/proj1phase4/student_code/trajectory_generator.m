function [ desired_state ] = trajectory_generator(t, qn, map, path)
% TRAJECTORY_GENERATOR: Turn a Dijkstra or A* path into a trajectory
%
% NOTE: This function would be called with variable number of input
% arguments. In init_script, it will be called with arguments
% trajectory_generator([], [], map, path) and later, in test_trajectory,
% it will be called with only t and qn as arguments, so your code should
% be able to handle that.
%
% map: The map structure returned by your load_map function
% path: This is the path returned by your planner (dijkstra function)
%
% desired_state: Contains all the information that is passed to the
% controller, as in phase 2

persistent time2 c_x c_y c_z goal T map0 %map2 coll

if isempty(t)
    map0 = map;

%     thresh1 = 1e0;
%     thresh2 = 5e0;
%     mult = 1;
%     root1 = 0.125;

%     thresh1 = 5e-1;
%     thresh2 = 5e0;
%     mult = 0.8;
%     root1 = 0.25;

    thresh1 = 7e-4;
    thresh2 = 1e0;
    thresh3 = 0;
    mult = 2;
    root1 = 0.25;

%     thresh1 = 7e-1;
%     thresh2 = 5e0;
%     thresh3 = 2e-3;
%     mult = 0.9;
%     root1 = 0.25;
    
    [ n_splines, newpath ] = remove_colinear(thresh1, thresh2, thresh3, path); 

    T = n_splines*mult;
    %time2 = (0:n_splines)* T / n_splines;
    dist =  power(sum((newpath(1:end-1,:) - newpath(2:end,:)).^2,2),root1);
    %sum(power(sum((newpath(1:end-1,:) - newpath(2:end,:)).^2,2),0.5))
    time1 = ones(n_splines,1) .* dist / sum(dist) * T; % scale by distance
    time2 = [0; cumsum(time1)];
    
    [c_x, c_y, c_z ] = cubic_spline( n_splines, newpath, time2 );
    goal = newpath(end,:)';
%     map2 = load_map('maps/map1.txt', 0.1, 2, 0);
%     coll = 0
else
    i = find(time2 <= t,1,'last');
    if t < T
        t_p = [1 t t^2 t^3];
        t_v = [0 1 2*t 3*t^2];
        t_a = [0 0 2 6*t];

        desired_state.pos = [dot(c_x(i,:), t_p); dot(c_y(i,:), t_p); dot(c_z(i,:), t_p)];
        desired_state.vel = [dot(c_x(i,:), t_v); dot(c_y(i,:), t_v); dot(c_z(i,:), t_v)];
        desired_state.acc = [dot(c_x(i,:), t_a); dot(c_y(i,:), t_a); dot(c_z(i,:), t_a)];
        desired_state.yaw = 0;
        desired_state.yawdot = 0;
    else
        desired_state.pos = goal;
        desired_state.vel = [0 0 0]';
        desired_state.acc = [0 0 0]';
        desired_state.yaw = 0;
        desired_state.yawdot = 0;
        %coll
    end
%     if collide(map2,desired_state.pos') 
%         %error(mat2str(desired_state.pos));
%         %error(num2str(t));
%         coll = coll + 1;
%     end
%     
end


        

        


