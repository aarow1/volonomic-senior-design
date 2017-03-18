clear all

%% SET UP GLOBAL VARIABLES
global q_des w_ff f_des
q_des = [1 0 0 0];
w_ff = [0 0 0];
f_des = [0 0 0];

global motor_forces motor_speeds
motor_forces = zeros(1,6);
motor_speeds = zeros(1,6);

global tau_att tau_w
tau_att = .05;
tau_w = .01;

global using_vicon
using_vicon = 0;

global using_xbee
using_xbee = 1;

%% SET UP XBEE
if using_xbee
    global xbee
    xbee = serial('/dev/tty.usbserial-DN02MM5K') %MAC
    % xbee = serial('/dev/ttyUSB2') %LINUX

    set(xbee,'DataBits',8)
    set(xbee,'StopBits',1)
    set(xbee,'Parity','none')
    set(xbee,'BaudRate',9600)
    fopen(xbee);
end

%% SET UP ROS
if (using_vicon)
    global q_curr_vicon pos_vicon pos_gains
    rosinit;
    odom_sub = rossubscriber('/vicon/VI/pose', @pose_callback);
end
