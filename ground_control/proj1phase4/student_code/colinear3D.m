function [ tf ] = colinear3D( p1,p2,p3,t )
     tf = norm(cross(p1 - p2, p1 - p3))<= t;
end

