<<<<<<< HEAD
target_spd = 1450;
=======
target_spd = -50;
>>>>>>> a935cae90d82174606bdb40e969d3a671b94359f
margin = .9;
vels = [];
close all
ts = [];
<<<<<<< HEAD
pwms = [];
vs = [];
currents = [];
hold_time = 2;
=======
hold_time = 3;
>>>>>>> a935cae90d82174606bdb40e969d3a671b94359f
tic
while toc < hold_time
    mot.set('cmd_velocity', target_spd);
    vels = [vels mot.get('obs_velocity')];
    pwms = [pwms mot.get('drive_pwm')];
    currents = [currents mot.get('est_motor_amps')];
    vs = [vs mot.get('obs_supply_volts')];
    ts = [ts toc];
    
    if abs(vels(end)) < abs(margin*target_spd)
        tic
    end
end
subplot(2,2,1)
plot(ts,vels)
title('velocity')
grid on
subplot(2,2,2);
plot(ts,pwms)
title('pwm')
grid on
subplot(2,2,3);
plot(ts,currents)
title('current')
grid on
subplot(2,2,4);
plot(ts,vs)
title('volts')
grid on