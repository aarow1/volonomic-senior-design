function [] = set_motor_speeds(cmd)
% increases and decreses motor speed from previous command
% INPUT: 'u' -- up by .1
%        'd' -- down by .1
%        'z' -- zero

%% Including global variables
global motor_forces

%% 
motor_speeds = .000121 * motor_forces.^2;

if cmd == 'u'
    motor_speeds = motor_speeds+(10*ones(1,6));
    disp('motor_speeds');
    disp(motor_speeds);
    
    sendPkt('mot_spd',motor_speeds);
    currSpeed = motor_speeds;
elseif cmd == 'd'
    motor_speeds = motor_speeds-.1*ones(1,6);
    disp(motor_speeds);
    sendPkt('mot_spd',motor_speeds);
    currSpeed = motor_speeds;
elseif cmd == 'z'
    sendPkt('mot_spd',zeros(1,6));
    currSpeed = zeros(1,6);
end   
disp(currSpeed);
motor_forces = 
end

