function [ n_splines, newpath ] = remove_colinear( thresh1, thresh2, thresh3, path0 )
%REMOVE_COLINEAR 
    keep = logical(ones(size(path0,1),1));
    last = path0(1,:);
    
    for i = (2:size(path0,1)-1)
        keep(i) = ~(colinear3D(path0(i-1,:),path0(i,:),path0(i+1,:),thresh3) || norm(last - path0(i,:)) < thresh1) || norm(last - path0(i,:)) > thresh2 ;
        if keep(i)
            last = path0(i,:);
        end
    end
    newpath = path0(keep,:);
    n_splines = size(newpath,1)-1;
end

