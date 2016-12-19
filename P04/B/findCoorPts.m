function [ faceShapeX,faceShapeY ] = findCoorPts( boxNose,boxMouth,boxEyeR,boxEyeL )
% create convex hull around face
% input: boxes around nose, mouth, eyeR, and eyeL
% output: x & y coordinates [eyeR, eyeL, mouthR, mouthL, nose center. mouthcenter, eyeR center, eyeL center]

boxNoseCart = [boxNose(:,1:2), boxNose(:,1:2)+boxNose(:,3:4)];
boxMouthCart = [boxMouth(:,1:2), boxMouth(:,1:2)+boxMouth(:,3:4)];
boxEyeRCart = [boxEyeR(:,1:2), boxEyeR(:,1:2)+boxEyeR(:,3:4)];

mouthCenter = [(boxMouthCart(:,1)+boxMouthCart(:,3))/2, (boxMouthCart(:,2)+boxMouthCart(:,4))/2];
noseCenter = [(boxNoseCart(:,1)+boxNoseCart(:,3))/2, (boxNoseCart(:,2)+boxNoseCart(:,4))/2];
eyeCenterR = [(boxEyeRCart(:,1)+boxEyeRCart(:,3))/2, (boxEyeRCart(:,2)+boxEyeRCart(:,4))/2];


% fix the left eye
if isnan(boxEyeL(2,:))
    a = (mouthCenter(2,2)-noseCenter(2,2))/(mouthCenter(2,1)-noseCenter(2,1));
    c = noseCenter(2,2)-a*noseCenter(2,1);
    x = eyeCenterR(2,1);
    y = eyeCenterR(2,2);
    d = (x + (y - c)*a)/(1 + a^2);
    eyeCenterL(2,1) = 2*d - x;
    eyeCenterL(2,2) = 2*d*a - y + 2*c;
    %     eyeCenterL(2,:) = [boxEyeR(2,1)+2*(abs(boxNose(2,1)+(boxNose(2,3)/2)-boxEyeR(2,1))) boxEyeR(2,2) boxEyeR(2,3:4)];.
    boxEyeL(2,:)=[eyeCenterL(2,1)-boxEyeR(2,3)/2, eyeCenterL(2,2)-boxEyeR(2,4)/2, boxEyeR(2,3:4)];
elseif isnan(boxEyeL(1,:))
    a = (mouthCenter(1,2)-noseCenter(1,2))/(mouthCenter(1,1)-noseCenter(1,1));
    c = noseCenter(1,2)-a*noseCenter(1,1);
    x = eyeCenterR(1,1);
    y = eyeCenterR(1,2);
    d = (x + (y - c)*a)/(1 + a^2);
    eyeCenterL(1,1) = 2*d - x;
    eyeCenterL(1,2) = 2*d*a - y + 2*c;
    %     eyeCenterL(2,:) = [boxEyeR(2,1)+2*(abs(boxNose(2,1)+(boxNose(2,3)/2)-boxEyeR(2,1))) boxEyeR(2,2) boxEyeR(2,3:4)];.
    boxEyeL(1,:)=[eyeCenterL(1,1)-boxEyeR(1,3)/2, eyeCenterL(1,2)-boxEyeR(1,4)/2, boxEyeR(1,3:4)];
end
boxEyeLCart = [boxEyeL(:,1:2), boxEyeL(:,1:2)+boxEyeL(:,3:4)];
eyeCenterL = [(boxEyeLCart(:,1)+boxEyeLCart(:,3))/2, (boxEyeLCart(:,2)+boxEyeLCart(:,4))/2];

%% visualize eye reflection
% scatter([eyeCenterR(2,1), eyeCenterL(2,1)], [eyeCenterR(2,2), eyeCenterL(2,2)], 'r')
% plot([mouthCenter(2,1), noseCenter(2,1)], [mouthCenter(2,2), noseCenter(2,2)], 'b');
% scatter([mouthCenter(2,1), noseCenter(2,1)], [mouthCenter(2,2), noseCenter(2,2)], 'b');
%%
% faceShapeX = [boxEyeR(:,1), boxEyeL(:,3), boxMouth(:,1), boxMouth(:,3)];
% faceShapeY = [boxEyeR(:,2), boxEyeL(:,2), boxMouth(:,4), boxMouth(:,4)];

faceShapeX = [boxEyeRCart(:,1), boxEyeLCart(:,3), boxMouthCart(:,3), boxMouthCart(:,1), noseCenter(:,1), mouthCenter(:,1), eyeCenterR(:,1), eyeCenterL(:,1)];
faceShapeY = [boxEyeRCart(:,2), boxEyeLCart(:,2), boxMouthCart(:,4), boxMouthCart(:,4), noseCenter(:,2), mouthCenter(:,2), eyeCenterR(:,2), eyeCenterL(:,2)];
end

