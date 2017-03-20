function [] = goTo(pos)
global pos_des
pos_des = pos;
fprintf('go to: [%2.2f \t%2.2f \t%2.2f]\n',pos_des(1),pos_des(2),pos_des(3));
end
