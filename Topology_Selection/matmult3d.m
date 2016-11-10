function M = matmult3d(A,m)
%% A * m(:,i) for every i
[j,k] = size(m);
[p,q] = size(A);
mc = mat2cell(m,j,ones(1,k));
M = zeros(p,k);
for i = 1:k
    M(:,i) = A*mc{i};
end
end