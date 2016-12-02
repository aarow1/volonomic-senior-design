close all
%% PARAMETERS
propName = 'APC Unidirectional RH';
maxSpeed = 1700; %max rad/s prop is rated for
isUni = 1; %1 if unidirectional prop

%% SCRIPT
speed = summary.speed.value;
force = summary.wrench.value(:,3)';
torque = summary.wrench.value(:,6)';

for i = 1:length(speed)
    if isnan(force(i)) == true
        force(i) = 0;
        speed(i) = 0;
    end
    if isnan(torque(i)) == true
        torque(i) = 0;
        speed(i) = 0;
    end
end
if (sum(speed>0)>0 && sum(speed<0)>0)
    speed_val = [-maxSpeed:50:maxSpeed];
else
    speed_val = [0:50:maxSpeed];
end

force = abs(force);
torque = abs(torque);

%% PLOT DATA
if isUni
    figure
    title(['Force vs. Speed' ' for ' propName]);
    l1 = round(length(speed)/2);
    l2 = round(length(speed_val)/2);
    idx = find(speed_val == -round(min(abs(speed_val(1:l2-1))+abs(speed(1)))));
    
    scatter(speed,force,'.');
    options = fitoptions('poly2','Lower',[-Inf 0 0], 'Upper', [Inf 0 0]);
    f1 = fit(speed(1:l1)',force(1:l1)','poly2',options);
    force_func1 = f1.p1*speed_val(idx(1):l2).^2;
    f2 = fit(speed(l1:end)',force(l1:end)','poly2',options);
    force_func2 = f2.p1*speed_val(l2:end).^2;
    hold on
    plot(speed_val(idx(1):l2), force_func1);
    plot(speed_val(l2:end), force_func2);
    xlabel('Speed (rad/sec)');
    ylabel('|Force| (N)');
    text(-200,4,['f = ' num2str(f2.p1) 'x^2'],'FontSize',14);
    legend('Data', 'Fitted Curve', 'Location', 'southwest');
    scatter(speed_val(end),force_func(end));
    text(speed_val(end),force_func(end),['(' num2str(speed_val(end)) ',' ...
        num2str(force_func(end)) ') \rightarrow'], ...
        'HorizontalAlignment', 'right');
    grid on
    axis tight
    saveas(gcf,[propName '-Force.jpg']);
else
    figure
    % subplot(1,2,1);
    scatter(speed,force,'.');
    title(['Force vs. Speed' ' for ' propName]);
    options = fitoptions('poly2','Lower',[-Inf 0 0], 'Upper', [Inf 0 0]);
    f = fit(speed',force','poly2',options);
    force_func = f.p1*speed_val.^2;
    hold on
    % plot(f,speed,force);
    plot(speed_val, force_func);
    xlabel('Speed (rad/sec)');
    ylabel('|Force| (N)');
    text(-200,4,['f = ' num2str(f.p1) 'x^2'],'FontSize',14);
    legend('Data', 'Fitted Curve', 'Location', 'southwest');
    scatter(speed_val(end),force_func(end));
    text(speed_val(end),force_func(end),['(' num2str(speed_val(end)) ',' ...
        num2str(force_func(end)) ') \rightarrow'], ...
        'HorizontalAlignment', 'right');
    grid on
    axis tight
    saveas(gcf,[propName '-Force.jpg']);
end

figure
% subplot(1,2,2);
scatter(speed,torque,'.');
title(['Torque vs. Speed' ' for ' propName]);
options = fitoptions('poly2','Lower',[-Inf 0 0], 'Upper', [Inf 0 0]);
g = fit(speed',torque','poly2',options);
torque_func = g.p1*speed_val.^2;
hold on
% plot(g,speed,torque);
plot(speed_val, torque_func);
xlabel('Speed (rad/sec)');
ylabel('|Torque| (mNm)');
text(-200,70,['f = ' num2str(g.p1) 'x^2'],'FontSize',14);
legend('Data', 'Fitted Curve', 'Location', 'southwest');
scatter(speed_val(end),torque_func(end));
text(speed_val(end),torque_func(end),['(' num2str(speed_val(end)) ',' ...
    num2str(torque_func(end)) ') \rightarrow'], ...
    'HorizontalAlignment', 'right');
grid on
axis tight
saveas(gcf,[propName '-Torque.jpg']);