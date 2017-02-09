data_points = 50;
num_tests = 5;
test_param = 'velocity_Ki';
start_val = 0.07;
incr = 0.01;

speed = 200;
current_spd = 0;

mot.set('velocity_ff0', -0.019312895282361);
mot.set('velocity_ff1', 0.004648555991083);
mot.set('velocity_ff2', 0.000000121309706);
mot.set('velocity_Kp', 0.01);
mot.set('velocity_Ki', 0.04);
mot.set('velocity_Kd', 0);

pause(1);


obs_vels = zeros(data_points, num_tests);
obs_time = zeros(data_points, num_tests);

for test = 1:num_tests
    mot.set(test_param, start_val + incr * test);
    pause(1);
    
    sprintf('Testing %s at %2.5f', test_param, start_val + incr * test)
    
    mot.set('cmd_velocity', speed);
    
    tic
    
    for i = 1:30;
        obs_vels(i, test) = mot.get('obs_velocity');
        obs_time(i, test) = toc;
        pause(.01);
    end
    
    pause(1);
    while(mot.get('obs_velocity') > 0)
        pause(.1);
    end
end

%%
hold on;
for ii = 1:num_tests
    plot(obs_time(:,ii), obs_vels(:,ii));
end
legend(1:num_tests); 
% plot(obs_time, speed, '--');
