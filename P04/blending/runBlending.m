sourceImg = imread('football.jpg');
targetImg = imread('football.jpg');
[mask] = maskImage(sourceImg);
figure();
imshow(targetImg);
[offsetY,offsetX] = ginput(1); %get x y offset maybe this is correct)
[resultImg] = seamlessCloningPoisson(sourceImg, targetImg, mask, offsetX, -offsetY);
figure();
imshow(resultImg);