function [ morphed_im ] = morph_tps( im_source, a1_x, ax_x, ay_x, w_x, a1_y, ax_y, ay_y, w_y, ctr_pts, sz )
m = sz(1);
n = sz(2);

[msz, ~] = size(ctr_pts);
morphed_im = zeros(m,n);
x = zeros(m,n);
y = zeros(m,n);
for i = 1:m
    for j =1:n
        sum_x = 0;
        sum_y = 0;
        for k = 1:msz
            r = norm(ctr_pts(k,:)-[i j]);
            if r == 0
                U = 0;
            else
                U = -r^2*log(r^2);
            end
            sum_x = sum_x + w_x(k)*U;
            sum_y = sum_y + w_y(k)*U;
        end
        x(i,j) = a1_x + i*ax_x + j*ay_x + sum_x;
        y(i,j) = a1_y + i*ax_y + j*ay_y + sum_y;
               
    end
%     for k = 1:3
%         morphed_im(i,j,k) = im_source(round(x),round(y),k);
%     end
x(x>m) = m;
x(x<1) = 1;
y(y>n) = n;
y(y<1) = 1;
end

    for j = 1:3
        morphed_im(:,:,j) = uint8(interp2(1:n,1:m,double(im_source(:,:,j)),y,x));
    end
end

