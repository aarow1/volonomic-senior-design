% Add additional initialization if you want to.
% You can use this space to pre-compute the trajectory to avoid
% repeatedly computing the same trajectory in every call of the
% "trajectory_generator" function
addpath(genpath('./'));

map.obstacles = [];
map.boundary = [-20 -20 -20 20 20 20];
%% Quintic Spline over multiple points over time
if iscell(path)
    path = cell2mat(path);
end
map.splinepath = path(1,:); %points in spline
point1 = path(1,:); %starting point
x = 0:0.01:1; %points to check
p = zeros(size(x,2),3);

%map.splinepath = path; %points in spline


for k = 2:size(path,1)
    point2 = path(k,:);

    %Parametrize Line
    m = point2 - point1; %slope between two points
    p0 = point1;

    for j = 1:length(x)
        p(j,:) = p0 + x(j)*m;
    end

    %Check fo collisions
    C = collide(map,p);
    %if collides add previous point and then make new spline
    if sum(C) > 0
        map.splinepath(end+1,:) = path(k-1,:);
        point1 = path(k-1,:);
    end
    if sum(C) == 0 && norm(m-[0.1 0.6 -1]) < 0.2
       temp_ind = k; 
    end
end
map.splinepath(end+1,:) = path(end,:);


%% Find times/durations for each segment
d = 0:0.05:30;
num = 10/16;
t =  d.^(num); %plot of time vs. distance.

map.times = zeros(size(map.splinepath,1)-1,1);

for k = 2:size(map.splinepath,1)
    distance =  sqrt(sum(abs(map.splinepath(k,:) - map.splinepath(k-1,:)).^2));
    map.times(k) = map.times(k-1) + distance.^(num);
    %map.times(k) = distance.^(num);
end
%map.times(temp_ind) = map.times(temp_ind-1) + distance.^(25/16);

%% Find coefficients of each segment
map.x_coeff = zeros(size(map.splinepath,1)-1,6);
map.y_coeff = zeros(size(map.splinepath,1)-1,6);
map.z_coeff = zeros(size(map.splinepath,1)-1,6);

if size(map.times,1) == 1
    temp = 1;
else
    temp = size(map.times,1)-1;
end
for k = 1:temp %original started at 1
    %Start and stop times of each spline segments
    t0 = map.times(k);
    tf = map.times(k+1);
    %t0 = 0;
    %tf = map.times(k);
    
    %Matrix of Coefficients
    A = [1 t0 t0^2 t0^3   t0^4    t0^5;
         1 tf tf^2 tf^3   tf^4    tf^5;
         0 1  2*t0 3*t0^2 4*t0^3  5*t0^4;
         0 1  2*tf 3*tf^2 4*tf^3  5*tf^4;
         0 0  2    6*t0   12*t0^2 20*t0^3;
         0 0  2    6*tf   12*tf^2 20*tf^3];

    %Initial Conditions
    pos_start = map.splinepath(k,:);
    pos_end   = map.splinepath(k+1,:);
    B_x = [pos_start(1,1) pos_end(1,1) 0 0 0 0]'; %startPos, endPos, startV, endV, startA, endA
    B_y = [pos_start(1,2) pos_end(1,2) 0 0 0 0]';
    B_z = [pos_start(1,3) pos_end(1,3) 0 0 0 0]';
    
   %Solve for Coefficients
   map.x_coeff(k,:) = (A\B_x)';
   map.y_coeff(k,:) = (A\B_y)';
   map.z_coeff(k,:) = (A\B_z)';
   
end

%% Generate trajectory
%disp('Generating Trajectory ...');
%trajectory_generator([], [], map, path);
