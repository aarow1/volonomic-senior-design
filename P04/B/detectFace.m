function [ boundBox ] = detectFace( img,faceBox )
%detect faces using Viola-Jones algorithm
%input: img with faces
%output: bounding boxes [x y h w]
faceDetector = vision.CascadeObjectDetector('UseROI',true,'MergeThreshold',20,'MinSize',[180 180]);
boundBox = step(faceDetector,img,faceBox);

faceImg = insertObjectAnnotation(img,'rectangle',boundBox,'Face');
% figure; imshow(faceImg);
end
