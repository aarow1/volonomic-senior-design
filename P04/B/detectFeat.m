function [ featPts ] = detectFeat( boundBox,img )
imgGray = rgb2gray(img);
[m,n] = size(boundBox);
featPts = {};

figure; imshow(img); hold on;
for i = 2
%     featPts = detectHarrisFeatures(imgGray);
faceImg = insertObjectAnnotation(img,'rectangle',boundBox(m,:),'Face');
featPts{i} = detectMinEigenFeatures(imgGray,'ROI',boundBox(m,:));
% featPts = featPts.selectStrongest(100);
 plot(featPts{1,i});
end


end

