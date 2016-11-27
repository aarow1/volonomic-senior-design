function coefM = getCoefMatrix(indexes)
[m,n] = size(indexes);
idx = find(indexes ~= 0);
N = length(idx);
Np = 4;

coefM = Np*speye(N,N);
for i = 1:N
    neighborIdx = findNeighbors([m,n],idx(i)); %indicies of N,S,E,W pixels
    for j = 1:4
        %if neighbor is in boundary
        if indexes(neighborIdx(j)) ~= 0
            idxLoc = find(idx == neighborIdx(j)); %index in list of replacment pixels
            coefM(i,idxLoc) = -1;
        end
    end
end
