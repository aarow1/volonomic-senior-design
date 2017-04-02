function [] = follow_trajectory()
global C way_times traj_start follow_traj
global q_des pos_des
num_segments = size(way_times,1)-1;

t_path = toc - traj_start;
% disp('help me');

if t_path > way_times(end)
    follow_traj = 0;
%     disp('made it!');
else
    t_vec = zeros(6*num_segments,1);
    t_vec_basic = [1 t_path t_path^2 t_path^3 t_path^4 t_path^5]';
    
    for seg = 1:num_segments
        if ((t_path >= way_times(seg)) && (t_path < way_times(seg+1)))
            t_vec((6*(seg-1)+1):(6*(seg-1)+6)) = t_vec_basic;
        end
    end
    
    state = zeros(1,6);
    for dim = 1:6
        num =  C(:,dim)' * t_vec;
        state(dim) = num;
    end
    state
    R = eul2rotm(deg2rad(state(4:6)), 'zyx');
    q_des = rotm2quat(R);
    pos_des = state(1:3);
end
end

