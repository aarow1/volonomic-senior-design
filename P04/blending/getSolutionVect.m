function solVector = getSolutionVect(indexes, source, target, offsetX, offsetY)
[m,n] = size(source);
idx = find(indexes ~= 0)';
N = length(idx);

Np = 4;
solVector = zeros(N)';

for i = 1:N
    a = source(indexes(idx(i))); %gp, pixel value in source
    b = 0; %sum gp in boundary
    neighborIdx = findNeighbors([m,n],idx(i));
    for j = 1:4
        if indexes(neighborIdx(j)) ~= 0
            b = b+source(indexes(neightborIdx(j)));
        end
    end
    %if on the boundary
    c = 0;
    if (length(neighborIdx(neighborIdx ~= 0)) ~= 4)
        for j = 1:4
            c = c+target(neighborIdx(j));
        end
    end
    solVector(i) = Np*a - b + c;
end
end