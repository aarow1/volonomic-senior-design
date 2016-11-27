close all;
clear all;
%read in images
sourceImg = imread('source.jpg');
targetImg = imread('target.jpg');

%create mask
[mask] = maskImage(sourceImg);
%blend image using hardcoded x and y offsets
[resultImg] = seamlessCloningPoisson(sourceImg, targetImg, mask, 75, 100);
%show image
figure();
imshow(resultImg);