function out(verbose,message)
% out(verbose,message) is disp, but can be disabled with verbose
%   If verbose is a boolean of true, the message will be displayed
%   If verbose is a number == 1, the message will be displayed
%   If verbose is a string of either 'Y' or 'y', the message will be displayed

    if verbose == true || verbose == 1 || strcmpi(verbose,'y')
        disp(message);
    end
end