close all;
clear all;
%read in images
sourceImg = imread('source.jpg');
figure;
hold on;
imshow(sourceImg);
title('sourceImg');
targetImg = imread('target.jpg');
figure;
hold on;
imshow(targetImg);
title('targetImg');

%% Make the images the same size (with padding)
[tm,tn,~] = size(targetImg);
targetImg = targetImg(1:tm-(mod(tm,2)),1:tn-(mod(tn,2)),:); %make size even

[sm,sn,~] = size(sourceImg);
sourceImg = sourceImg(1:sm-(mod(sm,2)),1:sn-(mod(sn,2)),:); %make size even

[tm,tn,~] = size(targetImg);    
[sm,sn,~] = size(sourceImg);
%pad source image to match target image size
sourceImg = padarray(sourceImg,[(tm-sm)/2 (tn-sn)/2 0]);

%create mask
[mask] = maskImage(sourceImg);
%blend image using hardcoded x and y offsets
[resultImg] = seamlessCloningPoisson(sourceImg, targetImg, mask, 75, 100);
%show image
figure();
imshow(resultImg);