function [ neighborIdx ] = findNeighbors(size, idx)

% [y,x] = ind2sub(size,idx);
% [m,n] = size(indexes);

%[y,x] = ind2sub(size(indexes),idx);
m = size(1);
n = size(2);
neighborIdx = zeros(1,4);
neighborIdx(1) = min(idx+1,m*n);
neighborIdx(2) = max(idx-1,1);
neighborIdx(3) = min(idx+m,m*n);
neighborIdx(4) = max(idx-m,1);
%for k = 1:4
 %   try
        %         y = real((1i)^k);
        %         x = real((1i)^(k+1));
    %    neighborIdx(k) = sub2ind([m,n],x+real((1i)^(k+1)),y+real((1i)^k));
 %   catch
    %    neighborIdx(k) = idx;
%    end
%end
end
