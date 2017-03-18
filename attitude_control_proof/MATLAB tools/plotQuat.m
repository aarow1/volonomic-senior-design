% q = [0.70,	-0.22,	-0.64,	-0.22] % x down
% q = [0.62,	0.61,	-0.37,	-0.34] % y down
% q = [0.98,	0.01,	-0.00,	-0.21] % z down
% q = [1.6 0 -1.61 0];
% q = [-.25 .25 .64 -.7]
close all;
q = [-.07 -.97 .23 .01]; %w/o rotation, raw
 q_on = [-1 0 0 0]; %onboard rotated
rot = [0 1 0 0]; % convert from imu NED to NWU
figure();
q_rot = qmultiply(rot,q);

r = quat2rotm(q_rot);
% r = [1 0 0; 0 -1 0; 0 0 -1] * r;

b = q; a = rot;
  c(1) = b(1) * a(1) - b(2) * a(2) - b(3) * a(3) - b(4) * a(4);
  c(2) = b(1) * a(2) + b(2) * a(1) - b(3) * a(4) + b(4) * a(3);
  c(3) = b(1) * a(3) + b(2) * a(4) + b(3) * a(1) - b(4) * a(2);
  c(4) = b(1) * a(4) - b(2) * a(3) + b(3) * a(2) + b(4) * a(1);

% plotCoordinateFrame(r, 0, [0 0 1]);
% title('rotated off board');
% axis equal;
% grid on;
% axis([-2 2 -2 2 -2 2]);

figure();
plotCoordinateFrame(quat2rotm(q), 0, [0 0 1]);
title('raw');
axis equal;
grid on;
axis([-2 2 -2 2 -2 2]);

% figure();
% plotCoordinateFrame(quat2rotm(q_on), 0, [0 0 1]);
% title('on board');
% axis equal;
% grid on;
% axis([-2 2 -2 2 -2 2]);
% 
% figure();
% plotCoordinateFrame(quat2rotm(c), 0, [0 0 1]);
% title('on board calcs');
% axis equal;
% grid on;
% axis([-2 2 -2 2 -2 2]);