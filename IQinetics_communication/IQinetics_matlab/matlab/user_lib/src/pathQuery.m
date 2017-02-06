function found = pathQuery(funcStr, suggestedPath)
%
% Check for funcStr in matlab's path, and if is not there
% give a suggestion as to where it might be located.
% 
% Ian O'Hara (ianohara at gmail), 2012
if (exist(funcStr, 'file'))
    found = 1;
else
    found = 0;
    error('Cannot find %s in the path.  It might be at %s. Find the directory it is in and use addpath() to make it visible.', funcStr, suggestedPath)
end
end
