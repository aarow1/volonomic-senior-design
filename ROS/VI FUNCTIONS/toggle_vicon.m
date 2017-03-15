function [] = toggle_vicon(cmd)
% changes whether or not vicon packets are being sent
% INPUT: 'on' -- send vicon update
%        'off' -- dont send vicon update

global vicon_on
if cmd == 'on'
    vicon_on = 1;
elseif cmd == 'off' 
    vicon_on = 0;
end
disp(vicon_on);

end

