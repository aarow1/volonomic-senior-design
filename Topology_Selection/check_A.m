function [min_w] = check_A(A, b_satisfy, b_maximize, best_min_w)

% A: rotor configuration to check
% b_satisfy: set of wrenches that must be attainable
%            [max_motor_force; max_motor_force * torque_radius]
%            this comes from b_gen_hover_torque.m
% b_maximize: set of wrenches to find min_w from
%            [max_motor_force; max_motor_force * torque_radius]
%            this comes from b_gen3.m
% best_min_w: the min_w of the current best A configuration which
%             this configuration is compared to

%% Setup basic variables
min_w = inf;
[nSpace,~] = size(A);

%% Check linear algebra validity
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

%% Check that b_satisfy is satisfied

%% Find min_w from b_maximize

p_inv_A = pinv(A);
x_p = p_inv_A * b_maximize; % Particular solutions from pseudo-inverse
C = max(-x_p ./ x_h); % Number of x_h's needed to add to x_p


for i = 1:length(b_maximize)
    
    C = max(-x_p(i) ./ x_h);
    
    %       m = x_p + c * x_h   // m is the motor speeds required to exert unit wrench y
    m = x_p + C * x_h;
    
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
    if (min_w < best_min_w)
        min_w = 0;
        return;
    end
end
end

% Choose topology with max(min(R))
%
