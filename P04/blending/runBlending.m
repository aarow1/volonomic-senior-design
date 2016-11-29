close all;
clear all;
%read in images
sourceImg = imread('source.jpg');
targetImg = imread('target.jpg');
[tm,tn] = size(targetImg);
targetImg = targetImg(1:tm-(mod(tm,2)),1:tn-(mod(tn,2)));
[tm,tn] = size(targetImg);    
[sm,sn] = size(sourceImg);
souceImg = padarray(sourceImg,[(tm-sm)/2 (tn-sn)/2 0]);

%create mask
[mask] = maskImage(sourceImg);
%blend image using hardcoded x and y offsets
[resultImg] = seamlessCloningPoisson(sourceImg, targetImg, mask, 75, 100);
%show image
figure();
imshow(resultImg);