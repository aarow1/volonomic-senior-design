function [amsg, crc] = AppendCRC(message)
% Appends the CRC-16-CCITT to message
% It returns the complete message in amsg, and the individual bytes in
% crc.

message = uint8(message);
crc = uint16(65535); %hex2dec('ffff');

for i = 1:length(message)
    x = bitxor(bitshift(crc,-8),uint16(message(i)));
    x = bitxor(x,bitshift(x,-4));
    crc = bitxor(bitxor(bitxor(bitshift(crc,8),bitshift(x,12)),bitshift(x,5)),x);
end

crc = [bitand(crc,255); bitshift(crc,-8)];

amsg = [message; cast(crc,'uint8')];

end
