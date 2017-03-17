function [ morphed_im ] = morph( im1, im2, im1_pts, im2_pts, warp_frac, dissolve_frac )
[m,n,~] = size(im1);
%calculate coordinates: t=0.5
% mid_pts = .5*im1_pts + .5*im2_pts;
% mid_pts = [mid_pts(:,2) mid_pts(:,1)];
%intermediate shape: t=warp_frac
m_pts = (1-warp_frac)*im1_pts + warp_frac*im2_pts;
m_pts = [m_pts(:,2) m_pts(:,1)];
%delaunay triagulation: t=0.5
DT = delaunay(m_pts(:,1), m_pts(:,2));
[mCL,~] = size(DT);
%all point coords
[X,Y] = meshgrid(1:m,1:n);
XI = [X(:) Y(:)];
[mXI, ~] = size(XI);

[t,~] = tsearchn(m_pts,DT,XI);
cornersOn = 0;
%0 no corners selected
%1 corners selcted
roundOn = 0;
%1 round pixel positions
%0 interp2 pixel positions

if ~cornersOn
    tTemp = [];
    xiTemp = [];
    for i = 1:mXI
        if ~isnan(t(i))
            tTemp = [tTemp; t(i)];
            xiTemp = [xiTemp; XI(i,:)];
        end
    end
    t = tTemp;
    XI = xiTemp;
    [mXI, ~] = size(t);
end
if ~roundOn
    xs_store = zeros(m,n);
    xt_store = zeros(m,n);
    ys_store = zeros(m,n);
    yt_store = zeros(m,n);
end
%computing A matricies
A = zeros(3,3,mCL);
A_inv = zeros(3,3,mCL);
for i = 1:mCL
    a = m_pts(DT(i,1),:);
    b = m_pts(DT(i,2),:);
    c = m_pts(DT(i,3),:);
    A(:,:,i) = [a(1) b(1) c(1);
        a(2) b(2) c(2);
        1    1   1];
    A_inv(:,:,i) = inv(A(:,:,i));
end
%barycentric coordinates
bary_coords = zeros(3,mXI);
for i = 1:mXI
    x = XI(i,1);
    y = XI(i,2);
    b = [x y 1]';
    bary_coords(:,i) = A_inv(:,:,t(i))*b;
end
%mapping
im1_pts = [im1_pts(:,2) im1_pts(:,1)];
im2_pts = [im2_pts(:,2) im2_pts(:,1)];
morphed_im = zeros(m,n);
for i = 1:mXI
    x = XI(i,1);
    y = XI(i,2);
    tri_ID = DT(t(i),:);
    
    %verticies in source
    a = im1_pts(tri_ID(1),:);
    b = im1_pts(tri_ID(2),:);
    c = im1_pts(tri_ID(3),:);
    A_s = [a(1) b(1) c(1);
        a(2) b(2) c(2);
        1    1   1];
    b_s = A_s*bary_coords(:,i);
    %pixel locations in source
    x_s = b_s(1)/b_s(3); y_s = b_s(2)/b_s(3);
    
    %verticies in target
    a = im2_pts(tri_ID(1),:);
    b = im2_pts(tri_ID(2),:);
    c = im2_pts(tri_ID(3),:);
    A_t = [a(1) b(1) c(1);
        a(2) b(2) c(2);
        1    1   1];
    b_t = A_t*bary_coords(:,i);
    %pixel locations in target
    x_t = b_t(1)/b_t(3); y_t = b_t(2)/b_t(3);
    
    if roundOn
        x_s = round(x_s);
        y_s = round(y_s);
        x_t = round(x_t);
        y_t = round(y_t);
        %color morph
        for j = 1:3
            morphed_im(x,y,j) = uint8(dissolve_frac*double(im1(x_s,y_s,j)) + ...
                (1-dissolve_frac)*double(im2(x_t,y_t,j)));
        end
    else
        xs_store(x,y) = x_s;
        xt_store(x,y) = x_t;
        ys_store(x,y) = y_s;
        yt_store(x,y) = y_t;
    end
end
if ~roundOn
    for j = 1:3
        morphed_im(:,:,j) = uint8((1-dissolve_frac)*(interp2(1:n,1:m,double(im1(:,:,j)),ys_store,xs_store)) + ...
            (dissolve_frac)*(interp2(1:n,1:m,double(im2(:,:,j)),yt_store,xt_store)));
    end
    morphed_im = uint8(morphed_im);

end
end

