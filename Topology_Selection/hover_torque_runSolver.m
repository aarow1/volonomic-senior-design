clearvars -except c best_A
display('-----START-----')
display(['timestamp: ' datestr(now, 'HH:MM:SS')])

%% Parameters
step = pi/12;

% b_satisfy is the set of all necessary torques from all hovers
hover_force = 1;
torque_req = 0.25;
b_satisfy = b_gen_hover_torque(step, hover_force, torque_req);

% b_maximize
b_maximize = b_gen3_w(step);

%% Best configuration found
c = 0.7559;


best_A = [

   -0.9945    0.0955    0.7694   -0.0846    0.3090   -0.5000    0.9945
         0    0.2939   -0.5590   -0.0614   -0.9511    0.8660    0.1045
    0.1045    0.9511    0.3090   -0.9945    0.0000         0         0
   -0.1045   -0.2939    0.2500   -0.8046   -0.0000    0.8660   -0.1045
         0   -0.9045   -0.1816   -0.5846    0.0000    0.5000    0.9945
   -0.9945    0.3090   -0.9511    0.1045    1.0000         0         0 ];
% 
% c = 0.1;
% best_A = [];

tic;
delta = 0;

solver_step = 100000;
nstep = 100;
modsplit = 1;

t_start = now;

for i = 0:nstep-1
    A = real_rand_A_gen(solver_step, 60);

    parfor k = 1:solver_step
        %recall position matrix
        p_A = A(:,:,k);
        %maximize the minimum wrench
        [min_w] = check_A(p_A,b_satisfy, b_maximize, c);
        %store results
        
        n(k) = min_w;
        Amax(:,:,k) = p_A;
    end

    [max_c_found, best_ind] = max(n);
    
    if(max_c_found > c)
        fprintf('Found better c: %03d\n\n',max_c_found);
        best_A = A(:,:,best_ind)
        c = max_c_found;
    end
   
    %% print on modsplit
    if (mod(i+1,modsplit) == 0)
        
        delta = delta + toc;
        tic;
        n_total = nstep * solver_step;
        n_run = (i+1) * solver_step;
        n_left = n_total - n_run;
        
        fprintf('Configurations Checked: %02d / %02d\n', n_run, n_total);
        fprintf('Time Taken so far: %03f sec\n', delta);
        fprintf('Time Taken per A Configuration: %03f sec\n', (delta / n_run));
        fprintf('Time left to run: %03f sec\n', (delta / n_run) * (n_left));
        display(['timestamp: ' datestr(now, 'HH:MM:SS')])
        fprintf('c = %03d\n\n',c);
        
        % figure(1);
        % T = toc;
        
    end
end

c
best_A
figure(1);
Q = best_A(1:3,:);
P = -cross(Q,best_A(4:6,:));
quiver3(P(1,:),P(2,:),P(3,:),Q(1,:),Q(2,:),Q(3,:));
hold on
quiver3(zeros(1,7),zeros(1,7),zeros(1,7),P(1,:),P(2,:),P(3,:));
axis equal;
drawnow;
