function eq = approxEqual(a,b)
    eq = abs(a-b) < abs(a)*.01;
end