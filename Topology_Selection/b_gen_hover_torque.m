function b = b_gen_hover_torque(theta_step, force_req, torque_req)

% theta_step: [radians]
% force_req: [max_motor_force]
% torque_req: [max_motor_force * torque_radius]

t1 = 0:theta_step:2*pi;
t2 = 0:theta_step:pi;

for i1 = 1:length(t1)
  for i2 = 1:length(t2)
    % Calculate force vector
    f_x = force_req * cos(t1(i1));
    f_y = force_req * sin(t1(i1)) * cos(t2(i2));
    f_z = force_req * sin(t1(i1)) * sin(t2(i2));

    % Look at all torques from that force vector
    for j1 = 1:length(t1)
      for j2 = 1:length(t2)
       
        % Calculate torque vector
        m_x = force_req * cos(t1(j1));
        m_y = force_req * sin(t1(j1)) * cos(t2(j2));
        m_z = force_req * sin(t1(j1)) * sin(t2(j2));

        b = [b, [f_x; f_y; f_z; m_x; m_y; m_z]];

      end
    end
  end
end

end
