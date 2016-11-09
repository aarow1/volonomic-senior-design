function g = Rot3D(axis,angle)
if axis == 'x' 
    g = [1 0 0 0; 0 cos(angle) -sin(angle) 0; 0 sin(angle) cos(angle) 0; 0 0 0 1];
elseif axis == 'y' 
    g = [cos(angle) 0 sin(angle) 0; 0 1 0 0; -sin(angle) 0 cos(angle) 0; 0 0 0 1];
elseif axis == 'z'
    g = [cos(angle) -sin(angle) 0 0; sin(angle) cos(angle) 0 0; 0 0 1 0; 0 0 0 1];
end