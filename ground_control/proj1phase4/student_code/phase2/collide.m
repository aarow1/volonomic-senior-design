function [C] = collide(map, points)
%% Group work note: 
% I discussed my project with Devin Carroll in order to get a better idea
% of how to structure and organize my code.

%% COLLIDE Test whether points collide with an obstacle in an environment.
%   C = collide(map, points).  points is an M-by-3 matrix where each
%   row is an (x, y, z) point.  C in an M-by-1 logical vector;
%   C(i) = 1 if M(i, :) touches an obstacle and is 0 otherwise.
% C = unknownNode(map.res,points,[map.x;map.y;map.z],size(map.bin),map.bin);

%Initialize C to be all free space
C = zeros(size(points,1),1);

%Iterate through all points and check with obstacles and boundaries
for k = 1:size(points,1)
    %Check collision with obstacles if there exists blocks
    if(~isempty(map.obstacles))
        ox = points(k,1) >= map.obstacles(:,1) & points(k,1) <= map.obstacles(:,4);
        oy = points(k,2) >= map.obstacles(:,2) & points(k,2) <= map.obstacles(:,5);
        oz = points(k,3) >= map.obstacles(:,3) & points(k,3) <= map.obstacles(:,6);
        obs = ox & oy & oz;
        if  (max(obs) == 1)
            C(k) = 1;
        end
    end
    
    %Check if points lie outside of boundary 
    bx = points(k,1) < map.boundary(1) | points(k,1) > map.boundary(4);
    by = points(k,2) < map.boundary(2) | points(k,2) > map.boundary(5);
    bz = points(k,3) < map.boundary(3) | points(k,3) > map.boundary(6);
    bound = bx | by | bz;
    if  (max(bound) == 1)
        C(k) = 1;
    end
end

end

