function [ idxList ] = matchFeat( featurePts,img )
imgGray = double(padarray(rgb2gray(img),[8 8]));

[m,n] = size(featurePts);
winSz = 16;
for i = 1:n
    locPts = double(featurePts{1,i}.Location);
    for j = 1:length(locPts)
        window = img(locPts(i,1):locPts(i,1)+winSz-1,locPts(i,2):locPts(i,2)+winSz-1);
        [mag{i,j}, dir{i,j}] = imgradient(window);
        magMat = cell2mat(mag{i,j}); dirMat = cell2mat(dir{i,j});
        thresh = max(mag{i,j})/3git;
        thresh = 0;
        filterMat = dirMat(abs(magMat)>thresh);
        filterMat = deg2rad(filterMat);
        bounds = -pi:pi/4:pi;
        y = discretize(filterMat, bounds);
        discMat = pi/4*y;
        
        histCells{i,j} = discMat;
    end 
end


end