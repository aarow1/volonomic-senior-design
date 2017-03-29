function [] = trajectory_generator(waypts) 
disp('generating trajectory...')
[m,~] = size(waypts);
nSplines = m-1;

dist = zeros(nSplines,1);
time = zeros(nSplines,1);
timeScale = 2;
for i = 2:m
    dist(i) = sqrt(sum(waypts(i,:)-waypts(i-1,:)).^2);
    time(i) = dist(i)+time(i-1);
end
time = (timeScale/sum(dist)) * time

global cx cy cz timestep
[cx, cy, cz] = cublic_spline(nSplines,waypts,time);
timestep = time;
end