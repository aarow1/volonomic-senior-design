
x = 'x';
y = 'y';
z = 'z';

% t_1 = .5;
% t_2 = .3;
% t_3 = 0;
% t_4 = 0;
% t_5 = .1;
% t_6 = .8;
% t_7 = 0;

% t_1 = 0;
% t_2 = 0;
% t_3 = 0;
% t_4 = 0;
% t_5 = 0;
% t_6 = 0;
% t_7 = 0;
index = 1;
tic
step = pi/6;
theta = theta_gen_unique();

for i = 1:length(theta)
    t_1 = theta(i,1);
    t_2 = theta(i,2);
    t_3 = theta(i,3);
    t_4 = theta(i,4);
    t_5 = theta(i,5);
    
    for t_6 = 0:step:11*pi/6
        for t_7 = 0:step:11*pi/6
            
            F_1 = Rot3D(z,0)*Rot3D(y,t_1)*[0 0 1 1]';
            F_2 = Rot3D(z,2*pi/5)*Rot3D(y,t_2)*[0 0 1 1]';
            F_3 = Rot3D(z,4*pi/5)*Rot3D(y,t_3)*[0 0 1 1]';
            F_4 = Rot3D(z,6*pi/5)*Rot3D(y,t_4)*[0 0 1 1]';
            F_5 = Rot3D(z,8*pi/5)*Rot3D(y,t_5)*[0 0 1 1]';
            F_6 = Rot3D(z,t_6)*[0 1 0 1]';
            F_7 = Rot3D(z,t_7)*[0 1 0 1]';
            
            P_1 = Rot3D(z,0)*[0 1 0 1]';
            P_2 = Rot3D(z,2*pi/5)*[0 1 0 1]';
            P_3 = Rot3D(z,4*pi/5)*[0 1 0 1]';
            P_4 = Rot3D(z,6*pi/5)*[0 1 0 1]';
            P_5 = Rot3D(z,8*pi/5)*[0 1 0 1]';
            P_6 = [0 0 1 1]';
            P_7 = [0 0 -1 1]';
            
            F_1 = F_1(1:3);
            F_2 = F_2(1:3);
            F_3 = F_3(1:3);
            F_4 = F_4(1:3);
            F_5 = F_5(1:3);
            F_6 = F_6(1:3);
            F_7 = F_7(1:3);
            
            P_1 = P_1(1:3);
            P_2 = P_2(1:3);
            P_3 = P_3(1:3);
            P_4 = P_4(1:3);
            P_5 = P_5(1:3);
            P_6 = P_6(1:3);
            P_7 = P_7(1:3);
            
            M_1 = cross(F_1,P_1);
            M_2 = cross(F_2,P_2);
            M_3 = cross(F_3,P_3);
            M_4 = cross(F_4,P_4);
            M_5 = cross(F_5,P_5);
            M_6 = cross(F_6,P_6);
            M_7 = cross(F_7,P_7);
            
            W_1 = cat(1,F_1,M_1);
            W_2 = cat(1,F_2,M_2);
            W_3 = cat(1,F_3,M_3);
            W_4 = cat(1,F_4,M_4);
            W_5 = cat(1,F_5,M_5);
            W_6 = cat(1,F_6,M_6);
            W_7 = cat(1,F_7,M_7);
            
            A(:,:,index) = [W_1 W_2 W_3 W_4 W_5 W_6 W_7];
            index = index+1;
        end
    end
end
toc