function resultImg = reconstructImg(indexes, red, green, blue, targetImg)
idx = find(indexes ~= 0);
[Y,X] = ind2sub(size(targetImg),idx);
N = length(idx);

resultImg = targetImg;
for i = 1:N
    tempVect(1,1,:) = [red(i),green(i),blue(i)]; %solved RGB values
    resultImg(Y(i),X(i),:) = uint8(tempVect);
end
end