function [Iy, E] = rmHorSeam(I, My, Tby)
% I is the image. Note that I could be color or grayscale image.
% My is the cumulative minimum energy map along horizontal direction.
% Tby is the backtrack table along horizontal direction.
% Iy is the image removed one row.
% E is the cost of seam removal

[ny, nx, nz] = size(I);
rmIdx_row = zeros(1, nx);
rmIdx_col = zeros(1, nx);
Iy = (zeros(ny-1, nx, nz));

%% Add your code here
[~,idx] = min(My(:,end));
rmIdx_row(1) = ny;
rmIdx_col(1) = idx;
E = 0;
for i = 1:ny-1
    temp_idx = Tby(idx,ny+1-i); % Tby value, either 1, 2, or 3
    idx = temp_idx-2+idx;
    rmIdx_row(i+1) = ny-i;       % array of index position in each row
    rmIdx_col(i+1) = idx;    % array of index position in each col
    E = E + My(idx,ny+1-i);
end
for i = 1:nx
    temp_vect = [];
    temp_vect(:,:,:) = I(:,nx+1-i,:);
    temp_vect(rmIdx_col(i),:,:) = [];
    Iy(:,nx+1-i,:) = temp_vect;
end
end