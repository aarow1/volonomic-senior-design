%% SET UP XBEE
% xbee = serial('/dev/tty.usbserial-DN02MM5K') %MAC
global xbee
xbee = serial('/dev/ttyUSB2') %LINUX
set(xbee,'DataBits',8)
set(xbee,'StopBits',1)
set(xbee,'Parity','none')
set(xbee,'BaudRate',9600)
fopen(xbee);

%% SET UP ROS
%rosinit;
%rostopic list
addpath 'VI FUNCTIONS'
global q_curr_vicon pos_vicon pos_gains q_des w_ff f_des vicon_on

% Global variables for vehicle position and stuff
global q_curr_vicon pos_vicon pos_gains q_des w_ff f_des

q_curr_vicon = zeros(1,4);
pos_vicon = zeros(1,3); pos_vicon_store = zeros(1,3);
        %kp kd ki
gains = [1  1  0];
pos_gains = [gains; %x
             gains; %y
             gains];%z
odom_sub = rossubscriber('/vicon/VI/pose', @pose_callback)
%%
% running = 1;
% customForce = .1*zeros(1,6);
% % sendPkt(lowForce);
% while running
%     inp = input('Press a button or some shit: ', 's');
%     inp = lower(inp);
%     
%     switch (inp)
%         case 'q'
%             sendPkt(zeros(1,6));
%             running = 0;
%         case 'u'
%             customForce = customForce+.05*ones(1,6)
%             sendPkt(customForce);
%         case 'j'
%             customForce = customForce-.05*ones(1,6)
%             sendPkt(customForce)
%         case 'z' 
%             customForce = zeros(1,6)
%             sendPkt(customForce);
%         case 'n'
%             q_des = [1 0 0 0]; w_ff = [0 0 0]; f_des = [0 0 0];
% %             q_curr_vicon = [1 0 0 0];
%             useVicon = 0;
%             sendPkt([],useVicon);
%         case 'v' 
%             q_des = [1 0 0 0]; w_ff = [0 0 0]; f_des = [0 0 0];
%             q_curr_vicon = [1 0 0 0];
%             useVicon = 1;
%             sendPkt([],useVicon);
%         case 'g'
%             gain_inp = input('input some gains: ', 's');
%             gains = [str2num(gain_inp)]
%             sendPkt([],[],gains);
%         otherwise
%             disp('fuck you');
%     end
% %     listen for inputs and things that will modify q_des, w_ff f_des
% end

%if hit q, while loop with sending zero to motor speeds (sendPkt(alkdjfa);
%idk we need a loop somewhere, or something.
