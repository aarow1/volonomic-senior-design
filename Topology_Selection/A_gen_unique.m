
% close all;
% tic;
% display('----START-----');
% display(['timestamp: ' datestr(now, 'HH:MM:SS')]);
% function A = A_gen_unique(~, A_step)
A_step = pi/12;
thetaList = theta_gen_unique(A_step);
% for i = 1:length(thetasDone)
%     thetaList = setdiff(thetaList,theta_gen_unique(thetasDone(i)),'rows');
% end

y = 'y';
z = 'z';

index = 1;
stepEnd = 2*pi-A_step;
% theta = theta_gen_unique(pi/12);
% modsplit = 2000;
% A = zeros(6,7,length(theta));
startVal = 1;
endVal = length(thetaList);
A = [];
for i = startVal:endVal;
    t_1 = thetaList(i,1);
    t_2 = thetaList(i,2);
    t_3 = thetaList(i,3);
    t_4 = thetaList(i,4);
    t_5 = thetaList(i,5);
    for t_6 = 0:A_step:stepEnd
        for t_7 = 0:A_step:stepEnd
%              index = (2*pi/step)^2*(i-1)+(2/step)*t_6*(pi/step)+t_7/step+1;
            F = [Rot3D(z,0)*Rot3D(y,t_1)*[0 0 1 1]' ...
                Rot3D(z,2*pi/5)*Rot3D(y,t_2)*[0 0 1 1]'...
                Rot3D(z,4*pi/5)*Rot3D(y,t_3)*[0 0 1 1]' ...
                Rot3D(z,6*pi/5)*Rot3D(y,t_4)*[0 0 1 1]' ...
                Rot3D(z,8*pi/5)*Rot3D(y,t_5)*[0 0 1 1]' ...
                Rot3D(z,t_6)*[0 1 0 1]' ...
                Rot3D(z,t_7)*[0 1 0 1]'];
            F = F(1:3,:);
            
            P = [Rot3D(z,0)*[0 1 0 1]' ...
                Rot3D(z,2*pi/5)*[0 1 0 1]' ...
                Rot3D(z,4*pi/5)*[0 1 0 1]' ...
                Rot3D(z,6*pi/5)*[0 1 0 1]' ...
                Rot3D(z,8*pi/5)*[0 1 0 1]' ...
                [0 0 1 1]' ...
                [0 0 -1 1]'];
            P = P(1:3,:);
            
            M = cross(F,P);
            A(:,:,index) = [F;M];
            index = index+1;
        end
    end
%     T = toc;
%     if (mod(i,modsplit) == 0)
%         display(['timestamp: ' datestr(now, 'HH:MM:SS')]);
%         fprintf('%02d / %02d - %05.0f min / %05.0f min \n', ...
%             i, length(theta),T/60,(1/60)*T/i*length(theta));
%     end
end
