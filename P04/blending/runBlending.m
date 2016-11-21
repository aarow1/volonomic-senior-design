sourceImg = 'football.jpg';
targetImg = 'cameraman.tif';
[mask] = maskImage(sourceImg);
figure();
imshow(targetImg);
[offsetX,offsetY] = ginput(1); %get x y offset maybe this is correct)
[resultImg] = seamlessCloningPoisson(sourceImg, targetImg, mask, offsetX, offsetY);
figure();
imshow(resultImg);