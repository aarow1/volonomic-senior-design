function plot_path(map, path)
% PLOT_PATH Visualize a path through an environment
%   PLOT_PATH(map, path) creates a figure showing a path through the
%   environment.  path is an N-by-3 matrix where each row corresponds to the
%   (x, y, z) coordinates of one point along the path.
close all

%% Remove margins from obstacles
x1 = map.obstacles(:,1) + map.margin; %min
x2 = map.obstacles(:,4) - map.margin; %max
y1 = map.obstacles(:,2) + map.margin; %min
y2 = map.obstacles(:,5) - map.margin; %max
z1 = map.obstacles(:,3) + map.margin; %min
z2 = map.obstacles(:,6) - map.margin; %max

%% Plot Obstacles
for k = 1:size(map.obstacles,1)
    p1 = [x1(k) y1(k) z1(k)];
    p2 = [x1(k) y2(k) z1(k)];
    p3 = [x1(k) y2(k) z2(k)];
    p4 = [x1(k) y1(k) z2(k)];
    p5 = [x2(k) y1(k) z2(k)];
    p6 = [x2(k) y2(k) z2(k)];
    p7 = [x2(k) y2(k) z1(k)];
    p8 = [x2(k) y1(k) z1(k)];
    F = [1 2 3 4 1];

    V1 = [p1; p2; p3; p4];
    V2 = [p4; p5; p6; p3];
    V3 = [p5; p6; p7; p8];
    V4 = [p8; p7; p2; p1];
    V5 = [p2; p7; p6; p3];
    V6 = [p4; p5; p8; p1];

    patch('Faces',F,'Vertices',V1,'FaceColor', [0.5 0.5 0.5],'FaceAlpha', 0.5)
    patch('Faces',F,'Vertices',V2,'FaceColor', [0.5 0.5 0.5],'FaceAlpha', 0.5)
    patch('Faces',F,'Vertices',V3,'FaceColor', [0.5 0.5 0.5],'FaceAlpha', 0.5)
    patch('Faces',F,'Vertices',V4,'FaceColor', [0.5 0.5 0.5],'FaceAlpha', 0.5)
    patch('Faces',F,'Vertices',V5,'FaceColor', [0.5 0.5 0.5],'FaceAlpha', 0.5)
    patch('Faces',F,'Vertices',V6,'FaceColor', [0.5 0.5 0.5],'FaceAlpha', 0.5)
    
    hold on
end

%% Plot Points
%{
for k = 1:size(points,1)
    plot3(points(k,1), points(k,2), points(k,3),'*b');
end
%}

%% Plot Path
if ~isempty(path)
    plot3(path(:,1), path(:,2), path(:,3),'-r')
end

%% Set Plot Properties
xlim([map.boundary(1) map.boundary(4)]);
ylim([map.boundary(2) map.boundary(5)]);
zlim([map.boundary(3) map.boundary(6)]);
xlabel('x')
ylabel('y')
zlabel('z')
grid on

end