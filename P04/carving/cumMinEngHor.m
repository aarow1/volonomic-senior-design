function [My, Tby] = cumMinEngHor(e)
% e is the energy map.
% My is the cumulative minimum energy map along horizontal direction.
% Tby is the backtrack table along horizontal direction.

[ny,nx] = size(e);
My = zeros(ny, nx);
Tby = zeros(ny, nx);
My(:,1) = e(:,1);
My = padarray(My,[1 0], inf, 'both');

%% Add your code here
for i = 2:ny+1
    for j = 2:nx
        My(i,j) = e(i-1,j) + min(My(i-1:i+1,j-1));
        [~,idx] = min(My(i-1:i+1,j-1));
        Tby(i-1,j) = idx;
    end
end
My = My(2:end-1,:);
end