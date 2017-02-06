function [ packet ] = encodeSerial( type, data )
%encodeSerial creates a serial packet
% Creates a packet of containing a message type and data.  The crc is
% calculated and appended using CRC-16-CCITT.
% 
% Packet format:
% Packet: | 0x55 | count | type | ---data--- | crcL | crcH |
% State:     0       1      2      3     4      5      6

packet = AppendCRC([length(data); type; data(:)]);

packet = [uint8(85); packet];
end
