function [ G ] = gauss2d( x, x0, y, y0 )
sigma = 1.5;
% A = 1/(sigma*sqrt(2*pi));
A = 1;
G = A*exp(-(((x-x0)^2)/(2*sigma^2)+((y-y0)^2)/(2*sigma^2)));
end

