clear all
close all
clc

%% System parameters
tau_attitude = .5;
tau_w = .5;

J = [0.0106063129,	0.00030489483,	-0.00022202219;
0.00030489483,	0.01063727884,	0.00031613497;
-0.00022202219,	0.00031613497,	0.01058215165];

dt = .05;

% Define unit normals for props
X = [   1   0   0;
    1   0   0;
    0   1   0;
    0   1   0;
    0   0   1;
    0   0   1   ]';

% Define positions from center to props
r = 1; %distance from center to prop [m]
P = r * [ 0   1   0;
    0   -1  0;
    0   0   1;
    0   0   -1;
    1   0   0;
    -1  0   0   ]';

% Define Prop Force to Net Wrench Matrix: W = M * f_props
M = [X; cross(X, P)];

% Define Net Wrench to Prop Force Matrix: f_props = M_inv * W
M_inv = inv(M);

% Wrench = [force; torque];

%% State
%% Generate random quaternion
random_matrix = randn(3);

% Decompose the random matrix using QR decomposition.
[Q, R] = qr(random_matrix);

% Create what will be our rotation matrix by manipulation of Q and R.
% We call this R10 because it shows the orientation of frame 1 in frame 0.
R10 = Q*diag(sign(diag(R)));

% Valid rotation matrices must have determinant equal to +1.  Half of
% the matrices generated by the above method will have determinant
% equal to -1 because it is drawing from the O(3), the orthogonal
% group, rather than SO(3), the special orthogonal group.  Fix this by
% flipping the signs of one column if the determinant is not positive.
if (det(R10) < 0)
    R10(:,1) = -R10(:,1);
end

R10 = [0 1 0; -1 0 0; 0 0 1];

r_curr = R10; 
q_curr = rotm2quat(r_curr)
%%


% r_des = [1 0 0; 0 1 0; 0 0 1];
% q_des = rotm2quat(r_des)

% q_curr = [1 0 0 0];
q_des = [0 1 0 0];
% r_curr = quat2rotm(q_curr);
r_des = quat2rotm(q_des);

w_curr = zeros(3,1);
t_curr = zeros(3,1);

h_0 = plotCoordinateFrame(r_curr, 0, [0 0 1]);
h_1 = plotCoordinateFrame(r_des, 2, [0 1 0]);

axis equal;
% set(gca,'Perspective','on')
grid on;
axis([-2 2 -2 2 -2 2]);
drawnow();
pause(.1);

theta_err = 100;

%% Controls
% while abs(theta_err(end) - theta_err(end-1)) > .01
for n = 1:100;
    w_in = [0, 0, 0];
    q_des_dot = qmultiply((1/2) * q_des, [0, w_in]);
    
    q_des = q_des + q_des_dot * dt;
    
    q_err = qmultiply(quat_inverse(q_curr), q_des);
    
    theta_err = [theta_err rad2deg(2 * acos(q_err(1)))];
    
    w_ff = qmultiply(qmultiply(qmultiply...
        (2 * q_err, quat_inverse(q_des)), q_des_dot), quat_inverse(q_err));
    
    w_des = ((2 / tau_attitude) * sign_good(q_err(1))) * q_err(2:4)';
    w_des = w_des + w_ff(2:4)';
    
    torque = (1 / tau_w) * J * (w_des - w_curr) + cross(w_curr, J*w_curr);
    force = zeros(3,1);
    
    f_props = M_inv * [force; torque]
    
    w_curr = w_curr + torque * dt;
    
    q_dot = qmultiply((1/2) * q_curr, [0; w_curr]');
    q_curr = q_curr + q_dot * dt;
    
    r_curr = quat2rotm(q_curr);
    r_des = quat2rotm(q_des);
    
    %% Initial Plotting
    h_0 = plotCoordinateFrame(r_curr, 0, [0 0 1]);
    h_1 = plotCoordinateFrame(r_des, 2, [0 1 0]);
    
%     plotPropForces(f_props, r_curr, X, P);

    axis equal;
    grid on;
    axis([-2 2 -2 2 -2 2]);
%     view(0, 0);
    drawnow();
%     pause(dt);
    abs(theta_err(end));
    
%     frame = getframe(1);
%     im = frame2im(frame);
%     [imind,cm] = rgb2ind(im,256);
%     
%     if n == 1;
%         imwrite(imind,cm,'recording.gif','gif', 'Loopcount',inf);
%     else
%         imwrite(imind,cm,'recording.gif','gif','WriteMode','append');
%     end
    
    clf;

end;

plot(theta_err);