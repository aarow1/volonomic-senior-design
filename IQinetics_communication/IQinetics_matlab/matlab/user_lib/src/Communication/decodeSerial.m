function [ type, data, buffer ] = decodeSerial( buffer )
%decodeSerial enables extraction of well formed, crc-verified packets from a 
%  byte stream. It is a specialized queue/buffer which takes in raw bytes and 
%  returns packet data. The returned packet data is a byte array consisting of 
%  a type byte followed by data bytes.
% 
%  General Packet Format:
%  | 0x55 | length | type | ---data--- | crcL | crcH |
%    'length' is the (uint8) number of bytes in 'data'
%    'type' is the (uint8) message type
%    'data' is a series of (uint8) bytes, serialized Little-Endian
%    'crc' is the (uint16) CRC value for 'length'+'type'+'data', Little-Endian

try
startByte = 85; % 0x55
type = [];
data = [];

starts = find(buffer == startByte); 
if isempty(starts)
    return;
end
startind = 1;
endLoc = 0;

while startind < length(starts)
    start = starts(startind);
    if length(buffer) > start+2% && buffer(start + 1) == startByte
        count = double(buffer(start+1));
        % find crc
        if length(buffer) >= start+2+count 
            [dummy_variable, crc] = AppendCRC(buffer(start+1:start+2+count));
            % compare calculated crc to input crc
            if (crc(1) == buffer(start+3+count) && crc(2) == buffer(start+4+count))
                % successful message!
                type(end+1) = buffer(start+2);
                data{end+1} = buffer(start+3:start+2+count);
                startind = startind + 1;
                endLoc = start+5+count;
            else
                % bad message!
                startind = startind + 1;
%                 disp('bad crc');
            end
        else
            startind = startind + 1;
%             disp('bad length');
        end
    else
        % bad message!
        startind = startind + 1;
%         disp('bad start');
    end
end
buffer = buffer(max(starts(end),endLoc):end);
catch
    type = [];
    data = [];
    buffer = [];
end