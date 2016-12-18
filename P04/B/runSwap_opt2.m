close all;
clear all;

img = imread('Capture.png');

boundBox = detectFace(img);

boxNose = findFeat(img,boundBox,'Nose');
boxMouth = findFeat(img,boundBox+[ 0 0 0 0;  0 60 -30 -30;],'Mouth');
boxEyeR = findFeat(img,boundBox+[ 0 0 0 0;  0 -60 0 0;],'RightEyeCART');
boxEyeL = findFeat(img,boundBox+[ 0 0 0 0;  50 -40 0 0;],'LeftEyeCART');
if isnan(boxEyeL(2,:))
    boxEyeL(2,:) = [boxEyeR(2,1)+2*(abs(boxNose(2,1)+(boxNose(2,3)/2)-boxEyeR(2,1))) boxEyeR(2,2) boxEyeR(2,3:4)];
end
boxNoseCart = [boxNose(:,1:2), boxNose(:,1:2)+boxNose(:,3:4)];
boxMouthCart = [boxMouth(:,1:2), boxMouth(:,1:2)+boxMouth(:,3:4)];
boxEyeRCart = [boxEyeR(:,1:2), boxEyeR(:,1:2)+boxEyeR(:,3:4)];
boxEyeLCart = [boxEyeL(:,1:2), boxEyeL(:,1:2)+boxEyeL(:,3:4)];

% faceShapeX = [boxEyeR(:,1), boxEyeL(:,3), boxMouth(:,1), boxMouth(:,3)]; 
% faceShapeY = [boxEyeR(:,2), boxEyeL(:,2), boxMouth(:,4), boxMouth(:,4)];

faceShapeX = [boxEyeRCart(:,1), boxEyeLCart(:,3), boxMouthCart(:,1), boxMouthCart(:,3)]; 
faceShapeY = [boxEyeRCart(:,2), boxEyeLCart(:,2), boxMouthCart(:,4), boxMouthCart(:,4)];

figure(); imshow(img);
hold on;
scatter(faceShapeX(:), faceShapeY(:));
% rectangle('Position',boundBox(2,:)+[0 60 0 -30],'LineWidth',4,'LineStyle','-','EdgeColor','b')
% NoseDetect = vision.CascadeObjectDetector('Nose');
% boxNose_temp = step(NoseDetect,img);
%     
%     rectangle('Position',boxNose(1,:),'LineWidth',4,'LineStyle','-','EdgeColor','b');
