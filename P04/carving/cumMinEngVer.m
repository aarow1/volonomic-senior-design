function [Mx, Tbx] = cumMinEngVer(e)
% e is the energy map.
% Mx is the cumulative minimum energy map along vertical direction.
% Tbx is the backtrack table along vertical direction.

[ny,nx] = size(e);
Mx = zeros(ny, nx);
Tbx = zeros(ny, nx);
Mx(1,:) = e(1,:);
Mx = padarray(Mx,[0 1], inf, 'both');

%% Add your code here


for i = 2:ny
    for j = 2:nx+1
        Mx(i,j) = e(i,j-1) + min(Mx(i-1,j-1:j+1));
        [~,idx] = min(Mx(i-1,j-1:j+1));
        Tbx(i,j-1) = idx;
    end
end
Mx = Mx(:,2:end-1);
end