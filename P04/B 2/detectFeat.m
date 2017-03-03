function [ featPts ] = detectFeat( boundBox,img )
%detect face features within a box
%input: boundingBox[nFaces, 4], img
%output: cornerPoints{1xnFaces}
imgGray = rgb2gray(img);
[m,n] = size(boundBox);
featPts = {};

figure; imshow(img); hold on;
for i = 1:m
%     featPts = detectHarrisFeatures(imgGray);
% box = boundBox(i,:);
% faceImg = insertObjectAnnotation(img,'rectangle',box,'Face');
% imshow(faceImg);
featPts{i} = detectMinEigenFeatures(imgGray,'ROI',boundBox(i,:));
% featPts = featPts.selectStrongest(100);
plot(featPts{1,i});

end

end


