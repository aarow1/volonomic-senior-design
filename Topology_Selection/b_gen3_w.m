function [ w ] = b_gen3_w( step )
%% Generate theta steps
% theta_1:theta_n-1 = [1:pi]
theta_v = 0:step:2*pi;
theta_v1 = 0:step:pi;
t1 = theta_v1;
t2 = theta_v;
w = [];
%% Use spherical coordinates to determine x1-x6
for j = 1:length(t2)
    for i = 1:length(t1)
    x = cos(t1(i));
    y = sin(t1(i))*cos(t2(j));
    z = sin(t1(i))*sin(t2(j));
    w = [w [x;y;z;0;0;0]];
end
w = unique(round(w',3),'rows')';
% scatter(w(1,:),w(2,:));
% axis equal;
end

