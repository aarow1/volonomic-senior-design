function [ c_x, c_y, c_z ] = cubic_spline( n_splines, newpath, time2 )
disp('wtf');
%CUBIC_SPLINE 
    x_coefs = zeros(4*n_splines, 4*n_splines);
    y_coefs_x = zeros(4*n_splines,1);
    y_coefs_y = zeros(4*n_splines,1);
    y_coefs_z = zeros(4*n_splines,1);
    
    for n = 1:n_splines
        x_coefs(n,(n-1)*4+(1:4)) = [1, time2(n), time2(n)^2, time2(n)^3];
        y_coefs_x(n) = newpath(n,1);
        y_coefs_y(n) = newpath(n,2);
        y_coefs_z(n) = newpath(n,3);
        
        % continuity of position
        x_coefs(n+n_splines,(n-1)*4+(1:4)) = [1, time2(n+1), time2(n+1)^2, time2(n+1)^3];
        y_coefs_x(n+n_splines) = newpath(n+1,1);
        y_coefs_y(n+n_splines) = newpath(n+1,2);
        y_coefs_z(n+n_splines) = newpath(n+1,3);
    end
    
    for n = 1:n_splines-1
        % continuity of velocity
        x_coefs(n+2*n_splines, (n-1)*4+(1:4) ) = -1*[0, 1, 2*time2(n+1), 3*time2(n+1)^2];
        x_coefs(n+2*n_splines, n*4+(1:4) ) = [0, 1, 2*time2(n+1), 3*time2(n+1)^2];
        
        % continuity of acceleration
        x_coefs(n+3*n_splines-1, (n-1)*4+(1:4) ) = -1*[0, 0, 2, 6*time2(n+1)];
        x_coefs(n+3*n_splines-1, n*4+(1:4) ) = [0, 0, 2, 6*time2(n+1)];
        % corresponding y are 0
    end
    % clamped spline, v = 0 at first at start and end
    x_coefs(4*n_splines-1,1:4) = [0, 1, 2*time2(1), 3*time2(1)^2];
    x_coefs(4*n_splines,(n_splines-1)*4+(1:4)) = [0, 1, 2*time2(n_splines+1), 3*time2(n_splines+1)^2];
    % corresponding y are 0  
    
    c_x = reshape(x_coefs \ y_coefs_x,[4,n_splines])';
    c_y = reshape(x_coefs \ y_coefs_y,[4,n_splines])';
    c_z = reshape(x_coefs \ y_coefs_z,[4,n_splines])';
    disp(x_coefs);
    disp('yay');
end

