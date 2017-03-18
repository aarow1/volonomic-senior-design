q = [0.70,	-0.22,	-0.64,	-0.22] % x down
q = [0.62,	0.61,	-0.37,	-0.34] % y down
q = [0.98,	0.01,	-0.00,	-0.21] % z down

rot = [0 1 0 0]; % convert from imu NED to NWU

q_rot = qmultiply(rot, q);

r = quat2rotm(q_rot);
% r = [1 0 0; 0 -1 0; 0 0 -1] * r;

plotCoordinateFrame(r, 0, [0 0 1]);
axis equal;
grid on;
axis([-2 2 -2 2 -2 2]);