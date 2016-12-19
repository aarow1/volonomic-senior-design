function [ a1, ax, ay, w ] = est_tps( ctr_pts, target_value )
[m,n] = size(ctr_pts);
lamda = 1E-15;
K = zeros(m,m);
P = zeros(m,3);
for i = 1:m
    P(i,:) = [ctr_pts(i,1) ctr_pts(i,2) 1];
    for j = 1:m
    r = norm(ctr_pts(i,:)-ctr_pts(j,:));
    if r == 0
        K(i,j) = 0;
    else
        K(i,j) = -r^2*log(r^2);
    end
    end
end
A = [K P; P' zeros(3,3)];
W = (A + lamda*eye(m+3,m+3))\[target_value;0;0;0];
[mw, ~] = size(W);
a1 = W(mw,:);
ay = W(mw-1,:);
ax = W(mw-2,:);
w = W(1:mw-3,:);
end

