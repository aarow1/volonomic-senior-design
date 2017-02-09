
% mot.set('velocity_ff0', -0.019312895282361);
% mot.set('velocity_ff1', 0.004648555991083);
% mot.set('velocity_ff2', 0.000000121309706);

mot.set('velocity_ff0', 0);
mot.set('velocity_ff1', 0);
mot.set('velocity_ff2', 0);
mot.set('velocity_Kp', 0.03);
mot.set('velocity_Ki', 0.005);
mot.set('velocity_Kd', 0.00);
mot.save_all();
pause(1);

vels = zeros(400,1);
ind = 1;

num_tries = 8;

tic
for ii = 1:num_tries
    spd = 200 * (ii/num_tries) * (-1)^(ii)
    mot.set('cmd_velocity', spd);
    while(toc < 1)
        vels(ind) = mot.get('obs_velocity');
        ind = ind+1;
    end
    tic
end

hold on;
plot(vels);
grid on;