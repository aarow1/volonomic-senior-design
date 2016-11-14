clearvars
display('-----START-----')
display(['timestamp: ' datestr(now, 'HH:MM:SS')])

%% Parameters
step = pi/6;

% b_satisfy is the set of all necessary torques from all hovers
hover_force = 1.5;
torque_req = 0.25;
b_satisfy = b_gen_hover_torque(step, hover_force, torque_req);

% b_maximize
b_maximize = b_gen3_w(step);

%% Best configuration found
c = 0.1;

best_A = [

   -0.9356   -0.1819   -0.5902   -0.0737    0.2886    0.8672    0.8635
         0   -0.5599    0.4288   -0.0536   -0.8882    0.4980    0.5043
   -0.3530    0.8083   -0.6840    0.9958   -0.3574         0         0
    0.3530   -0.2498   -0.5533    0.8057    0.1105    0.4980   -0.5043
         0   -0.7688    0.4020    0.5853   -0.3399   -0.8672    0.8635
   -0.9356   -0.5887    0.7295    0.0911    0.9339         0         0 ];

tic;
delta = 0;

solver_step = 10000;
nstep = 100;
modsplit = 1;

t_start = now;

for i = 0:nstep-1
    A = rand_A_gen(solver_step);

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
        
        delta = delta + toc
        n_total = nstep * solver_step;
        n_run = (i+1) * solver_step;
        n_left = n_total - n_run;
        
        fprintf('%02d / %02d - %03d sec / %03d sec\n',...
            n_run, n_total, ...
            (delta / n_run), (delta / n_run) * (n_left));
        display(['timestamp: ' datestr(now, 'HH:MM:SS')])
        fprintf('c = %03d\n\n',c);
        
        % figure(1);
        % T = toc;
        % Q = best_A(1:3,:);
        % P = -cross(Q,best_A(4:6,:));
        % quiver3(P(1,:),P(2,:),P(3,:),Q(1,:),Q(2,:),Q(3,:));
        % hold on
        % quiver3(zeros(1,7),zeros(1,7),zeros(1,7),P(1,:),P(2,:),P(3,:));
        % drawnow;
        
    end
end

c
best_A
