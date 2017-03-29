function h = plotVectorOff(o, v, color, linestyle, linewidth, label, fontsize)

% Plot a line from the origin to the tip of the vector.
h = plot3([o(1) o(1)+v(1)], [o(2) o(2)+v(2)], [o(3) o(3)+v(3)],'linewidth',linewidth,'color',color,'linestyle',linestyle);

% Label the tip of the vector.
textdistance = 1.1;
text(textdistance*v(1),textdistance*v(2),textdistance*v(3),label,'fontsize',fontsize,'color',color);

end