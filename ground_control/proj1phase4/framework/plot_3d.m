function plot_3d(h, varargin)
%
% plots quad path in 3d
%
keys = get_plot_keys;
m = containers.Map(keys, [1:24]);
hold on;
plot3(h(:,m('pos_des_x')), h(:,m('pos_des_y')), ...
    h(:,m('pos_des_z')),'b');
plot3(h(:,m('pos_x')), h(:,m('pos_y')), h(:,m('pos_z')),'r');
if ~isempty(varargin)
    wp = varargin{1};
    plot3(wp(:,1),wp(:,2),wp(:,3), 'b-o');
end
hold off;
end