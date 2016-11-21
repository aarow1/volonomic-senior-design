function [ neighborIdx ] = findNeighbors(size, idx)

[y,x] = ind2sub(size,idx);
[m,n] = size(indexes);
=======
%[y,x] = ind2sub(size(indexes),idx);
n = size(2);
>>>>>>> origin/master
neighborIdx = zeros(4);
neighborIdx(1) = idx+1;
neighborIdx(2) = idx-1;
neighborIdx(3) = idx+n;
neighborIdx(4) = idx-n;
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
