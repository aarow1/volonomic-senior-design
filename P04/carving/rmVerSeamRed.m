function [Ix, E] = rmVerSeamRed(I, Mx, Tbx)
% I is the image. Note that I could be color or grayscale image.
% Mx is the cumulative minimum energy map along vertical direction.
% Tbx is the backtrack table along vertical direction.
% Ix is the image removed one column.
% E is the cost of seam removal

% [ny, nx, nz] = size(I);
% rmIdx = zeros(ny, 1);
% Ix = uint8(zeros(ny, nx-1, nz));

[ny, nx, nz] = size(I);
rmIdx_row = zeros(1, ny);
rmIdx_col = zeros(1, ny);
% Ix = (zeros(ny, nx-1, nz));
Ix = (zeros(ny, nx, nz));

%% Add your code here
[~,idx] = min(Mx(end,:));
rmIdx_row(1) = ny;
rmIdx_col(1) = idx;
E = 0;
for i = 1:ny-1
    temp_idx = Tbx(ny+1-i,idx); % Tby value, either 1, 2, or 3
    idx = temp_idx-2+idx;
    rmIdx_row(i+1) = ny-i;       % array of index position in each row
    rmIdx_col(i+1) = idx;    % array of index position in each col
    E = E + Mx(ny-i+1, idx);
end
for i = 1:ny
    temp_vect = [];
    temp_vect(:,:,:) = I(ny+1-i,:,:);
%     temp_vect(:,rmIdx_col(i),:) = [];
temp_vect(:,rmIdx_col(i),1) = 255;
temp_vect(:,rmIdx_col(i),2) = 0;
temp_vect(:,rmIdx_col(i),3) = 0;
    Ix(ny+1-i,:,:) = temp_vect;
end
end