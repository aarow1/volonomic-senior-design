function [ ] = plot_trajectory()
global C way_times cubic
disp('plotting trajctory...');
num_segments = size(way_times,1)-1;
close all
axis equal;
grid on;
axis([-4 4 -4 4 -4 4]);
hold on;
dt = .1;
R = eye(3);
t = way_times;
for t_path = way_times(1):dt:way_times(end)
    clf();
    if cubic
        t_vec = zeros(4*num_segments,1);
        t_vec_basic = [1 t_path t_path^2 t_path^3]';
        
        for seg = 1:num_segments
            if ((t_path >= t(seg)) && (t_path < t(seg+1)))
                t_vec((4*(seg-1)+1):(4*(seg-1)+4)) = t_vec_basic;
            end
        end
        state = zeros(1,6);
        for dim = 1:4
            num =  C(:,dim)' * t_vec;
            state(dim) = num;
        end
    else
        t_vec = zeros(6*num_segments,1);
        t_vec_basic = [1 t_path t_path^2 t_path^3 t_path^4 t_path^5]';
        
        for seg = 1:num_segments
            if ((t_path >= t(seg)) && (t_path < t(seg+1)))
                t_vec((6*(seg-1)+1):(6*(seg-1)+6)) = t_vec_basic;
            end
        end
        state = zeros(1,6);
        for dim = 1:6
            num =  C(:,dim)' * t_vec;
            state(dim) = num;
        end
    end
    t_vec;
    state;
    R = eul2rotm(deg2rad(state(4:6)), 'zyx');
    
    h0 = plotCoordinateFrameOff(state(1:3), R, 0, [0 0 1]);
    
    axis equal;
    grid on;
    axis([-4 4 -4 4 -4 4]);
    %     view(2);
    title(t_path);
    drawnow();
    pause(dt);
end
disp('done plotting');

end

