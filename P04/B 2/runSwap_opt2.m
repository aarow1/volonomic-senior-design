clear all
close all


fname = 'faceSwap.avi';
try
    % VideoWriter based video creation
    h_avi = VideoWriter(fname, 'Uncompressed AVI');
    h_avi.FrameRate = 24;
    h_avi.open();
catch
    % Fallback deprecated avifile based video creation
    h_avi = avifile(fname,'fps',24);
end

video1 = VideoReader('Proj4_Test/Proj4_Test/easy/easy1.mp4');
video2 = VideoReader('Proj4_Test/Proj4_Test/easy/easy2.mp4');
nframe = 1;
cont = 1;
%% Section
while cont
    try
        frame1 = video1.readFrame();
        frame2 = video2.readFrame();
        img_morphed = faceSwapWrapper([frame1 frame2]);
        close all;
        imagesc(img_morphed);
        axis image; axis off;drawnow;
        saveas(gcf,['frames/frame' num2str(nframe) '.jpg']);

        try
            % VideoWriter based video creation
            h_avi.writeVideo(getframe(gcf));
        catch
            % Fallback deprecated avifile based video creation
            h_avi = addframe(h_avi, getframe(gcf));
        end
        nframe = nframe + 1
    catch
        cont = 0
    end
end

try
    % VideoWriter based video creation
    h_avi.close();
catch
    % Fallback deprecated avifile based video creation
    h_avi = close(h_avi);
end
clear h_avi;

% clear all;
%
% img = imread('Capture.png');
% boundBox = detectFace(img);
%
% boxNose = findFeat(img,boundBox,'Nose',1);
% boxMouth = findFeat(img,boundBox+[ 0 0 0 0;  0 60 -30 -30;],'Mouth',1);
% boxEyeR = findFeat(img,boundBox+[ 0 0 0 0;  0 -60 0 0;],'RightEyeCART',1);
% boxEyeL = findFeat(img,boundBox+[ 0 0 0 0;  50 -40 0 0;],'LeftEyeCART',1);
%
% [faceShapeX,faceShapeY] = findCoorPts(boxNose, boxMouth, boxEyeR, boxEyeL);
%
% figure(); imshow(img);
% hold on;
% scatter(faceShapeX(:), faceShapeY(:));
% hold off;
% convHullX = faceShapeX(:,1:4);
% convHullY = faceShapeY(:,1:4);
%
% img_mask1 = makeMask(img,convHullX(1,:),convHullY(1,:));
% img_mask2 = makeMask(img,convHullX(2,:),convHullY(2,:));
% img_morph1 = morph(img_mask1,img_mask2,[faceShapeX(1,:)' faceShapeY(1,:)'],...
%     [faceShapeX(2,:)' faceShapeY(2,:)'],1,0);
% img_morph2 = morph(img_mask2,img_mask1,[faceShapeX(2,:)' faceShapeY(2,:)'],...
%     [faceShapeX(1,:)' faceShapeY(1,:)'],1,0);
%
% img_faces = img_morph1 + img_morph2;
% pullframe = uint8(img_faces == 0);
% img_surround = img .* pullframe;
% img_frame = img_faces + img_surround;
% figure;
% imshow(img_frame);

% resultImg = seamlessCloningPoisson(img_morph2,img,(rgb2gray(img_mask1)~=0),0,0);
% resultImg1 = seamlessCloningPoisson(img_morph1,resultImg,(rgb2gray(img_mask2)~=0),0,0);
% figure; imshow(resultImg1);

% rectangle('Position',boundBox(2,:)+[0 60 0 -30],'LineWidth',4,'LineStyle','-','EdgeColor','b')
% NoseDetect = vision.CascadeObjectDetector('Nose');
% boxNose_temp = step(NoseDetect,img);
%
%     rectangle('Position',boxNose(1,:),'LineWidth',4,'LineStyle','-','EdgeColor','b');