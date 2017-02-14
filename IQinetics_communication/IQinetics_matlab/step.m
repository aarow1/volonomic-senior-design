target_spd = 1000;
margin = .9;
vels = [];
ts = [];
hold_time = 1.5;
tic
while toc < hold_time
    mot.set('cmd_velocity', target_spd);
    vels = [vels mot.get('obs_velocity')];
    ts = [ts toc];
    
    if vels(end) < margin*target_spd
        tic
    end
end

plot(ts,vels)