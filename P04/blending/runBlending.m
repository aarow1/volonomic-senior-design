sourceImg = imread('source.jpg');
targetImg = imread('target.jpg');
[mask] = maskImage(sourceImg);
idx = find(mask~=0);
[y,x] = ind2sub(size(mask),idx(1));
figure();
imshow(targetImg);
[offsetY,offsetX] = ginput(1); %get x y offset maybe this is correct)
[resultImg] = seamlessCloningPoisson(sourceImg, targetImg, mask, -offsetX+x, -(offsetY-y));
figure();
imshow(resultImg);