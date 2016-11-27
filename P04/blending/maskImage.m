function mask = maskImage(Img)
figure, imshow(Img);
%select contents to blend
h = imfreehand;
wait(h);

%create mask
mask = createMask(h);
end

