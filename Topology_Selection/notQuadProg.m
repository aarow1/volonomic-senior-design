function [min_w] = notQuadProg(A,b,c)
min_w = inf;
[nSpace,~] = size(A);

%     Find the null space basis of A, this is the homogenous solution
%       x_h = null space basis
x_h = null(A);
[~,n] = size(x_h);
%       if dim(null(A)) ~= 1, then move to next topology
if (n ~= 1)
    min_w = 0;
    return;
end
%       equivalently if dim(rowspace(A)) ~= 6, move to next topology,
%       dim(rowspace) = rank
if (rank(A) ~= nSpace)
    min_w = 0;
    return;
end
%       all elements of x_h must be positive
%         or if they are all negative, make them all positive
isPos = x_h >= 0;
if ~all(isPos)
    x_h = x_h * -1;
    if ~all(x_h >= 0)
        min_w = 0;
        return;
    end
end

for i = 1:length(b)
    %     for each unit direciton of wrench, y
    %       calculate x_p using pseudo-inverse of A
    x_p = pinv(A) * b(:,i);
    
    %       C = max(-x_p ./ x_h) // m = x_p + c * x_h
    c = max(-x_p ./ x_h);
    
    %       m = x_p + c * x_h   // m is the motor speeds required to exert unit wrench y
    m = x_p + c * x_h;
    
    %       d = max(m)          // d is the maximum motor speed to make unit wrench
    d = max(m);
    %       M = m / d           // M is the highest attainable motor speeds
    %                           // to make wrench in y direction
    %                           // To explain: M has it's fastest motor speed set to 1
    M = m / d;
    %       R = A * M           // R is the highest attainable wrench in y direction
    R = A* M;
    %     find min(R) for topology
    %     store this with reference to specific topology
    min_w = min(min_w, norm(R));
    %     if (min_w < c)
    %         return;
    %     end
end
end

% Choose topology with max(min(R))
%
