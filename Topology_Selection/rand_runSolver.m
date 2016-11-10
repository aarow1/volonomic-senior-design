clearvars
display('-----START-----')
display(['timestamp: ' datestr(now, 'HH:MM:SS')])

step = pi/6;
b = b_gen6(step);

% figure(1);
% h = plot(scat(1,:), scat(2,:), 'o-');
% hold on;

c = 1;

best_A = [
   -0.4630    0.1688   -0.8032   -0.5595   -0.2376   -0.8357   -0.9806
         0    0.5194    0.5835   -0.4065    0.7313    0.5492    0.1962
   -0.8864   -0.8377    0.1200   -0.7223   -0.6393         0         0
    0.8864    0.2589    0.0971   -0.5844    0.1976    0.5492   -0.1962
         0    0.7967   -0.0705   -0.4246   -0.6080    0.8357   -0.9806
   -0.4630    0.5462    0.9928    0.6915   -0.7690         0         0];
scat = zeros(2, 1);

tic;
delta = 0;

solver_step = 10;
nstep = 10;
modsplit = 1;

t_start = now;

for i = 0:nstep-1
    A = rand_A_gen(solver_step);
    p_A = []; wrench = []; n = []; Amax = [];
    parfor k = 1:solver_step
        %     tic;
        %recall position matrix
        p_A = A(:,:,k);
        %maximize the minimum wrench
        [min_w] = w_solver(p_A,b,c);
        %store results
        
        wrench(:,k) = min_w;
        n(k) = norm(min_w);
        Amax(:,:,k) = p_A;
        %     T = toc;
        %     sumT = sumT + T;
        %     if (mod(k,round(nCases/modsplit))==0)
        %         fprintf('%04d / %04d - %05.2f%% - %05.0f sec / %05.0f sec\n',...
        %             k, nCases, k/nCases*100, toc, toc/k*nCases);
        %     end
        % ctr = ctr + 1;
    end
    [max_c_found, best_ind] = max(n);
    
    if(max_c_found > c)
        fprintf('Found better c: %03d\n\n',max_c_found);
        best_A = A(:,:,best_ind)
        c = max_c_found;
    end
    
    scat = [scat, [i;c]];
    
    if (mod(i+1,modsplit) == 0)
        
        delta = delta + toc
        n_total = nstep * solver_step;
        n_run = (i+1) * solver_step;
        n_left = n_total - n_run;
        
        fprintf('%02d / %02d - %03d sec / %03d sec\n',...
            n_run, n_total, ...
            (delta / n_run), (delta / n_run) * (n_left));
        display(['timestamp: ' datestr(now, 'HH:MM:SS')])
        fprintf('c: %03d\n\n',c);
%         set(h, 'XData', scat(1,:));
%         set(h, 'YData', scat(2,:));
        drawnow;
        
    end
end

figure(2);
T = toc;
Q = best_A(1:3,:);
P = -cross(Q,best_A(4:6,:));
quiver3(P(1,:),P(2,:),P(3,:),Q(1,:),Q(2,:),Q(3,:));
hold on
quiver3(zeros(1,7),zeros(1,7),zeros(1,7),P(1,:),P(2,:),P(3,:));