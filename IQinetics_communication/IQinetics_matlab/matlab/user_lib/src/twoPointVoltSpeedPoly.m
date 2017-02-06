function [ff0, ff1, ff2] = twoPointVoltSpeedPoly(motor, V1, V2)

motor.set('cmd_volts', 0);

rampToVolts(motor, V1, 2);
pauseWithPoll(motor.com, 2.0);
s = zeros(1,100);
for k=1:numel(s)
    s(k) = motor.get('act_speed');
    pause(0.01);
end
S1 = mean(s);

rampToVolts(motor, V2, 2);
pauseWithPoll(motor.com, 2.0);
for k=1:numel(s)
    s(k) = motor.get('act_speed');
    pause(0.01);
end
S2 = mean(s);

motor.set('cmd_coast');

% solve([V1 == ff2*S1^2 + ff1*S1, V2 == ff2*S2^2 + ff1*S2], ff2, ff1)
ff0 = 0;
ff1 = (V2*S1^2 - V1*S2^2)/(S1*S2*(S1 - S2));
ff2 = -(S1*V2 - S2*V1)/(S1*S2*(S1 - S2));

fprintf('%f rad/s @ %f V\n', S1, V1);
fprintf('%f rad/s @ %f V\n', S2, V2);

end