function data = WaitForTypeParamReply(com, type_idn, param_idn, data_length)
% Block and poll until a message reply of type_idn and param_idn is recieved.
% On success the parameter data is returned (just the data, not type_idn,
% param_idn, or access byte).  Returns empty on failure afer timeout of 0.1 s.
pkt_length = data_length + 2; % param byte + access byte + data bytes
access = 3; % reply access value is 3
end_time = toc + 0.1;
data = uint8([]);
while(toc < end_time)
    com.GetBytes(); % get fresh serial data
    while true
        % parse messages
        [rx_type, rx_pkt] = com.PeekPacket();
        % if we got a message, see if it's the right one
        if ~isempty(rx_type)
            % if correct type, length, parameter byte, and access byte
            if rx_type == type_idn && numel(rx_pkt) == pkt_length && rx_pkt(1) == param_idn && rx_pkt(2) == access
                data = rx_pkt(3:end);
                return;
            end
        % if we didn't get a message, poll for more serial data
        else
            break;
        end
    end
end
end