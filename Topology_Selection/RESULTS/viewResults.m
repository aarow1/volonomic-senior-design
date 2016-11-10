clear all; close all;
inputDir = './01-INPUT';
outputDir = './02-OUTPUT';
files = dir(inputDir);
nfiles = size(files,1)-2;
jobstamp = datestr(now, 'yyyy-mm-dd-HH-MM-SS');

mkdir(outputDir, jobstamp);
mkdir([outputDir '/' jobstamp], 'data');
maxMin_overall = 0;
maxA_overall = [];
% 
%     0.5000    0.3090    0.7006   -0.8090   -0.2676   -0.0000   -1.0000
%          0    0.9511   -0.5090   -0.5878    0.8236   -1.0000    0.0000
%    -0.8660    0.0000    0.5000    0.0000    0.5000         0         0
%     0.8660   -0.0000    0.4045    0.0000   -0.1545   -1.0000   -0.0000
%          0   -0.0000   -0.2939    0.0000    0.4755    0.0000   -1.0000
%     0.5000    1.0000   -0.8660    1.0000   -0.8660         0         0

for i = 1:nfiles
    [~,loadName,loadExt] = fileparts(files(i+2).name);
    load([inputDir '/' loadName loadExt]);
    Amax = data.Amax;
    w = data.n;
    
    if ~isempty(w)
    
    n = length(w);
%     curr_n = 0;
    for j = 1:n
        curr_n = w(j);
        if (curr_n > maxMin_overall)
            A = Amax(:,:,j);
            maxA_overall = A;
            maxMin_overall = max(maxMin_overall, curr_n);
            Q = A(1:3,:);
            P = -cross(Q,A(4:6,:));
            quiver3(P(1,:),P(2,:),P(3,:),Q(1,:),Q(2,:),Q(3,:));
            hold on
            quiver3(zeros(1,7),zeros(1,7),zeros(1,7),P(1,:),P(2,:),P(3,:));
            hold off;
            figName = 'f';
            savefig([outputDir '/' jobstamp '/' figName loadName '_' num2str(j)]);
            fprintf('maxMin_wrench = %03d\n',w(j));
            close;
        end
    end
    end
    movefile([inputDir '/' loadName loadExt],...
        [outputDir '/' jobstamp '/' 'data' '/' loadName loadExt]);
    
end
