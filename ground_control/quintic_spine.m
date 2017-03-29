function [cx cy cz] = quintic_spine(nSplines,waypts,time)
%%Quintic fit
A = zeros(6*nSplines,6*nSplines);
bx = zeros(6*nSplines,1);
by = zeros(6*nSplines,1);
bz = zeros(6*nSplines,1);
for i = 1:nSplines
    %position
    A(i,(i-1)*6+(1:6)) = [1 time(i) time(i)^2 time(i)^3 time(i)^4 time(i)^5];
    bx(i) = waypts(i,1); by(i) = waypts(i,2); bz(i) = waypts(i,3);  
    A(i+nSplines,(i-1)*6+(1:6)) = [1 time(i+1) time(i+1)^2 time(i+1)^3 time(i+1)^4 time(+1)^5];
    bx(i+nSplines) = waypts(i+1,1); by(i+nSplines) = waypts(i+1,2); bz(i+nSplines) = waypts(i+1,3); 
    
    if i ~= nSplines
    %velocity
    A(i+2*nSplines,(i-1)*6+(1:6)) = -1*[0 1 2*time(i+1) 3*time(i+1)^2 4*time(i+1)^3 5*time(i+1)^4];
    A(i+2*nSplines, i*6+(1:6)) = [0 1 2*time(i+1) 3*time(i+1)^2 4*time(i+1)^3 5*time(i+1)^4];
    
    %acceleration
    A(i+3*nSplines,(i-1)*6+(1:6)) = -1*[0 0 2 6*time(i+1) 12*time(i+1)^2 20*time(i+1)^3];
    A(i+3*nSplines,i*6+(1:6)) = [0 0 2 6*time(i+1) 12*time(i+1)^2 20*time(i+1)^5];
    
    %jerk
    A(i+4*nSplines,(i-1)*6+(1:6)) = -1*[0 0 0 6 24*time(i+1) 60*time(i+1)^2];
    A(i+4*nSplines,i*6+(1:6)) = [0 0 0 6 24*time(i+1) 60*time(i+1)^2];
    
    A(i+5*nSplines,(i-1)*6+(1:6)) = -1*[0 0 0 0 24 120*time(i+1)];
    A(i+5*nSplines,i*6+(1:6)) = [0 0 0 0 24 120*time(i+1)];
    end
end

    A(6*nSplines-1,1:6) = [0 1 0 0 0 0];
    A(6*nSplines,(nSplines-1)*6+(1:6)) = [0 1 2*time(nSplines+1) 3*time(nSplines+1)^2 4*time(nSplines+1)^3 5*time(nSplines+1)^4];
    
    
    cx = reshape(A \ bx,[6,nSplines])'
    cy = reshape(A \ by,[6,nSplines])'
    cz = reshape(A \ bz,[6,nSplines])'

end

