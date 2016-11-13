clear; close all;
display('-----START-----')
display(['timestamp: ' datestr(now, 'HH:MM:SS')])

%    -0.5000    0.2676    0.4045   -0.7006    0.2676    1.0000    1.0000
%          0    0.8236   -0.2939   -0.5090   -0.8236   -0.0000   -0.0000
%    -0.8660    0.5000    0.8660   -0.5000    0.5000         0         0
%     0.8660   -0.1545    0.7006   -0.4045   -0.1545   -0.0000    0.0000
%          0   -0.4755   -0.5090   -0.2939    0.4755   -1.0000    1.0000
%    -0.5000    0.8660   -0.5000    0.8660    0.8660         0         0
% c = 6.621439e-01;

%% PARAMETERS
b_step = pi/6;
b = b_gen6(b_step);

maxMin_n = .662;
A_step = pi/10;

nstep = 24;
modsplit = 1;

saveData = 0;

tic;
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
    end
    T = toc;
    if (mod(i+1,modsplit) == 0)
        fprintf('%02d / %02d - %05.0f min / %05.0f min\n',...
            i, nstep, T/60, (T/(i)*nstep)/60);
        display(['timestamp: ' datestr(now, 'HH:MM:SS')])
    end
end