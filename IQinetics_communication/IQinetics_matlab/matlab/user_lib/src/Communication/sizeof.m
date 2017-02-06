function [ num_bytes ] = sizeof( type_string )
%sizeof Takes a string type and returns is size in bytes
%   sizeof returns empty if it does not recognize the size type.
%   Using hard coded values is fast, and IS legal because the matlab
%   documentation indicates types are consistent across platform/chipsets.

switch type_string 
    case {'double','int64','uint64'}
        num_bytes = 8;
    case {'single', 'int32', 'uint32'}
        num_bytes = 4;
    case {'int8', 'uint8'}
        num_bytes = 1;
    case {'int16','uint16'}
        num_bytes = 2;
    otherwise
        num_bytes = [];
end

