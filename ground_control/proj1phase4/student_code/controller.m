function [F, M, trpy, drpy,d] = controller(qd, t, qn, params)
% CONTROLLER quadrotor controller
% The current states are:
% qd{qn}.pos, qd{qn}.vel, qd{qn}.euler = [roll;pitch;yaw], qd{qn}.omega=pqr

% The desired states are:
% qd{qn}.pos_des, qd{qn}.vel_des, qd{qn}.acc_des, qd{qn}.yaw_des, qd{qn}.yawdot_des
% Using these current and desired states, you have to compute the desired controls

% =================== Your code goes here ===================
persistent gd;
graph = false;
time = 2;
angle = 'psi';

d = [1;1;1]';

%--Gains--%
%--Proportion--%
kp_phi = 0; %phi affects y
kp_theta = 0; %theta affects x
kp_psi = 0;
kp_x = 6; 
kp_y = 6;
kp_z = 18;
%--Derivative--%
kd_phi = sqrt(2) * kp_phi * 0.01;
kd_theta = sqrt(2) * kp_theta * 0.0095;
kd_psi = sqrt(2) * kp_psi * 0.007;
kd_x = sqrt(2) * kp_x * 0.65; %orig = 0.49
kd_y = sqrt(2) * kp_y * 0.65; %orig = 0.45
kd_z = sqrt(2) * kp_z * 0.3;



%--Errors--%
%Position
x_error = qd{qn}.pos_des(1) - qd{qn}.pos(1);
y_error = qd{qn}.pos_des(2) - qd{qn}.pos(2);
z_error = qd{qn}.pos_des(3) - qd{qn}.pos(3);
%Velocity
vx_error = qd{qn}.vel_des(1) - qd{qn}.vel(1);
vy_error = qd{qn}.vel_des(2) - qd{qn}.vel(2);
vz_error = qd{qn}.vel_des(3) - qd{qn}.vel(3);


%--Desired Acceleration--%
rddot_des = [(qd{qn}.acc_des(1) + kd_x*vx_error + kp_x*x_error);
    (qd{qn}.acc_des(2) + kd_y*vy_error + kp_y*y_error);
    (qd{qn}.acc_des(3) + kd_z*vz_error + kp_z*z_error)];

%--Desired phi, theta, yaw--%
phi_des = (1/params.grav) * (rddot_des(1)*sin(qd{qn}.yaw_des) - ...
    rddot_des(2)*cos(qd{qn}.yaw_des));
theta_des =(1/params.grav) * (rddot_des(1)*cos(qd{qn}.yaw_des) + ...
    rddot_des(2)*sin(qd{qn}.yaw_des));
psi_des = qd{qn}.yaw_des;

gd = [gd; t, psi_des, qd{qn}.euler(3)];  % for graphing

%--Graphing of Angles--%
if (graph)
    if t > time
     figure(4)
     % Desired in red
     plot(gd(:, 1), gd(:, 2), 'r')
     hold on
     % Actual in blue
     plot(gd(:,1), gd(:, 3), 'b');
     hold off
     legend('Desired angle', 'Actual angle')
     title(angle)
     xlabel('Time')
     ylabel('Angle')
    end
end

%--Desired pqr--%
p_des = 0;
q_des = 0;
r_des = qd{qn}.yawdot_des;

%--Errors--%
%Angle Errors
phi_error = phi_des - qd{qn}.euler(1);
theta_error = theta_des - qd{qn}.euler(2);
psi_error = psi_des - qd{qn}.euler(3);
%Velocity Errors
p_error = p_des - qd{qn}.omega(1);
q_error = q_des - qd{qn}.omega(2);
r_error = r_des - qd{qn}.omega(3);

%--Inputs--%
%u1 = params.mass * params.grav - ...
%    params.mass * (kd_z*qd{qn}.vel(3) + kp_z*z_error);
u1 = params.mass * params.grav + params.mass * rddot_des(3);

u2 = [kp_phi*(phi_error) + kd_phi*(p_error);
    kp_theta*(theta_error) + kd_theta*(q_error);
    kp_psi*(psi_error) + kd_psi*(r_error)];

%{
% Desired roll, pitch and yaw
phi_des = 0;
theta_des = 0;
psi_des = 0;
%}

% Thurst
F    = u1;

% Moment
M    = u2; % You should fill this in
% =================== Your code ends here ===================

% Output trpy and drpy as in hardware
trpy = [F, phi_des, theta_des, psi_des];
drpy = [0, 0,       0,         0];

end


%{
%Vertical force from rotor
F1 = kf*qd{qn}.omega^2;

%Moment from each rotor
M1 = km*omega^2;

u1 = F1+F2+F3+F4;
u2 = [0 L 0 -L;
    -L 0 L 0;
    gamma, -gamma gamma -gamma]*[F1 F2 F3 F4]';
%}
