function indexes = getIndexes(mask, targetH, targetW, offsetX, offsetY)
[y, x] = find(mask == 1);
l = length(y);
indexes = zeros(targetH, targetW);
% top = min(y);
% bottom = max(y);
% left = min(x);
% right = max(x);   
for i = 1:l
    indexes(uint32(y(i)+offsetY), uint32(x(i)+offsetX)) = sub2ind(size(mask),y(i),x(i));
end
end
