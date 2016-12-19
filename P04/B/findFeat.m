function [ box ] = findFeat( img,boundBox,name,showImg )
%detect features using MatLab CascadeObjectDetector
%input: image, boundBox of face, name of feature to detect, show image
%output: box around feature [x y h w]
featDetect = vision.CascadeObjectDetector(name,'MergeThreshold',15,'UseROI',true);
[m,n] = size(boundBox);
if showImg
    figure();
    imshow(img);hold on;
end
for i = 1:m
    try
        box_temp = step(featDetect,img,boundBox(i,:));
        box(i,:) = box_temp(1,:);
        if showImg
            rectangle('Position',boundBox(i,:),'LineWidth',2,'LineStyle','-','EdgeColor','r');
            rectangle('Position',box(i,:),'LineWidth',4,'LineStyle','-','EdgeColor','b');
        end
    catch
        box(i,:) = NaN;
    end
end
hold off;
end
