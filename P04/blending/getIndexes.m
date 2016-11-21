function indexes = getIndexes(mask, targetH, targetW, offsetX, offsetY)
[y, x] = find(mask == 1);
m = length(y);
indexes = zeros(targetH, targetW);
% top = min(y);
% bottom = max(y);
% left = min(x);
% right = max(x);   
for i = 1:m
    indexes(y(i)+offsetY, x(i)+offsetX) = sub2ind([y x],x,y);
end
end
