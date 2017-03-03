function [ box ] = findFeat( img,boundBox,name )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
featDetect = vision.CascadeObjectDetector(name,'MergeThreshold',1,'UseROI',true);
[m,n] = size(boundBox);
figure();
imshow(img);hold on;
for i = 1:m
    try
    box_temp = step(featDetect,img,boundBox(i,:));
    box(i,:) = box_temp(1,:);
    rectangle('Position',box(i,:),'LineWidth',4,'LineStyle','-','EdgeColor','b');
    catch
        box(i,:) = NaN;
    end
end
hold off;
end