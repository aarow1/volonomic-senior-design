clearvars -except c best_A
load('best_as.mat');
display('-----START-----')
display(['timestamp: ' datestr(now, 'HH:MM:SS')])

%% Parameters
b_step = pi/6;

% b_satisfy is the set of all necessary torques from all hovers
hover_force = 1;
torque_req = 0.25;
b_satisfy = b_gen_hover_torque(b_step, hover_force, torque_req);

% b_maximize
b_maximize = b_gen3_w(b_step);

% A generation options
A_gen = 'A_gen_rand';   %'A_gen_rand' 'A_gen_halton' 'A_gen_unique'
A_step = pi/60;         % this becomes pi/A_step in A_gen_rand

%solver options
w_solver = 'w_solver_LB'; %'w_solver' 'check_A' 'w_solver_LB' 'notQuadProg'
solver_step = 10;      % number of Amats at a time
nstep = 10;             % number of A batches
modsplit = 1;

%% Best configurations found
% Store the best n matrices to try to draw connections between the best ones found

n_configs_saved = 10;   % Number of best A configs to save
% c = zeros(n_configs_saved, 1);
% best_A = zeros(6, 7, n_configs_saved);

% c(1) = 0.7559;
% 
% best_A(:,:,1) = [
% 
%    -0.9945    0.0955    0.7694   -0.0846    0.3090   -0.5000    0.9945
%          0    0.2939   -0.5590   -0.0614   -0.9511    0.8660    0.1045
%     0.1045    0.9511    0.3090   -0.9945    0.0000         0         0
%    -0.1045   -0.2939    0.2500   -0.8046   -0.0000    0.8660   -0.1045
%          0   -0.9045   -0.1816   -0.5846    0.0000    0.5000    0.9945
%    -0.9945    0.3090   -0.9511    0.1045    1.0000         0         0 ];

% c(1) = 0.1; 
% best_A = [];

tic;
delta = 0;

t_start = now;

for i = 0:nstep-1
    A = feval(A_gen,solver_step,A_step);
    [~,~,n_Amats] = size(A);

    n = zeros(n_Amats, 1);
    
    parfor k = 1:n_Amats
        %recall position matrix
        p_A = A(:,:,k);
        %maximize the minimum wrench
        [min_w] = feval(w_solver, p_A,b_satisfy, b_maximize, c(n_configs_saved));
        %store results
       
        n(k) = min_w;
    end

    for k = 1:n_Amats
      if (n(k) ~= 0)
        c = cat(1, c, n(k));
        best_A = cat(3, best_A, A(:,:,k));
      end
    end

    [c, ind] = sort(c, 'descend');
    c = c(1:n_configs_saved);
    ind = ind(1:n_configs_saved);
    best_A = best_A(:,:,ind);

%     [max_c_found, best_ind] = max(n);
%     
%     if(max_c_found > c)
%         fprintf('Found better c: %03d\n\n',max_c_found);
%         best_A = A(:,:,best_ind)
%         c = max_c_found;
%     end
   
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
        fprintf('c = %03d\n\n',c(1));
        
        % figure(1);
        % T = toc;
        
    end
end

c;
best_A;

save('best_as.mat', 'c', 'best_A');
for i = 1:length(c)
figure(i);
    Q = best_A(1:3,:,i);
    P = -cross(Q,best_A(4:6,:, i));
    quiver3(P(1,:),P(2,:),P(3,:),Q(1,:),Q(2,:),Q(3,:));
    hold on;
    quiver3(zeros(1,7),zeros(1,7),zeros(1,7),P(1,:),P(2,:),P(3,:));
    axis equal;
    xlabel('x'); ylabel('y'); zlabel('z');
    drawnow;
end
