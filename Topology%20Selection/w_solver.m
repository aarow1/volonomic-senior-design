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
I = eye(nrotors);
z = ones(nrotors,1)*-eps;
in = ones(nrotors,1)*inf;
options = optimset('Display','off');
min_w = inf;
for ii = 1:l
    try
        min_speeds = quadprog(I,z,[],[],A,b(:,ii),z,in,[],options);
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