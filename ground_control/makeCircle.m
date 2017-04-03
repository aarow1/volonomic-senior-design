global q_curr_vicon pos_vicon
num_pts = 30;
radius = 1;
hover_height = 1.5;

eul_curr = rad2deg(quat2eul(q_curr_vicon));
x = pos_vicon(1)*ones(num_pts,1);
y = pos_vicon(2)*ones(num_pts,1);
times = 1:1:num_pts;
times = times';
ome = 2*pi/num_pts;
poses = [radius*cos(ome*times)+x-radius, radius*sin(ome*times)+y hover_height*ones(num_pts,1)];
euls = [(rad2deg(ome*times)-180-117),...
    ones(num_pts,1)*eul_curr(2),...
    ones(num_pts,1)*eul_curr(3)];
global waypoints
waypoints = [poses euls];
trajectory_generator()
