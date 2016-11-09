
x = 'x';
y = 'y';
z = 'z';
A = [];
index = 1;
tic
step = pi/2;
for t_1 = step:step:2*pi
    for t_2 = step:step:2*pi
        for t_3 = step:step:2*pi
            for t_4 = step:step:2*pi
                for t_5 = step:step:2*pi
                    for t_6 = step:step:2*pi
                        for t_7 = step:step:2*pi
                            
                            F_1 = Rot3D(z,0)*Rot3D(y,t_1)*[0 0 1 1]';
                            F_2 = Rot3D(z,2*pi/5)*Rot3D(y,t_2)*[0 0 1 1]';
                            F_3 = Rot3D(z,4*pi/5)*Rot3D(y,t_3)*[0 0 1 1]';
                            F_4 = Rot3D(z,6*pi/5)*Rot3D(y,t_4)*[0 0 1 1]';
                            F_5 = Rot3D(z,8*pi/5)*Rot3D(y,t_5)*[0 0 1 1]';
                            F_6 = Rot3D(z,t_6)*[0 1 0 1]';
                            F_7 = Rot3D(z,t_7)*[0 1 0 1]';
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
                            
                            A(:,:,index) = W;
                           index = index+1;
                        end
                    end     
                end
            end
        end
    end
    T = toc
end

