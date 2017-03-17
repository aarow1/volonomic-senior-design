function z = qmultiply(x,y)

% Pull out the scalar part of each of our input quaternions.
x0 = x(1);
y0 = y(1);

% Pull out the vector part of each of our input quaternions.
xv = (x(2:4))';
yv = (y(2:4))';

% Calculate the scalar part of the output quaternion.
z0 = x0*y0 - xv'*yv;

% Calculate the vector part of the output quaternion.
zv = x0*yv + y0*xv + cross(xv,yv);

% Put them together in a row vector.
z = [z0 zv'];