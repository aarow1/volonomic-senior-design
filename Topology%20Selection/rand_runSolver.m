clearvars
display('-----START-----')
display(['timestamp: ' datestr(now, 'HH:MM:SS')])

step = pi/6;
b = b_gen6(step);

tic;
solver_step = 20;
nstep = 1000;
% c = 1.455808;
c = 1.51569;

best_A = [
%    -0.6423    0.1452   -0.8088   -0.7787    0.2766   -0.7831   -0.5464
%          0    0.4469    0.5876   -0.5658   -0.8514   -0.6219   -0.8375
%    -0.7665   -0.8827    0.0215    0.2711   -0.4457         0         0
%     0.7665    0.2728    0.0174    0.2193    0.1377   -0.6219    0.8375
%          0    0.8395   -0.0126    0.1593   -0.4238    0.7831   -0.5464
%    -0.6423    0.4699    0.9998    0.9626    0.8952         0         0];
   -0.4630    0.1688   -0.8032   -0.5595   -0.2376   -0.8357   -0.9806
         0    0.5194    0.5835   -0.4065    0.7313    0.5492    0.1962
   -0.8864   -0.8377    0.1200   -0.7223   -0.6393         0         0
    0.8864    0.2589    0.0971   -0.5844    0.1976    0.5492   -0.1962
         0    0.7967   -0.0705   -0.4246   -0.6080    0.8357   -0.9806
   -0.4630    0.5462    0.9928    0.6915   -0.7690         0         0];
scat = zeros(2, 1);

% figure(1);
% h = plot(scat(1,:), scat(2,:), 'o-');
hold on;

modsplit = 10;
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
        fprintf('Found better c: %03d\n\n',c);
        best_A = A(:,:,best_ind)
        c = max_c_found;
    end
    
    scat = [scat, [i;c]];
    
    T = toc;
    
    if (mod(i+1,modsplit) == 0)
        fprintf('%02d / %02d - %05.0f sec / %05.0f sec\n',...
            i+1, nstep, T, (T/(i+1)*nstep));
        display(['timestamp: ' datestr(now, 'HH:MM:SS')])
        fprintf('c: %03d\n\n',c);
%         set(h, 'XData', scat(1,:));
%         set(h, 'YData', scat(2,:));
        drawnow;
        
    end
end

figure(2);
T = toc
Q = best_A(1:3,:);
P = -cross(Q,best_A(4:6,:));
quiver3(P(1,:),P(2,:),P(3,:),Q(1,:),Q(2,:),Q(3,:));
hold on
quiver3(zeros(1,7),zeros(1,7),zeros(1,7),P(1,:),P(2,:),P(3,:));