function hijk = plotPropForces(f_props, RotMat, X, P)

% Plot parameters
linewidth = 2;
fontsize = 18;

f_props = -f_props / 30;
% f_props = ones(6,1);

X = RotMat * X;
P = RotMat * P;

% Turn on hold so we can plot several things on the axes.
hold on

%% Plot Cage

cage(:,:,1) = ...
         [  0,  0,  0,  0,  0;
           -1,  0,  1,  0, -1;
            0,  0,  0,  0,  0];

cage(:,:,2) = ...
         [  1,  1,  1,  1,  1;
            0,  0,  0,  0,  0;
           -1, -1, -1, -1, -1];

cage(:,:,3) = ...
         [  0,  0,  0,  0,  0;
            0,  1,  0, -1,  0;
            0,  0,  0,  0,  0];
        
for row = 1:3
    for col = 1:5
          p = cage(row, col, :);
          cage(row, col, :) = RotMat * p(:);
    end
end
        
surf(cage(:,:,1), cage(:,:,2), cage(:,:,3), 'facecolor', 'none')

%% Plot prop forces
for ii = 1:6
quiver3(P(1,ii), P(2,ii), P(3,ii), ...
    f_props(ii) * X(1,ii), f_props(ii) * X(2,ii), f_props(ii) * X(3,ii),...
    'LineWidth', linewidth);
end

% Turn off hold.
hold off

end