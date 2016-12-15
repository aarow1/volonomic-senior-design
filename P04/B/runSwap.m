clear all;
close all;
img = imread('Capture.png');
boundBox = detectFace(img);
features = detectFeat(boundBox,img);