function [] = ping()
fprintf('pinging...');
global xbee ping_time
ping_length = 20;
reading = 0;

ping_times = zeros(ping_length, 2);

for nPings = 1:ping_length
    ping_times(nPings, 1) = toc*1000;
    ping_time = ping_times(nPings, 1);
    sendPkt('ping');
    reading = 1;
    while reading
        if (xbee.BytesAvailable)
            ping_times(nPings, 2) = toc*1000;
            flushinput(xbee);
            reading = 0;
            fprintf('.');
        end
    end
    pause(.1);
end
fprintf(' finished pinging\n');
sendPkt('stop');
end


