function mask = maskImage(Img)
figure, imshow(Img);
h = imfreehand;
wait(h);
mask = createMask(h);
end

