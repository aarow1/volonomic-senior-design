clear all; close all;
display('----START-----');
display(['timestamp: ' datestr(now, 'HH:MM:SS')]);
x = 'x';
y = 'y';
z = 'z';

index = 1;
tic
step = pi/12;
stepEnd = 2*pi-step;
theta = theta_gen_unique(pi/12);
modsplit = 1000;

for i = 1:length(theta);
    t_1 = theta(i,1);
    t_2 = theta(i,2);
    t_3 = theta(i,3);
    t_4 = theta(i,4);
    t_5 = theta(i,5);
    
    for t_6 = 0:step:stepEnd
        for t_7 = 0:step:stepEnd
            
            F = [Rot3D(z,0)*Rot3D(y,t_1)*[0 0 1 1]' ...
                Rot3D(z,2*pi/5)*Rot3D(y,t_2)*[0 0 1 1]'...
                Rot3D(z,4*pi/5)*Rot3D(y,t_3)*[0 0 1 1]' ...
                Rot3D(z,6*pi/5)*Rot3D(y,t_4)*[0 0 1 1]' ...
                Rot3D(z,8*pi/5)*Rot3D(y,t_5)*[0 0 1 1]' ...
                Rot3D(z,t_6)*[0 1 0 1]' ...
                Rot3D(z,t_7)*[0 1 0 1]'];
            F = F(1:3);
            
            P = [Rot3D(z,0)*[0 1 0 1]' ...
                Rot3D(z,2*pi/5)*[0 1 0 1]' ...
                Rot3D(z,4*pi/5)*[0 1 0 1]' ...
                Rot3D(z,6*pi/5)*[0 1 0 1]' ...
                Rot3D(z,8*pi/5)*[0 1 0 1]' ...
                [0 0 1 1]' ...
                [0 0 -1 1]'];
            P = P(1:3);
            
            M = cross(F,P);
            A(:,:,index) = [F;M];
            index = index+1;
        end
    end
    T = toc;
    if (mod(i,modsplit) == 0)
        display(['\ntimestamp: ' datestr(now, 'HH:MM:SS')]);
        fprintf('%02d / %02d - %05.0f / %05.0f', ...
            i, length(theta), T, T/i*length(theta));
    end
end
