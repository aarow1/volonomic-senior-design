function qstar = qconjugate(q)

% Pull out the scalar part of our input quaternion.
q0 = q(1);

% Pull out the vector part of our input quaternions.
qv = (q(2:4));

% Calculate the conjugate of this input quaternion for output.
qstar = [q0 -qv];