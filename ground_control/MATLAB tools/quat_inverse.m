function q_inv = quat_inverse(q)

denom = q(1)^2 + q(2)^2 + q(3)^2 + q(4)^2;
q_inv = (1/denom) * [q(1) -q(2) -q(3) -q(4)];