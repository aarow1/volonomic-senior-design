function img_frame = faceSwapWrapper(img)
% close all;
% clear all;
%
% img = imread('Capture.png');
boundBox = [detectFace(img,[600, 60, 400, 600]); detectFace(img,[1800, 60, 500, 600])];
showAll = 0;
boxNose = findFeat(img,boundBox,'Nose',showAll);
boxMouth = findFeat(img,boundBox+[0 boundBox(1,3)/2 0 0;  0 boundBox(2,4)/2 0 -boundBox(2,3)/2;],'Mouth',showAll);
boxEyeR = findFeat(img,boundBox+[0 -boundBox(1,3)/4 0 0;  0 -boundBox(2,4)/3 0 0;],'RightEyeCART',showAll);
boxEyeL = findFeat(img,boundBox+[0 -boundBox(1,3)/4 0 0;  boundBox(2,4)/2 -boundBox(2,4)/3 0 0;],'LeftEyeCART',showAll);


% boxNose = findFeat(img,boundBox,'Nose',1);
% boxMouth = findFeat(img,boundBox+[ 0 0 0 0;  0 60 -30 -30;],'Mouth',1);
% boxEyeR = findFeat(img,boundBox+[ 0 0 0 0;  0 -60 0 0;],'RightEyeCART',1);
% boxEyeL = findFeat(img,boundBox+[ 0 0 0 0;  50 -40 0 0;],'LeftEyeCART',1);

[faceShapeX,faceShapeY] = findCoorPts(boxNose, boxMouth, boxEyeR, boxEyeL);

if showAll
    figure(); imshow(img);
    hold on;
    scatter(faceShapeX(:), faceShapeY(:));
    hold off;
end
convHullX = faceShapeX(:,1:4);
convHullY = faceShapeY(:,1:4);

img_mask1 = makeMask(img,convHullX(1,:),convHullY(1,:));
img_mask2 = makeMask(img,convHullX(2,:),convHullY(2,:));
img_morph1 = morph_tps_wrapper(img_mask1,img_mask2,[faceShapeX(1,:)' faceShapeY(1,:)'],...
    [faceShapeX(2,:)' faceShapeY(2,:)'],1,0);
img_morph2 = morph_tps_wrapper(img_mask2,img_mask1,[faceShapeX(2,:)' faceShapeY(2,:)'],...
    [faceShapeX(1,:)' faceShapeY(1,:)'],1,0);

img_faces = img_morph1 + img_morph2;
pullframe = uint8(img_faces == 0);
img_surround = img .* pullframe;
img_frame = img_faces + img_surround;
% figure;
% imshow(img_frame);
end

% resultImg = seamlessCloningPoisson(img_morph2,img,(rgb2gray(img_mask1)~=0),0,0);
% resultImg1 = seamlessCloningPoisson(img_morph1,resultImg,(rgb2gray(img_mask2)~=0),0,0);
% figure; imshow(resultImg1);

% rectangle('Position',boundBox(2,:)+[0 60 0 -30],'LineWidth',4,'LineStyle','-','EdgeColor','b')
% NoseDetect = vision.CascadeObjectDetector('Nose');
% boxNose_temp = step(NoseDetect,img);
%
%     rectangle('Position',boxNose(1,:),'LineWidth',4,'LineStyle','-','EdgeColor','b');