close all
clear all

%% SET UP GLOBAL VARIABLES
global using_vicon send_vicon
using_vicon = 1;
global using_xbee
using_xbee = 1;

% ------ shouldn't need to change anything below here ------ %
global q_des w_ff f_des
global motor_forces motor_speeds incr
global tau_att tau_w ki_torque gains_store
gains_store.gains = [0 0 0]; gains_store.time = datetime('now');
q_des = [1 0 0 0]; w_ff = zeros(1,3); f_des = zeros(1,3);
motor_forces = zeros(1,6); motor_speeds = zeros(1,6); incr = 10;
if isempty(tau_att)
    tau_att = 0;
end
if isempty(tau_w)
    tau_w = 0;
end
if isempty(ki_torque)
    ki_torque = 0;
end
send_vicon = 0;
tic;
%% SET UP XBEE
global xbee

if using_xbee
    %     xbee = serial('/dev/tty.usbserial-DN02MM5K') %MAC
    xbee = serial('/dev/ttyUSB0'); %LINUX
    set(xbee,'DataBits',8)
    set(xbee,'StopBits',1)
    set(xbee,'Parity','none')
    set(xbee,'BaudRate',57600)
    fopen(xbee);
    xbee
end

%% SET UP ROS
if using_vicon
    rosshutdown;
    addpath 'MATLAB tools'
    global q_curr_vicon pos_vicon pos_des pos_store_new pos_control_on gains w_vicon ping_time
    global follow_traj waypoints C way_times
    global quat_store time_store
    global home_pos home_quat
    global v_des w_des
    global cubic
    cubic = 0;
    v_des = .3; w_des = 15;
    follow_traj = 0; waypoints = [0 0 0 0 0 0]; way_times = 0; C = [0 0; 0 0];
    send_vicon = 0; pos_control_on = 0; pos_store_new = []; quat_store = []; time_store = [];
    q_curr_vicon = [1 0 0 0]; pos_vicon = zeros(1,3); w_vicon = zeros(1,6);
    if isempty(pos_des)
        pos_des = zeros(1,3);
    end
    if isempty(gains)
        gains = [1 0 0];
    end
    
    rosinit();
    odom_sub = rossubscriber('/vicon/VI/odom','nav_msgs/Odometry',@pose_callback);
    %     packet_pub = rospublisher('/xbee_packets', 'std_msgs/ByteMultiArray');
    tic;
end
