function [ mask_img ] = makeMask( img,convHullX,convHullY )
cut_image = imshow(rgb2gray(img));
poly = impoly(gca, [convHullX' convHullY']);
mask = createMask(poly,cut_image);
for i = 1:3
mask_img(:,:,i) = img(:,:,i) .* uint8(mask);
end

end

