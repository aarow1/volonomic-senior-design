% clearvars -except A
clear all;
display('-----START-----')
display(['timestamp: ' datestr(now, 'HH:MM:SS')])

%
%    -0.5000    0.2676    0.4045   -0.7006    0.2676    1.0000    1.0000
%          0    0.8236   -0.2939   -0.5090   -0.8236   -0.0000   -0.0000
%    -0.8660    0.5000    0.8660   -0.5000    0.5000         0         0
%     0.8660   -0.1545    0.7006   -0.4045   -0.1545   -0.0000    0.0000
%          0   -0.4755   -0.5090   -0.2939    0.4755   -1.0000    1.0000
%    -0.5000    0.8660   -0.5000    0.8660    0.8660         0         0
<<<<<<< HEAD
=======

%          0    0.2676    0.2094   -0.2094   -0.2676   -0.9659    0.9659
%          0    0.8236   -0.1521   -0.1521    0.8236    0.2588    0.2588
%     1.0000    0.5000    0.9659   -0.9659   -0.5000         0         0
%    -1.0000   -0.1545    0.7815   -0.7815    0.1545    0.2588   -0.2588
%          0   -0.4755   -0.5678   -0.5678   -0.4755    0.9659    0.9659
%          0    0.8660   -0.2588    0.2588   -0.8660         0         0
>>>>>>> 5fdafda8bf6fa6173fface967652165d28964c87
% c = 6.621439e-01;

%% PARAMETERS
step = pi/6;
b = b_gen6(step);

nstep = 37;
c = .662;
max_c_found = 0;

saveData = 0;
best_A = zeros(6,7);
tic;

%% FILE SETUP
inputDir = './01-INPUT';
outputDir = './02-OUTPUT';

files = dir(inputDir);
nfiles = size(files,1)-2;
jobstamp = datestr(now, 'yyyy-mm-dd-HH-MM-SS');
mkdir(outputDir, jobstamp);

for f = 1:nfiles
    [~,loadName,loadExt] = fileparts(files(f+2).name);
    C = who('-file',[inputDir '/' loadName loadExt]);
    matName = C{1};
    s = load([inputDir '/' loadName loadExt],matName);
    A = s.(matName);
    [~,~,solver_step] = size(A);
    %% ITERATE
    parfor k = 1:solver_step
        %recall position matrix
        p_A = A(:,:,k);
        %maximize the minimum wrench
        [min_w] = notQuadProg(p_A,b,c);
        n(k) = norm(min_w);
<<<<<<< HEAD
    end
    [max_c_found, best_ind] = max(n);
    
    if(max_c_found > c)
        fprintf('Found better c: %03d\n\n',c);
        best_A = A(:,:,best_ind)
        c = max_c_found;
        Q = best_A(1:3,:);
        P = -cross(Q,best_A(4:6,:));
        quiver3(P(1,:),P(2,:),P(3,:),Q(1,:),Q(2,:),Q(3,:));
        hold on
        quiver3(zeros(1,7),zeros(1,7),zeros(1,7),P(1,:),P(2,:),P(3,:));
        hold off
    end
=======
        
        if (n(k) > c)
            p_A
            fprintf('norm(min_w): %03d\n\n',n(k));
        end
    end
%     [max_c_found, best_ind] = max(n);
    
%     if(max_c_found > c)
%         fprintf('Found better c: %03d\n\n',c);
%         best_A = A(:,:,best_ind)
% %         c = max_c_found;
%         Q = best_A(1:3,:);
%         P = -cross(Q,best_A(4:6,:));
%         quiver3(P(1,:),P(2,:),P(3,:),Q(1,:),Q(2,:),Q(3,:));
%         hold on
%         quiver3(zeros(1,7),zeros(1,7),zeros(1,7),P(1,:),P(2,:),P(3,:));
%         hold off
%     end
>>>>>>> 5fdafda8bf6fa6173fface967652165d28964c87
    
    movefile([inputDir '/' loadName loadExt],...
        [outputDir '/' jobstamp '/' loadName loadExt]);
    T = toc;
    fprintf('%02d / %02d - %05.0f min / %05.0f min\n',...
<<<<<<< HEAD
        f, nstep, T/60, (T/f*nfiles)/60);
=======
        f, nfiles, T/60, (T/f*nfiles)/60);
>>>>>>> 5fdafda8bf6fa6173fface967652165d28964c87
    display(['timestamp: ' datestr(now, 'HH:MM:SS')])
    fprintf('c: %03d\n\n',c);
end
