function [] = ping()
disp('pinging...');
global xbee
ping_length = 20;
nPings = 0;
reading = 0;

PKT_START_ENTRY = 32;
% ALL_INPUTS_TYPE = 33;
% NO_VICON_TYPE = 34;
% MOTOR_FORCES_TYPE = 35;
% MOTOR_SPEEDS_TYPE = 36;
% GAINS_TYPE = 37;
PING_TYPE = 38;
RETURN_TYPE = 39;
% STOP_TYPE = 40;
PKT_END_ENTRY = 69;
while (nPings <= ping_length)
    tic;
    sendPkt('ping');
    nPings = nPings + 1;
    reading = 1;
    while reading
        if (xbee.BytesAvailable)
            reading = 0;
        end
    end
    pause(.1);
end
nPings
sendPkt('stop');
disp('finished pinging');
end


