function coefM = getCoefMatrix(indexes)
[m,n] = size(indexes);
idx = find(indexes ~= 0);
N = length(idx);
coefM = 4*speye(N,N);
for i = 1:N
    neighborIdx = findNeighbors([m,n],idx(i));
    %     coefM(i,:) = idx(idx == neighborIdx(j));
    for j = 1:4
        if indexes(neighborIdx(j)) ~= 0
            idxLoc = find(idx == neighborIdx(j));
            coefM(i,idxLoc) = -1;
        end
    end
end
