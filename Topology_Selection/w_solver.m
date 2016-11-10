function [min_w] = w_solver(A,b,c)
[n, nrotors] = size(A);
% delta = pi/4;
% switch n
%     case 3
%         b = b_gen3(delta);
%     case 6
%         b = b_gen6(delta);
%     otherwise
% end
l = length(b);
min_speeds = zeros(nrotors,l);
H = eye(nrotors);
f = zeros(nrotors,1);
options = optimset('Display','off', 'MaxIter',100000);
min_w = inf;

if(size(null(A),2) ~= 1)
    min_w = 0;
    disp('null space wrong');
    return;
end

for ii = 1:l
    try
        b(:,ii)
        min_speeds = quadprog(H,f,[],[],A,b(:,ii),f,[],[], options);
        A*min_speeds
    catch
        min_w = 0;
        return;
    end
    if ~isempty(min_speeds)
        max_speeds = min_speeds ./ max(min_speeds);
        max_w = A*max_speeds;
        min_w = min(min_w, norm(max_w));
        if (min_w < c)
            min_w = 0;
            return;
        end
    else
        min_w = 0;
        return;
    end
end
% max_speeds = min_speeds ./ repmat((max(min_speeds)),nrotors,1);
% max_w = matmult3d(A,max_speeds);
% [~,ind] = min(sum(max_w.^2));
% min_w = max_w(:,ind);
% m = max_speeds(:,ind);
end