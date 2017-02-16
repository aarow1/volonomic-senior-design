max_spd = 600;
num_cycles = 3;
period = .6;
delta_t = .005;
num_points = ceil(num_cycles*period/delta_t);

mot.set('velocity_ff0', 0);
mot.set('velocity_ff1', 0.004506239887297);
mot.set('velocity_ff2', 0.000000383741267);
mot.set('velocity_Kp', 0.03);
mot.set('velocity_Ki', 0.05);
mot.set('velocity_Kd', 0);
% mot.save_all();
pause(1);

vels = zeros(num_points,1);
spds = zeros(num_points,1);
ind = 1;

tic
for ii = 1:num_points
%     spd = max_spd * (ii/num_points) * sin((2*pi/period) * ii * delta_t);
    spd = max_spd * sin((2*pi/period) * ii * delta_t);
    spds(ii) = spd;
    
    mot.set('cmd_velocity', spd);
    while(toc < delta_t)
    end
    vels(ii) = mot.get('obs_velocity');
    %%
    % filterPoints = 10;
    % filtercoeffs = ones(1, filterPoints)/filterPoints;
    %
    % vels = filter(filtercoeffs, 1, vels);
end
    %%
    
    hold on;
    plot(spds);
    plot(vels);
    legend('in', 'out')
    grid on;