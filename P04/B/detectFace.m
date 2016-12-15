function [ boundBox ] = detectFace( img )
%detect faces using Viola-Jones algorithm
%input: img with faces
%output: bounding boxes [x y h w]d
faceDetector = vision.CascadeObjectDetector();
boundBox = step(faceDetector,img);

faceImg = insertObjectAnnotation(img,'rectangle',boundBox,'Face');
figure; imshow(faceImg);
end

