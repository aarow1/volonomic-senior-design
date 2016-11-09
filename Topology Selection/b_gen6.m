function [w] = b_gen6(step)
%% Generate theta steps
%theta_1:theta_n-1 = [1:pi]
theta_v = 0:step:pi;
[t1, t2, t3, t4] = ndgrid(theta_v,theta_v,theta_v,theta_v);
m = length(t1);
%theta_n-1 = [1:2pi]
t5 = 0:step:2*pi;
w = [];

%% Use spherical coordinates to determine x1-x6
for i = 1:length(t5)
    for j1 = 1:m
        for j2 = 1:m
            for j3 = 1:m
                for j4 = 1:m
                    x1 = cos(t1(j1,j2,j3,j4));
                    x2 = sin(t1(j1,j2,j3,j4))*cos(t2(j1,j2,j3,j4));
                    x3 = sin(t1(j1,j2,j3,j4))*sin(t2(j1,j2,j3,j4))*cos(t3(j1,j2,j3,j4));
                    x4 = sin(t1(j1,j2,j3,j4))*sin(t2(j1,j2,j3,j4))*sin(t3(j1,j2,j3,j4))*cos(t4(j1,j2,j3,j4));
                    x5 = sin(t1(j1,j2,j3,j4))*sin(t2(j1,j2,j3,j4))*sin(t3(j1,j2,j3,j4))*sin(t4(j1,j2,j3,j4))*cos(t5(i));
                    x6 = sin(t1(j1,j2,j3,j4))*sin(t2(j1,j2,j3,j4))*sin(t3(j1,j2,j3,j4))*sin(t4(j1,j2,j3,j4))*sin(t5(i));
                    w = [w [x1;x2;x3;x4;x5;x6]];
                end
            end
        end
    end
end
w = unique(round(w',3),'rows')';