% quats = [[1 0 0 0]; [0 1 0 0]; [0 0 1 0]; [0 0 0 1]; [1 0 0 0]];
% quats = [a b c d];

num_quats = size(quats,1);

h = plotCoordinateFrame(eye(3),0,[0 0 1]);

for i = 1:num_quats
    q = quats(i,:);
    r = quat2rotm(q);
    h = plotCoordinateFrame(r,0,[0 0 1]);
%     clf;

    axis equal;
    grid on;
    axis([-2 2 -2 2 -2 2]);
    hold on;
    drawnow();
    f = 17;
    dt = (1/f) / 10;
    dt = .001;
%     pause(dt); 
    clf;
    title(num2str(i));
end