
function [Ic, T] = carv(I, nr, nc)
% I is the image being resized
% [nr, nc] is the numbers of rows and columns to remove.
% Ic is the resized image
% T is the transport map

[ny, nx, nz] = size(I);
T = zeros(nc+1, nr+1);
TI = cell(nc+1, nr+1);
TI{1,1} = I;
% TI is a trace table for images. TI{r+1,c+1} records the image removed r rows and c columns.

%% Add your code here
total = nc+nr;
prevRow = 1;
prevCol = 1;
for k = 1:total
    k
        I = TI{prevCol,prevRow};
        e = genEngMap(TI{prevCol,prevRow});
        [My, Tby] = cumMinEngHor(e);
        [Iy, Ey] = rmHorSeam(I, My, Tby);
        [Mx, Tbx] = cumMinEngVer(e);
        [Ix, Ex] = rmVerSeam(I, Mx, Tbx);
        [~,idx] = min([Ex Ey inf]);
        
        if prevCol > nc
            n = 2;
        elseif prevRow > nr
            n = 1;
        else
            n = idx;
        end
        switch n
            case 1
                prevCol = prevCol+1;
                TI{prevCol,prevRow} = uint8(Iy);
                T(prevCol,prevRow) = Ey; 
            case 2
                prevRow = prevRow+1;
                TI{prevCol,prevRow} = uint8(Ix);
                T(prevCol,prevRow) = Ex;
            otherwise
        end
                
end
Ic = TI{prevCol,prevRow};
T = T';
end