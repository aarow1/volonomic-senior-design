clear; close all;
display('-----START-----')
display(['timestamp: ' datestr(now, 'HH:MM:SS')])

<<<<<<< HEAD

% b = [1 0 0];
% B = [1 0 -1 0; 0 1 0 -1; -1 1 -1 1];
%
=======
>>>>>>> 5fdafda8bf6fa6173fface967652165d28964c87
%    -0.5000    0.2676    0.4045   -0.7006    0.2676    1.0000    1.0000
%          0    0.8236   -0.2939   -0.5090   -0.8236   -0.0000   -0.0000
%    -0.8660    0.5000    0.8660   -0.5000    0.5000         0         0
%     0.8660   -0.1545    0.7006   -0.4045   -0.1545   -0.0000    0.0000
%          0   -0.4755   -0.5090   -0.2939    0.4755   -1.0000    1.0000
%    -0.5000    0.8660   -0.5000    0.8660    0.8660         0         0
% c = 6.621439e-01;
<<<<<<< HEAD
% [m,n,o] = size(A);
% nCases = o;
% modsplit = 50;
% if ((nCases/modsplit) > moplit)
%     modsplit = (nCases/modsplit);
% end
% fprintf('Solving %d Cases\n',nCases);
% sumT = 0;
% ctr = 1;
=======
>>>>>>> 5fdafda8bf6fa6173fface967652165d28964c87

%% PARAMETERS
b_step = pi/6;
b = b_gen6(b_step);

maxMin_n = .662;
A_step = pi/5;

<<<<<<< HEAD
solver_step = 100000;
nstep = 37;
c = .5;
max_c_found = 0;
start_idx = 1;
=======
nstep = 24;
>>>>>>> 5fdafda8bf6fa6173fface967652165d28964c87
modsplit = 1;

saveData = 0;

tic;
<<<<<<< HEAD
%% ITERATE
for i = 0:nstep-1
    lwr = start_idx+i*solver_step; upr = lwr+solver_step;
    p_A = []; wrench = []; n = []; Amax = [];
    parfor k = 1:solver_step
        %     tic;
        %recall position matrix
        p_A = A(:,:,k+lwr-1);
        %maximize the minimum wrench
        [min_w] = notQuadProg(p_A,b,c);
        %store results
        
%         wrench(:,k) = min_w;
        n(k) = norm(min_w);
        %         Amax(:,:,k) = p_A;
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
        best_A = A(:,:,best_ind+lwr-1)
        c = max_c_found;
        Q = best_A(1:3,:);
        P = -cross(Q,best_A(4:6,:));
        quiver3(P(1,:),P(2,:),P(3,:),Q(1,:),Q(2,:),Q(3,:));
        hold on
        quiver3(zeros(1,7),zeros(1,7),zeros(1,7),P(1,:),P(2,:),P(3,:));
        hold off
    end
    %
    T = toc;
    % [~,I] = max(n);s
    % Amax = A(:,:,I);
    %     Q = Amax(1:3,:);
    %     P = -cross(Q,Amax(4:6,:));
    %     quiver3(P(1,:),P(2        bfsdfgdfgsdfgsdfgsdfgsdfgsdfgdsfgsdrgsdfgsdfgsgdsfggsdfgsdff,:),P(3,:),Q(1,:),Q(2,:),Q(3,:));
    %     hold on
    %     quiver3(zeros(1,7),zeros(1,7),zeros(1,7),P(1,:),P(2,:),P(3,:));
    %     T = toc;
    
    %save data
    if saveData
        data.Amax = Amax;
        data.n = n;
        data.wrench = wrench;
        angle = 'pi_6-';
        range = strcat(num2str(lwr),'-',num2str(upr));
        filename = strcat(angle,range);
        save(filename,'data');
=======
%% GENERATE As
thetaList = theta_gen_unique(A_step);

for i = 1:nstep
    thetaStep = round(length(thetaList)/nstep);
    lwr = (i-1)*thetaStep + 1;
    if i == nstep
        upr = length(thetaList);
    else
        upr = lwr+thetaStep-1;
    end
    A = A_gen_unique(thetaList(lwr:upr,:),A_step);
    [~,~,o] = size(A);
    %% ITERATE
    parfor k = 1:o
        p_A = A(:,:,k);
        min_w = notQuadProg(p_A,b,maxMin_n);
        if min_w ~= 0
            p_A
            fprintf('Found better maxMin: %03d\n\n',min_w);
        end
>>>>>>> 5fdafda8bf6fa6173fface967652165d28964c87
    end
    T = toc;
    if (mod(i+1,modsplit) == 0)
        fprintf('%02d / %02d - %05.0f min / %05.0f min\n',...
<<<<<<< HEAD
            i+1, nfiles, T/60, (T/(i+1)*nstep)/60);
=======
            i, nstep, T/60, (T/(i)*nstep)/60);
>>>>>>> 5fdafda8bf6fa6173fface967652165d28964c87
        display(['timestamp: ' datestr(now, 'HH:MM:SS')])
    end
end
