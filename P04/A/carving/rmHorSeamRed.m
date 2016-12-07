function [Iy, E] = rmHorSeamRed(I, My, Tby)
% I is the image. Note that I could be color or grayscale image.
% My is the cumulative minimum energy map along horizontal direction.
% Tby is the backtrack table along horizontal direction.
% Iy is the image removed one row.
% E is the cost of seam removal

[ny, nx, nz] = size(I);
rmIdx_row = zeros(1, nx);
rmIdx_col = zeros(1, nx);
% Iy = (zeros(ny-1, nx, nz));
Iy = (zeros(ny, nx, nz));

%% Add your code here
[~,idx] = min(My(:,end));
rmIdx_row(1) = idx;
rmIdx_col(1) = nx;
E = 0;
for i = 1:nx-1
    temp_idx = Tby(idx,nx+1-i); % Tby value, either 1, 2, or 3
    idx = temp_idx-2+idx;       % shift row that you look at
    rmIdx_row(i+1) = idx;       % array of index position in each row
    rmIdx_col(i+1) = nx-i;    % array of index position in each col
    E = E + My(idx,nx+1-i);
end
for i = 1:nx
    temp_vect = [];
    temp_vect(:,:,:) = I(:,nx+1-i,:);
%     temp_vect(rmIdx_row(i),:,:) = [];
    temp_vect(rmIdx_row(i),:,1) = 255;
    temp_vect(rmIdx_row(i),:,2) = 0;
    temp_vect(rmIdx_row(i),:,3) = 0;
    Iy(:,nx+1-i,:) = temp_vect;
end
end