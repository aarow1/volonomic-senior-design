function [] = set_motor_speeds(cmd)
% increases and decreses motor speed from previous command
% INPUT: 'u' -- up by .1
%        'd' -- down by .1
%        'z' -- zero

%% Including global variables
global motor_speeds incr
%% 
if cmd == 'u'
    motor_speeds = motor_speeds+(incr*ones(1,6));
elseif cmd == 'd'
    motor_speeds = motor_speeds-(incr*ones(1,6));
elseif cmd == 'z'
    motor_speeds = zeros(1,6);    
end   
sendPkt('motor_speeds')
fprintf('motor speeds = [%i \t%i \t%i \t%i \t%i \t%i]\n', motor_speeds(1),motor_speeds(2),...
    motor_speeds(3),motor_speeds(4),motor_speeds(5),motor_speeds(6));
end

