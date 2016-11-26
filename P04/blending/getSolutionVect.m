function solVector = getSolutionVect(indexes, source, target, offsetX, offsetY)
[m,n] = size(source);
idx = find(indexes ~= 0)';
N = length(idx);

Np = 4;
solVector = zeros(N,1);

for i = 1:N
    a = source(indexes(idx(i))); %gp, pixel value in source
    b = 0; %sum gp in boundary
    neighborIdx = findNeighbors([m,n],idx(i));
    for j = 1:4
        if indexes(neighborIdx(j)) ~= 0
            b = b+source(indexes(neighborIdx(j)));
        end
    end
    %if on the boundary
    c = 0;
    onBoundary = indexes(neighborIdx);
    if (length(onBoundary(onBoundary ~= 0)) ~= Np)
        for j = 1:4
            if indexes(neighborIdx(j)) ~= 0
                c = c+target(neighborIdx(j));
            end
        end
    end
    solVector(i) = (Np*a - b + c)/Np;
end
end