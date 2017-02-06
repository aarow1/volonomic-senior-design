function rampToSpeed(motor, final, t)
% Ramp from present observed speed to final value in rad/s in time t.

% get present value as starting value
motor.com.Flush();
init = [];
while isempty(init)
    init = motor.get('obs_velocity');
end

% generate time series of values, and execute
N = round(1000*t/20); % 20ms step time
vect = linspace(init, final, N);
t_vect = linspace(0, t, N);
start_time = toc;
for k=1:N
    while toc < start_time + t_vect(k); end;    % wait here until time
    motor.set('cmd_velocity', vect(k));         % give next command
end
pause(0.020);
end