function rampToVolts(motor, final, t)
% Ramp from present command voltage to final value in V in time t.

% get present value as starting value
motor.com.Flush();
init = [];
while isempty(init)
    init = motor.get('cmd_spin_volts');
end

% if present value is nan, let be zero
if isnan(init)
    init = 0;
end

% generate time series of values, and execute
N = round(1000*t/20); % 20ms step time
vect = linspace(init, final, N);
t_vect = linspace(0, t, N);
start_time = toc;
for k=1:N
    while toc < start_time + t_vect(k); end;    % wait here until time
    motor.set('cmd_spin_volts', vect(k));       % give next command
end
pause(0.020);
end