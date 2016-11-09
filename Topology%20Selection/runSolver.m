clearvars -except A
display('-----START-----')
display(['timestamp: ' datestr(now, 'HH:MM:SS')])

step = pi/6;
b = b_gen6(step);

% b = [1 0 0];
% B = [1 0 -1 0; 0 1 0 -1; -1 1 -1 1];

% [m,n,o] = size(A);
% nCases = o;
% modsplit = 50;
% if ((nCases/modsplit) > moplit)
%     modsplit = (nCases/modsplit);
% end
% fprintf('Solving %d Cases\n',nCases);
% sumT = 0;
% ctr = 1;
tic;
solver_step = 8;
nstep = 20;
c = 0;

modsplit = 1;
for i = 0:nstep-1
    lwr = 200000+i*solver_step; upr = lwr+solver_step;
    p_A = []; wrench = []; n = []; Amax = [];
    parfor k = 1:solver_step
        %     tic;
        %recall position matrix
        p_A = A(:,:,k+lwr);
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
    c = max([c n]);
    % T = toc
    % [~,I] = max(n);s
    % Amax = A(:,:,I);
    % Q = Amax(1:3,:);
    % P = -cross(Q,Amax(4:6,:));
    % quiver3(P(1,:),P(2,:),P(3,:),Q(1,:),Q(2,:),Q(3,:));
    % hold on
    % quiver3(zeros(1,7),zeros(1,7),zeros(1,7),P(1,:),P(2,:),P(3,:));
    T = toc;
    data.Amax = Amax;
    data.n = n;
    data.wrench = wrench;
    angle = 'pi_6-';
    range = strcat(num2str(lwr),'-',num2str(upr));
    filename = strcat(angle,range);
    save(filename,'data');
    
    if (mod(i+1,modsplit) == 0)
    fprintf('%02d / %02d - %05.0f min / %05.0f min\n',...
        i+1, nstep, T/60, (T/(i+1)*nstep)/60);
    display(['timestamp: ' datestr(now, 'HH:MM:SS')])
     fprintf('c: %03d\n\n',c);
    end
end