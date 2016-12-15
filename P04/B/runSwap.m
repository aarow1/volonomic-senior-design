clear all;
close all;
img = imread('Capture.png');
boundBox = detectFace(img);
featPts = detectFeat(boundBox,img);
idx = matchFeat(featPts,img);