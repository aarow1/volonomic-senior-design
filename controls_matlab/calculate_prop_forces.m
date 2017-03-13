function prop_forces = calculate_prop_forces(f, t);

r = .4; %distance from center to motor [m]

%% y = M * f_prop;
M = r * [   1, 1, 0, 0, 0, 0;
        0, 0, 1, 1, 0, 0;
        0, 0, 0, 0, 1, 1;
        0, 0, 1, -1, 0, 0;
        0, 0, 0, 0, 1, -1;
        1, -1, 0, 0, 0, 0];

%% f_props = M_inv * y;
M_inv = inv(M);

prop_forces = M_inv * [f; t];

end