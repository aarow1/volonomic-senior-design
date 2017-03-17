function hijk = plotCoordinateFrame(R,n,c)

% Plot parameters
linewidth = 2;
fontsize = 18;

% Pull the x, y, and z unit vectors out of the matrix.
i = R(:,1);
j = R(:,2);
k = R(:,3);

% Design the labels for the axes.
if (n == inf)
    % Special case for no labels.
    nl = {'' '' ''};
else
    % Numbered frame.
    nl = {['x_' num2str(n)] ['y_' num2str(n)] ['z_' num2str(n)]};
end

% Turn on hold so we can plot several things on the axes.
hold on

% Plot the x, y, and z unit vectors from the matrix.
hi = plotVector(i, c, ':', linewidth, nl{1}, fontsize);
hj = plotVector(j, c, '--', linewidth, nl{2}, fontsize);
hk = plotVector(k, c, '-', linewidth, nl{3}, fontsize);

% Put the handles into a vector to return so the user can manipulate them.
hijk = [hi ; hj ; hk];

% Turn off hold.
hold off

end