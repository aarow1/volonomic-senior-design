function pauseWithPoll(com, t)
    kSpecPoll = struct('Type', 14, 'Fields', struct());
    msg = struct();

    end_time = toc + t;
    while toc < end_time
        com.SendMsg(kSpecPoll, msg);
        while true
            com.GetBytes();
            [rx_type, ~] = com.PeekPacket();	% check for messages
            if isempty(rx_type)                 % throw away messages
                break;
            end
        end
        pause(0.01);
    end
end