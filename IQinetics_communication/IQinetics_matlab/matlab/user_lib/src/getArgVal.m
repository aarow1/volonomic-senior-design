function val = getArgVal(argStr, args, varargin)
%
% Look for argStr in cell array args and return
% the value that follows as the next item in args.
% 
% If nargin > 2, use the third argument as a default
% value if argStr is not in args.
%
% Ian O'hara (ianohara at gmail), 2012

ind = find(strcmp(args, argStr));
if (isempty(ind))
    if (nargin == 3) % Default value specified
        val = varargin{1};
        return;
    end
    error('Argument ''%s'' not found.', argStr);
end
if (length(args) < (ind + 1)) % Not enough arguments
    error('Not enough arguments to get value following ''%s'' option.', argStr);
end
val = args{ind+1}; % Woot!  Success.
end
