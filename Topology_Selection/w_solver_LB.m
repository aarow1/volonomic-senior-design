function [min_w] = w_solver_LB(A,b_satisfy, b_maximize,c)
[n, nrotors] = size(A);
% delta = pi/4;
% switch n
%     case 3
%         b = b_gen3(delta);
%     case 6
%         b = b_gen6(delta);
%     otherwise
% end
l = length(b_satisfy);
% min_speeds = zeros(nrotors,l);
H = eye(nrotors);
f = zeros(nrotors,1);
LB = -.15*ones(nrotors,1);
UB = ones(nrotors,1);
options = optimset('Display','off', 'MaxIter',1000);
min_w = inf;

%% Check validity
if(size(null(A),2) ~= 1)
    min_w = 0;
    disp('null space wrong');
    return;
end

%% Check b_satisfy
for ii = 1:l
    try
        %         b(:,ii)
        min_speeds = quadprog(H,f,[],[],A,b_satisfy(:,ii),LB,[],[], options);
        %         A*min_speeds
    catch
        min_w = 0;
        return;
    end
    if isempty(min_speeds)
        min_w = 0;
        return;
    end
end

%% Check b_maximize
for ii = 1:length(b_maximize)
    try
        %         b(:,ii)
        min_speeds = quadprog(H,f,[],[],A,b_maximize(:,ii),LB,UB,[], options);
        %         A*min_speeds
    catch
        min_w = 0;
        return;
    end
    if ~isempty(min_speeds)
        absMax = max(abs(min_speeds));
        max_speeds = min_speeds ./ absMax;
        max_w = A*max_speeds;
        min_w = min(min_w, norm(max_w));
        if (min_w < c)
            min_w = 0;
            return;
        end
    end
    
end
% max_speeds = min_speeds ./ repmat((max(min_speeds)),nrotors,1);
% max_w = matmult3d(A,max_speeds);
% [~,ind] = min(sum(max_w.^2));
% min_w = max_w(:,ind);
% m = max_speeds(:,ind);
end