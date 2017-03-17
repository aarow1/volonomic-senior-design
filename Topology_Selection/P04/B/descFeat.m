function [ winOrient, tileBins] = descFeat( featurePts,img )
%input: list of featurePts of one face, img
%output: array of orientation, list of histogram bins of tiles for each
%feature
imgGray = double(padarray(rgb2gray(img),[8 8]));

winSz = 16;
tileSz = 4;
binStep = pi/18;
binStepTile = pi/4;
%calculate 2d gauss
gaussWin = zeros(winSz);
for i = 1:winSz
    for j = 1:winSz
        gaussWin(i,j) = gauss2d(j,winSz/2,i,winSz/2);
    end
end

gaussTile = zeros(tileSz);
for i = 1:tileSz
    for j = 1:tileSz
        gaussTile(i,j) = gauss2d(j,tileSz/2,i,tileSz/2);
    end
end

locPts = uint16(featurePts.Location)+winSz/2;
l = length(locPts);
winOrient = zeros(1,l);
tileBins = zeros(128,l);
for i = 1:length(locPts)
    %make window around feature point
    win = img(locPts(i,2):locPts(i,2)+winSz-1,locPts(i,1):locPts(i,1)+winSz-1);
    [magMat, dirMat] = imgradient(win);
    dirMat = deg2rad(dirMat);
    gaussMat = magMat .* gaussWin; %gaussain dropoff
    bounds = -pi:binStep:pi;
    binWin = discretize(dirMat, bounds); % matrix of bin that each orientation is in
    binWin = binWin(:);
    gaussMat = gaussMat(:);
    hist = zeros(length(bounds),1);
    for x = 1:length(binWin)
        hist(binWin(x)) = gaussMat(x) + hist(binWin(x));
    end
    [~,idx] = max(hist);
    low_bound = bounds(idx); %lower bound of most common bin
    
    winOrient(i) = low_bound; %store orientation
tileStore = [];
    for x = 1:4
        for y = 1:4
            magTile = magMat(x:x+3, y:y+3);
            dirTile = dirMat(x:x+3, y:y+3);
            gaussMatTile = magTile .* gaussTile;
            
            boundsTile = -pi:binStepTile:pi;
            binTile = discretize(dirTile,boundsTile);
            binTile = binTile(:);
            gaussMatTile = gaussMatTile (:);
            histTile = zeros(length(boundsTile)-1,1);
            for z = 1:length(binTile)
                histTile(binTile(z)) = gaussMatTile(z) + histTile(binTile(z));
            end
            histTile = histTile - low_bound;
            tileStore = [tileStore; histTile];
        end
    end
    tileBins(:,i) = tileStore;
end
end
% end
% for i = 1:n
%     locPts = double(featurePts{1,i}.Location);
%     for j = 1:length(locPts)
%         win = img(locPts(i,1):locPts(i,1)+winSz-1,locPts(i,2):locPts(i,2)+winSz-1);
%         [magMat, dirMat] = imgradient(win);
%         %         [mag{i,j}, dir{i,j}] = imgradient(win);
%         %         magMat = cell2mat(mag{i,j});
%         %         dirMat = cell2mat(dir{i,j});
%         gaussMat = magMat .* gaussWin;
%         %         thresh = max(mag{i,j})/3;
%         %         thresh = 0;
%         %         filterMat = dirMat(abs(magMat)>thresh);
%         %         filterMat = deg2rad(filterMat);
%         bounds = -pi:binStep:pi;
%         binWin = discretize(dirMat, bounds); % matrix of bin that each orientation is in
%         %         for k = 1:length(bounds)-1
%         binWin = binWin(:);
%         gaussMat = gaussMat(:);
%         hist = zeros(length(bounds),1);
%         for x = 1:length(binWin)
%             hist(binWin(x)) = gaussMat(x) + hist(binWin(x));
%         end
%         %         hist = sum(gaussMat(find(y = 1
%         %         discMat = binStep*y;
%         %         y = histcounts(filterMat,bounds);
%         [~,idx] = max(hist);
%         low_bound = bounds(idx); %lower bound of most common bin
%
%         winOrient(i,j) = low_bound; %store orientation
%         binStepTile = pi/4;
%         for x = 1:4
%             for y = 1:4
%                 magTile = magMat(x:x+3, y:y+3);
%                 dirTile = dirMat(x:x+3, y:y+3);
%                 gaussMatTile = magTile .* gaussTile;
%
%                 boundsTile = -pi:binStepTile:pi;
%                 binTile = discretize(tile,boundsTile);
%                 binTile = binTile(:)
%                 gaussMatTile = gaussMatTile (:);
%                 histTile = zeros(length(boundsTile),1);
%                 for z = 1:length(binTile)
%                     histTile(binTile(z)) = gaussMatTile(z) + histTile(binTile(z));
%                 end
%                 histTile = histTile - low_bound;
%                 tileBins{i,j} = histTile;
%             end
%         end
%     end
% end
%
% end