clear all

%% SET UP GLOBAL VARIABLES
global q_des w_ff f_des
global motor_forces motor_speeds incr
global tau_att tau_w

q_des = [1 0 0 0]; w_ff = zeros(1,3); f_des = zeros(1,3);
motor_forces = zeros(1,6); motor_speeds = zeros(1,6); incr = 10;
if isempty(tau_att)
    tau_att = 0;
end
if isempty(tau_w)
    tau_w = 0;
end

global using_vicon send_vicon
send_vicon = 0;
using_vicon = 1;
global using_xbee
using_xbee = 1;


%% SET UP XBEE
global xbee
if using_xbee && isempty(xbee)
    %     xbee = serial('/dev/tty.usbserial-DN02MM5K') %MAC
    xbee = serial('/dev/ttyUSB5') %LINUX

    set(xbee,'DataBits',8)
    set(xbee,'StopBits',1)
    set(xbee,'Parity','none')
    set(xbee,'BaudRate',57600)
    fopen(xbee);
end

%% SET UP ROS
if using_vicon
    global q_curr_vicon pos_vicon pos_des pos_control_on gains
    send_vicon = 0; pos_control_on = 0; 
    q_curr_vicon = [1 0 0 0]; pos_vicon = zeros(1,3);
    if isempty(pos_des)
    pos_des = zeros(1,3);
    end
    if isempty(gains)
    gains = [1 0 0];
    end
    rosshutdown;
    rosinit();
    odom_sub = rossubscriber('/vicon/VI/odom','nav_msgs/Odometry',@pose_callback);
end
