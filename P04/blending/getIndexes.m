function indexes = getIndexes(mask, targetH, targetW, offsetX, offsetY)
[y, x] = find(mask == 1);
m = length(y);
indexes = zeros(targetH, targetW);
% top = min(y);
% bottom = max(y);
% left = min(x);
% right = max(x);   
for i = 1:m
    indexes(int8(y(i)+offsetY), int8(x(i)+offsetX)) = sub2ind(size(mask),x(i),y(i));
end
end
