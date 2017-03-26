function [path, num_expanded] = dijkstra(map, start, goal, astar)
%% Group work note: 
% I discussed my project with Devin Carroll in order to get a better idea
% of how to structure and organize my code.  I utilized his suggestion
% of creating a table of nodes, cost, and parents in order to implement
% Dijkstra's.  I also posted on piazza to Alex that there are similarities
% between my code and Devin's code simply because when I was stuck and
% asked for guidance, he could only advise me on what he did for his code.

%% DIJKSTRA Find the shortest path from start to goal.
%   PATH = DIJKSTRA(map, start, goal) returns an M-by-3 matrix, where each row
%   consists of the (x, y, z) coordinates of a point on the path.  The first
%   row is start and the last row is goal.  If no path is found, PATH is a
%   0-by-3 matrix.  Consecutive points in PATH should not be farther apart than
%   neighboring cells in the map (e.g.., if 5 consecutive points in PATH are
%   co-linear, don't simplify PATH by removing the 3 intermediate points).
%
%   PATH = DIJKSTRA(map, start, goal, astar) finds the path using euclidean
%   distance to goal as a heuristic if astar is true.
%
%   [PATH, NUM_EXPANDED] = DIJKSTRA(...) returns the path as well as
%   the number of points that were visited while performing the search.

%% Check to run Dijkstra or A*
if nargin < 4
    %Run regular Dijkstra
    astar = false;
    a = 0;
else
    %Modify cost function to run A*
    a = 100;
end

map.begin = start;
map.end = goal;
%% Initial Checks of Start and Goal Position
%Check that start and goal positions do not collide with obstacles or boundaries
%If yes, then return empty path and empty num_expanded
[C] = collide(map, [start; goal]);
if max(C) == 1
    path = zeros(1,3);
    num_expanded = 0;
    return
end

%% Initialize Table of Nodes, Cost, Parents, Visted, XYZ, Manhattan Distance
total_nodes = numel(map.env) + 2; %total nodes in environment + start + goal

%Row1: Costs initialized to infinity, start = 0, goal = inf (at end of table)
table(1,:) = [inf(1, numel(map.env)) 0 inf]; %numel(map.env) = number of nodes
%Row2: Parents of nodes, start is 0 and rest are Nan or zero or infginity
table(2,:) = zeros(1, total_nodes); 
%Row3: Visited (1-Visited 0-Not Visited)
table(3,:) = zeros(1, total_nodes);
%Row4: X-coordinates of Nodes
table(4,:) = [map.x(1:end) start(1) goal(1)];
%Row5: Y-coordinates of Nodes
table(5,:) = [map.y(1:end) start(2) goal(2)];
%Row6: Z-coordinates of Nodes
table(6,:) = [map.z(1:end) start(3) goal(3)];
%Row7: Manhattan Distance from Node to Goal
table(7,:) = sum(abs(table(4:6,:) - repmat(goal',[1 total_nodes])));
%table(7,:) = sqrt(sum(abs(table(4:6,:) - repmat(goal',[1 total_nodes])).^2));
%Row8: Check if node collides(1) or not(0)
table(8,:) = (collide(map,table(4:6,:)'))';

%% Find where start and goal nodes are (indices)
start_stop = [start; goal];
node_index = [0; 0];

%Expand boundaries (similar to load_map.m)
xmin_boundary = map.boundary(1)-map.xy_res;
ymin_boundary = map.boundary(2)-map.xy_res;
zmin_boundary = map.boundary(3)-map.z_res;

%Shift points to find coordinates of node in map environment
for k = 1:size((start_stop),1)
    x_node = floor((start_stop(k,1)-xmin_boundary)/map.xy_res)+1;
    y_node = floor((start_stop(k,2)-ymin_boundary)/map.xy_res)+1;
    z_node = floor((start_stop(k,3)-zmin_boundary)/map.z_res)+1;
    
    node_index(k) = sub2ind(size(map.env), x_node, y_node, z_node);
end

%Set node to variable and find 6 connected neighbors
start_Node = node_index(1);
start_Neighbors = neighbors(start_Node,map); %vector of 6 connected neighbors
goal_Node = node_index(2);
goal_Neighbors = neighbors(goal_Node,map);

%% Start Tree 
u = 0; %Start with 0 cost, u is g[v]
curr_node = total_nodes - 1; %current node in Table (second to last)

%Vector of neighbor nodes to check for lowest cost.  Neighbor with lowest
%cost will be chosen as next step and set as curr_node for next loop
nbr_tester = curr_node;

%while goal is unvisited and cost of goal is infinity (no path found yet)
while table(3,end) == 0 && u < inf
    %Mark node u as visited in Row3 (remove from empty set Q)
    table(3,curr_node) = 1;
    
    %Check if node is start node
    if curr_node == total_nodes - 1 
        node_nbrs = start_Neighbors;
    %Check if node is goal node
    elseif curr_node == total_nodes 
        node_nbrs = goal_Neighbors;
    else
        %Else, find neighbors for node
        node_nbrs = neighbors(curr_node,map);
    end
    
    %Only visit neighbors in free space
    free_spaceNodes = (table(8,node_nbrs) == 0);
    node_nbrs = node_nbrs(free_spaceNodes);
    
    %If node has been previously visited, then remove from set of neighbors
    visited = (table(3,node_nbrs) ~= 0);
    node_nbrs(visited) = [];
   
    %For each neighboring node in empty set
    for n = 1:length(node_nbrs)
        %Find cost(d) from current node to neighbors
        d = u + sum(abs(table(4:6,curr_node)- table(4:6,node_nbrs(n))))+a*table(7,node_nbrs(n));
        
        %Special Case: if node is goal, set rest of neighbors be goal node in table
        if node_nbrs(n) == goal_Node    
            node_nbrs(n) = length(table); 
        end
        
        %Check if this new cost d is < current cost in table for this (neighbor) node
        if d < table(1,node_nbrs(n))
            table(1,node_nbrs(n)) = d; %Set new lower cost for node
            table(2,node_nbrs(n)) = curr_node; %Set parent node for this (neighbor) node
           
            %If the current neighbor node has not been visited, then add to
            %list of neighbor nodes to check for lowest cost
            if table(3,node_nbrs(n)) == 0
                nbr_tester(:,end+1) = node_nbrs(n);
            end        
        end
    end
    
    temp = [table(1:7,nbr_tester); nbr_tester]; %section of table containing tester nodes
    %Indices of unvisited neighbors
    %unvisited_Ind = table(3,nbr_tester) == 0; %yields indices that have not been visited
    unvisited_Nbrs = temp(3,:) == 0;

    %Choose node that yields the lowest cost from unvisited neighbors
    [~,curr_node] = min(temp(1,unvisited_Nbrs) + ... %Dijkstra's (a=0)
                         a*temp(7,unvisited_Nbrs)); %A* when a=1, o/w a=0
    
    temp2 = temp([1 8]', unvisited_Nbrs);
    u = temp2(1,curr_node);
    curr_node  = temp2(2,curr_node);      

    nbr_tester(:,nbr_tester == curr_node) = [];

end

%Get path planned
parent = [table(2,end) total_nodes]; %[parent of goal node, goal node itself]
%Retracing parent nodes back to start node (whose parent = 0)
while parent(1,1) ~= 0
     %find parent of front node, append rest of parents to path
    parent = [table(2,parent(1,1)) parent];
end
%Find xyz coordinates of all parent nodes -> path in xyz
path = table(4:6,parent(2:end))';

%Number of nodes visited
num_expanded = sum(table(3,:)==1);


end

%% Neighbor Function - Finds 6 connected neighboring nodes
%Input: vector with xyz coordinates of point [3x1]
%Output: vector with indices of all neighbors [6x1]
function nbr_node = neighbors(node,map)
    nbr_node = zeros(6,1);
    
    %Convert node coordinates to subscripts of environment matrix
    [nx, ny, nz] = ind2sub(size(map.env),node);
    
    %Subscripts of 6 connected neighbors
    x_left  = [nx+1 ny nz];
    x_right = [nx-1 ny nz];
    y_up    = [nx ny+1 nz];
    y_down  = [nx ny-1 nz];
    z_front = [nx ny nz-1];
    z_back  = [nx ny nz+1];
    six_connect = [x_left; x_right; y_up; y_down; z_front; z_back];
    
    %Find node indices of each of six-connected nodes
    for k = 1:length(six_connect)
        nbr_node(k) = sub2ind(size(map.env),six_connect(k,1),...
            six_connect(k,2),six_connect(k,3));
    end
end    