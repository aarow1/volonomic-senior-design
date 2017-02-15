target_spd = -50;
margin = .9;
vels = [];
ts = [];
hold_time = 3;
tic
while toc < hold_time
    mot.set('cmd_velocity', target_spd);
    vels = [vels mot.get('obs_velocity')];
    ts = [ts toc];
    
    if abs(vels(end)) < abs(margin*target_spd)
        tic
    end
end

plot(ts,vels)