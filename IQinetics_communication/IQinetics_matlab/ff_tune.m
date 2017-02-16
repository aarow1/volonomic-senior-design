start_volts = 0.6;
end_volts = 6;
num_tests = 100;
test_per_volt = 6;
volts_incr = (end_volts - start_volts) / num_tests;

obs_volt = zeros(num_tests*test_per_volt,1);
obs_vel = zeros(num_tests*test_per_volt,1);

mot.set('velocity_ff0', 0);
mot.set('velocity_ff1', 0);
mot.set('velocity_ff2', 0);
mot.set('velocity_Kp', 0);
mot.set('velocity_Ki', 0);
mot.set('velocity_Kd', 0);

pause(.5);

rampToSpeed(mot, start_volts, 2);
for test = 1:num_tests    
    mot.set('cmd_spin_volts', start_volts + volts_incr*test);
    
    sprintf('Testing cmd_spin_volts at %2.5f volts', ...
        start_volts + volts_incr*test)
    
    for t_volt = 1:test_per_volt;
        pauseWithPoll(com, .1);

        obs_volt(((test-1)*test_per_volt) + t_volt) = mot.get('drive_volts');
        obs_vel(((test-1)*test_per_volt) + t_volt) = mot.get('obs_velocity');
    end
end

save(['ff_data' datestr(now)]);

%%
hold on;
plot(obs_vel, obs_volt, 'x');
xlabel('speed [rad/s]');
ylabel('drive voltage');

% fit = polyfit(obs_volt, obs_vel, 2)
% x1 = linspace(0, max(obs_volt));
% y1 = polyval(fit, x1);
% plot(x1, y1, 'linewidth', 2);

fit2 = polyfit(obs_vel, obs_volt, 2)
x2 = linspace(min(obs_vel), max(obs_vel));
y2 = fit2(3) + x2*fit2(2) + x2.^2*fit2(1);
plot(x2, y2, 'linewidth', 2);

