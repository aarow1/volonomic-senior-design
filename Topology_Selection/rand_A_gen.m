function A = rand_A_gen(n_A_mats)
x = 'x';
y = 'y';
z = 'z';
A = [];
p = haltonset(7); p = scramble(p,'RR2');
thetaList = 2*pi*net(p,n_A_mats);
for ii = 1:n_A_mats
   
    thetas = thetaList(ii,:);
%     thetas = 2*pi*rand([1 7]);
    
    F_1 = Rot3D(z,0)*Rot3D(y,thetas(1))*[0 0 1 1]';
    F_2 = Rot3D(z,2*pi/5)*Rot3D(y,thetas(2))*[0 0 1 1]';
    F_3 = Rot3D(z,4*pi/5)*Rot3D(y,thetas(3))*[0 0 1 1]';
    F_4 = Rot3D(z,6*pi/5)*Rot3D(y,thetas(4))*[0 0 1 1]';
    F_5 = Rot3D(z,8*pi/5)*Rot3D(y,thetas(5))*[0 0 1 1]';
    F_6 = Rot3D(z,thetas(6))*[0 1 0 1]';
    F_7 = Rot3D(z,thetas(7))*[0 1 0 1]';
    F = [F_1 F_2 F_3 F_4 F_5 F_6 F_7];
    F = F(1:3,:);
    
    P_1 = Rot3D(z,0)*[0 1 0 1]';
    P_2 = Rot3D(z,2*pi/5)*[0 1 0 1]';
    P_3 = Rot3D(z,4*pi/5)*[0 1 0 1]';
    P_4 = Rot3D(z,6*pi/5)*[0 1 0 1]';
    P_5 = Rot3D(z,8*pi/5)*[0 1 0 1]';
    P_6 = [0 0 1 1]';
    P_7 = [0 0 -1 1]';
    P = [P_1 P_2 P_3 P_4 P_5 P_6 P_7];
    P = P(1:3,:);
    
    M = cross(F,P);
    W = [F; M];
    
    A(:,:,ii) = W;
    
end

end

