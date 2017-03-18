function [] = set_motor_speeds(cmd)
% increases and decreses motor speed from previous command
% INPUT: 'u' -- up by .1
%        'd' -- down by .1
%        'z' -- zero

%% Including global variables
global motor_speeds

%% 
if cmd == 'u'
    motor_speeds = motor_speeds+(10*ones(1,6));
elseif cmd == 'd'
    motor_speeds = motor_speeds-.1*ones(1,6);
elseif cmd == 'z'
    motor_speeds = zeros(1,6);    
end   
sendPkt('motor_speeds')
disp(currSpeed);
end

