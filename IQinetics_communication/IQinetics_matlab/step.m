
target_spd = 1700;
margin = .9;
vels = [];
close all
ts = [];
kv = 2109;
kt = 1/(kv/60 * 2*pi);
pwms = [];
vs = [];
currents = 0;
if ~exist('I_bus','var')
    I_bus = 0;% mA read from Ammeter
end

hold_time = 5;

a = 1;
tic
while toc < hold_time
    mot0.set('cmd_velocity', target_spd);
    vels = [vels mot0.get('obs_velocity')];
    pwms = [pwms mot0.get('drive_pwm')];
    c = mot0.get('est_motor_amps');
    currents = [currents c*a+(1-a)*currents(end)];
    
    vs = [vs mot0.get('obs_supply_volts')];
    ts = [ts toc];
    
%     if abs(vels(end)) < abs(margin*target_spd)
%         tic
%     end
end
currents(1) = [];
est_T = currents*kt;
est_P = est_T.*vels;
ss = abs(vels)>abs(margin*target_spd);% steady state values
i = input('Enter I bus in Amps (if it''s different from prev)');
if ~isempty(i)
    I_bus = i;
end
est_P_in = vs*I_bus;
eff = est_P./est_P_in;
ave_eff = mean(eff(ss));
disp(['Average efficiency in steady state: ' num2str(ave_eff)])
subplot(2,3,1)
plot(ts,vels)
title('velocity')
grid on
subplot(2,3,2);
plot(ts,pwms)
title('pwm')
grid on
subplot(2,3,3);
plot(ts,currents)
title('current')
grid on
subplot(2,3,4);
plot(ts,vs)
title('volts')
grid on
subplot(2,3,5);
plot(ts,est_P)
title('Power Out')
grid on
subplot(2,3,6);
plot(ts,eff)
title('Efficiency')
grid on