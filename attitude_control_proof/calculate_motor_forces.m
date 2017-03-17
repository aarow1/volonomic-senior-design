function motor_forces = calculate_motor_forces(f, t);

r = .4; %distance from center to motor [m]

M = r * [   1, 1, 0, 0, 0, 0;
        0, 0, 1, 1, 0, 0;
        0, 0, 0, 0, 1, 1;
        0, 0, 1, -1, 0, 0;
        0, 0, 0, 0, 1, -1;
        1, -1, 0, 0, 0, 0];
    
M_inv = inv(M);



end