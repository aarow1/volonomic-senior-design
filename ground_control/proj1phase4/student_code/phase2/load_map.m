function map = load_map(filename, xy_res, z_res, margin)
%% Group work note: 
% I discussed my project with Devin Carroll in order to get a better idea
% of how to structure and organize my code.

%% LOAD_MAP Load a map from disk.
%  MAP = LOAD_MAP(filename, xy_res, z_res, margin).  Creates an occupancy grid
%  map where a node is considered fill if it lies within 'margin' distance of
%  on abstacle.

%% Read in file and store in cell array
clc
fileID = fopen(filename);
C = textscan(fileID,'%s %n %n %n %n %n %n %*[^\n]','CommentStyle','#');
fclose(fileID);
M = cell2mat(C(:,[2:end])); %first row is map.boundary, rest are blocks

%% Process data into a structure
map.xy_res = xy_res;
map.z_res = z_res;
map.margin = margin; %*1.5
map.boundary = M(1,:); %xmin ymin zmin xmax ymax zmax
map.obstacles = M(2:end,:); %xmin ymin zmin xmax ymax zmax

%% Increase obstacle size
%expand by margin, decrease min by margin and increase max by margin
if ~isempty(map.obstacles)
   map.obstacles =  [M(2:end,1:3) - map.margin, M(2:end,4:end) + map.margin];
end

%% Discretize environment
%expand by resolution in order to account for boundaries later on
x_disc = (map.boundary(1)-map.xy_res) : map.xy_res : (map.boundary(4)+map.xy_res);
y_disc = (map.boundary(2)-map.xy_res) : map.xy_res : (map.boundary(5)+map.xy_res);
z_disc = (map.boundary(3)-map.z_res)  : map.z_res  : (map.boundary(6)+map.z_res);

%Node/point representation of environment
[map.x,map.y,map.z] = ndgrid(x_disc,y_disc,z_disc); %row, column, pages = xyz
    
%Make 3D matrix of environment (0s = free space)
map.env = zeros(size(map.z) - 2); %subtract 2 to account for the boundaries

%% Add obstacle to environment
if (~isempty(map.obstacles))
    for k = 1:size(map.obstacles(1),1)
        %shift discretized obstacles to account for minimum xyz 
        point1 = [floor((map.obstacles(k,1) - map.boundary(1))/map.xy_res);
                  floor((map.obstacles(k,2) - map.boundary(2))/map.xy_res);
                  floor((map.obstacles(k,3) - map.boundary(3))/map.z_res)]+1;

        %shift discretized obstacles to account for maximum xyz 
        point2 = [floor((map.obstacles(k,4) - map.boundary(4))/map.xy_res);
                  floor((map.obstacles(k,5) - map.boundary(5))/map.xy_res);
                  floor((map.obstacles(k,6) - map.boundary(6))/map.z_res)]+1;

        %test if obstacles are less than boundary, if yes, make on boundary
        a = point1 < 1;
        point1(a) = 1;
        b = point2 < 1;
        point2(b) = 1;

        %test if obstacles are greater than boundary,
        reduced_bound = size(map.x)'-2;
        point2(point2 > reduced_bound) = reduced_bound(point2 > reduced_bound);
        
        %create block of obstacle (ones)
        obs_size = point2 - point1 + 1; %inclusive +1
        obstacle = ones(obs_size(1), obs_size(2), obs_size(3));

        %Add block of obstacles to environment
        map.env(point1(1):point2(1), point1(2):point2(2),point1(3):point2(3)) = obstacle;
    end
end

%% Add boundaries as obstacles (1) around environment
map.env = padarray(map.env, [1 1 1], 1);
end
