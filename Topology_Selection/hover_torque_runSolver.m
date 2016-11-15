clearvars -except c best_A
display('-----START-----')
display(['timestamp: ' datestr(now, 'HH:MM:SS')])

%% Parameters
step = pi/6;

% b_satisfy is the set of all necessary torques from all hovers
hover_force = 1;
torque_req = 0.25;
b_satisfy = b_gen_hover_torque(step, hover_force, torque_req);

% b_maximize
b_maximize = b_gen3_w(step);

%% Best configuration found
% c = 1.3451;
% 
% 
% best_A = [
% 
%     0.8910   -0.1510    0.7493   -0.6916   -0.1798   -0.8090    0.9845
%          0   -0.4647   -0.5444   -0.5025    0.5533    0.5879    0.1752
%     0.4539    0.8725    0.3772   -0.5189   -0.8133         0         0
%    -0.4539   -0.2696    0.3051   -0.4198    0.2513    0.5879   -0.1752
%          0   -0.8298   -0.2217   -0.3050   -0.7735    0.8090    0.9845
%     0.8910   -0.4886   -0.9261    0.8548   -0.5818         0         0 ];

tic;
delta = 0;

solver_step = 10000;
nstep = 10;
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
        
        fprintf('%02d / %02d - %03f sec / %03f sec\n',...
            n_run, n_total, ...
            (delta / n_run), (delta / n_run) * (n_left));
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
