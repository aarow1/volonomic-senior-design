function [Ic, T] = carv(I, nr, nc)
% I is the image being resized
% [nr, nc] is the numbers of rows and columns to remove.
% Ic is the resized image
% T is the transport map

[ny, nx, nz] = size(I);
T = zeros(nr+1, nc+1);
TI = cell(nr+1, nc+1);
TI{1,1} = I;
% TI is a trace table for images. TI{r+1,c+1} records the image removed r rows and c columns.

%% Add your code here
total = nc+nr;
prevRow = 1;
prevCol = 1;
for k = 1:total
        e = genEngMap(TI{prevCol,prevRow});
        [My, Tby] = cumMinEngHor(e);
        [Iy, Ey] = rmHorSeam(A, My, Tby);
        [Mx, Tbx] = cumMinEngVer(e);
        [Ix, Ex] = rmVerSeam(A, Mx, Tbx);
        [~,idx] = min(Ey,Ex);
        if (idx == 1) && (prevCol <= nc)
            prevCol = prevCol+1;
            TI{prevCol,prevRow} = Iy;
            T(prevCol,prevRow) = Ey; 
        elseif (idx == 2) && (prevRow <= nr)
            prevRow = prevRow+1;
            TI{prevCol,prevRow} = Ix;
            T(prevCol,prevRow) = Ex;
        end
end
Ic = TI{nr+1,nc+1};

end