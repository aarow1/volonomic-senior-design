function [ match] = matchFeat( tileBins1,tileBins2 )
%input: tileBins1- 128 x N1
% match is n1x1 vector of integers where m(i) points to the index of the
% descriptor in p2 that matches with the descriptor p1(:,i).
% If no match is found, m(i) = -1
tileBins1 = tileBins1';
tileBins2 = tileBins2';
thresh = .8;
[m,n] = size(tileBins1);

idx = knnsearch(tileBins1,tileBins2,'K',2);
match = zeros(m,1);
for i = 1:m
    ssd1 = ssd(tileBins2(i,:),tileBins1(idx(i,1),:));
    ssd2 = ssd(tileBins2(i,:),tileBins1(idx(i,2),:));
    if (ssd1/ssd2 <= thresh)
        match(i) = idx(i,1);
    else
        match(i) = -1;
    end
end

end