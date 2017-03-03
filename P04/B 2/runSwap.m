% http://people.csail.mit.edu/hasinoff/320/sift-notes.txt
% http://www.cs.ubc.ca/~lowe/papers/ijcv04.pdf

% clearvars -except boundBox featPts
close all;
img = imread('Capture.png');

boundBox = detectFaceSIFT(img);
featPts = detectFeat(boundBox,img);
[m,n] = size(featPts);

[m1,n1] = size(featPts{1});
[m2,n2] = size(featPts{2});
[~,x] = max([m1,m2]);
featPts{x} = featPts{x}.selectStrongest(min([m1,m2]));

[winOrient1, tileBins1] = descFeat(featPts{1},img);
[winOrient2, tileBins2] = descFeat(featPts{2},img);

%%
match = matchFeat(tileBins1, tileBins2);

ptLoc1 = double(featPts{1}.Location);
ptLoc2 = double(featPts{2}.Location);
x1 = []; x2 = []; y1 = []; y2 = [];
for i = 1:length(match)
    if match(i) ~= -1
        x1 = [x1 ptLoc1(i,1)];
        x2 = [x2 ptLoc2(match(i),1)];
        y1 = [y1 ptLoc1(i,2)];
        y2 = [y2 ptLoc2(match(i),2)];
    end
end
hold on;
plot([x1; x2],[y1;y2])