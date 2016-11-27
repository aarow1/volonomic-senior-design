function [ neighborIdx ] = findNeighbors(size, idx)
m = size(1);
n = size(2);
%constrain the neighbor search
neighborIdx = zeros(1,4);
neighborIdx(1) = min(idx+1,m*n); %S
neighborIdx(2) = max(idx-1,1); %N
neighborIdx(3) = min(idx+m,m*n); %E
neighborIdx(4) = max(idx-m,1); %W

% [y,x] = ind2sub(size,idx);
% [m,n] = size(indexes);
%[y,x] = ind2sub(size(indexes),idx);
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
