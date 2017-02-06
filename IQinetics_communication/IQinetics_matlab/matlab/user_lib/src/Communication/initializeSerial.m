function [ serialHandle ] = initializeSerial( comPort , varargin)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if nargin == 2 % baud rate specified
    baudRate = varargin{1};
else
    baudRate = 115200;
end % nargin == 2 % baud rate specified

serialHandle = instrfind('Port',comPort,'Status','open');
if isempty(serialHandle)
    serialHandle = serial(comPort,'BAUD',baudRate);
    serialHandle.BytesAvailableFcnMode = 'byte';
    fopen(serialHandle);
end % isempty(serialHandle)

end

