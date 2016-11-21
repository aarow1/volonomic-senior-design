function resultImg = seamlessCloningPoisson(sourceImg, targetImg, mask, offsetX, offsetY)
[targetH, targetW] = size(targetImg);
indexes = getIndexes(mask,targetH,targetW,offsetX,offsetY);
coefM = getCoefMatrix(indexes);
solVectorR = getSolutionVect(indexes, sourceImg(:,:,1), targetImg(:,:,1), offsetX, offsetY);
solVectorG = getSolutionVect(indexes, sourceImg(:,:,2), targetImg(:,:,2), offsetX, offsetY);
solVectorB = getSolutionVect(indexes, sourceImg(:,:,3), targetImg(:,:,3), offsetX, offsetY);
red = coefM\solVectorR;
green = coefM\solVectorG;
blue = coefM\solVectorB;
[resultImg] = reconstructImg(indexes, red, green, blue, targetImg);
end