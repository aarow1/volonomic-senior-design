function [ neighborIdx ] = findNeighbors(size, idx)
[y,x] = ind2sub(size(indexes),idx);
[m,n] = size(indexes);
neighborIdx = zeros(4);

for k = 1:4
    try
        %         y = real((1i)^k);
        %         x = real((1i)^(k+1));
        neighborIdx(k) = sub2ind([m,n],x+real((1i)^(k+1)),y+real((1i)^k));
    catch
        neighborIdx(k) = idx;
    end
end
end

