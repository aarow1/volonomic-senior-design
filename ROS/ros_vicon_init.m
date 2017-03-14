%% SET UP XBEE
xbee = serial('/dev/tty.usbserial-DN02MM5K')
set(xbee,'DataBits',8)
set(xbee,'StopBits',1)
set(xbee,'Parity','none')
set(xbee,'BaudRate',9600)
fopen(xbee);

%% SET UP ROS
%rosinit;
%rostopic list
global q_curr_vicon pos_vicon pos_gains q_des w_ff f_des

q_curr_vicon = zeros(1,4);
pos_vicon = zeros(1,3); pos_vicon_store = zeros(1,3);
            %kp kd ki
pos_gains = [1  1  0; %x
             1  1  0;  %y
             1  1  0];  %z
odom_sub = rossubscriber('/vicon/VI/pose', @pose_callback)

%if hit q, while loop with sending zero to motor speeds (sendPkt(alkdjfa);
%idk we need a loop somewhere, or something.