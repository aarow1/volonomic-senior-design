function [] = follow_trajectory(time0)
global cx cy cz timestep
global pos_des pos_vicon
t = rostime('now');
t = t.Sec+1E-9*t.nSec - time0;
i = find(timestep <= t,1,'last');
if t < timestep(end)
    t_p = [1 t t^2 t^3];
    t_v = [0 1 2*t 3*t^2];
    t_a = [0 0 2 6*t];
    
    pos_des = [dot(cx(i,:), t_p); dot(cy(i,:), t_p); dot(cz(i,:), t_p)];
%     vel = [dot(cx(i,:), t_v); dot(cy(i,:), t_v); dot(cz(i,:), t_v)];
%     acc = [dot(cx(i,:), t_a); dot(cy(i,:), t_a); dot(cz(i,:), t_a)];

else
    pos_des = pos_vicon;
end

end

