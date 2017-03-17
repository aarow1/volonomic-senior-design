function indexes = getIndexes(mask, targetH, targetW, offsetX, offsetY)
%find coordinates of pixels to be replaced
[y, x] = find(mask == 1);
l = length(y);

indexes = zeros(targetH, targetW);  
for i = 1:l
    %store index of source in its new location in the target
    indexes(uint32(y(i)+offsetY), uint32(x(i)+offsetX)) = sub2ind(size(mask),y(i),x(i));
end
end