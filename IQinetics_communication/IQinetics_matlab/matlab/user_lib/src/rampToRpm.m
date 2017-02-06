function rampToRpm(motor, final, t)
% Ramp from present observed speed to final value in RPM in time t.

final = final*pi/30;
rampToSpeed(motor, final, t);

end