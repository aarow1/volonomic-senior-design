function [ morphed_im ] = morph_tps_wrapper( im1, im2, im1_pts, im2_pts, warp_frac, dissolve_frac )
[m,n,o] = size(im2);
%intermediate shape: t=warp_frac
mid_pts = (1-warp_frac)*im1_pts + warp_frac*im2_pts;
mid_pts = [mid_pts(:,2) mid_pts(:,1)];
im1_pts = [im1_pts(:,2) im1_pts(:,1)];
im2_pts = [im2_pts(:,2) im2_pts(:,1)];
% [a1_x1, ax_x1, ay_x1, w_x1] = est_tps(im1_pts,mid_pts(:,1));
% [a1_y1, ax_y1, ay_y1, w_y1] = est_tps(im1_pts,mid_pts(:,2));
% [a1_x2, ax_x2, ay_x2, w_x2] = est_tps(im2_pts,mid_pts(:,1));
% [a1_y2, ax_y2, ay_y2, w_y2] = est_tps(im2_pts,mid_pts(:,2));
[a1_x1, ax_x1, ay_x1, w_x1] = est_tps(mid_pts,im1_pts(:,1));
[a1_y1, ax_y1, ay_y1, w_y1] = est_tps(mid_pts,im1_pts(:,2));
[a1_x2, ax_x2, ay_x2, w_x2] = est_tps(mid_pts,im2_pts(:,1));
[a1_y2, ax_y2, ay_y2, w_y2] = est_tps(mid_pts,im2_pts(:,2));
morphed_im = zeros(m,n);
m1 = morph_tps(im1, a1_x1, ax_x1, ay_x1, w_x1, a1_y1, ax_y1, ay_y1, w_y1, mid_pts, [m,n]);
m2 = morph_tps(im2, a1_x2, ax_x2, ay_x2, w_x2, a1_y2, ax_y2, ay_y2, w_y2, mid_pts, [m,n]);
for i = 1:3
    morphed_im(:,:,i) = (1-dissolve_frac)*double(m1(:,:,i)) + dissolve_frac*double(m2(:,:,i));
end
morphed_im = uint8(morphed_im);
end

