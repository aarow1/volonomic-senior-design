function [] = goTo(pos)
global pos_des pos_store
pos_des = pos;
unit.time = rostime('now');
unit.pos = pos_des;
pos_store = {pos_store; unit};
fprintf('go to: [%2.2f \t%2.2f \t%2.2f]\n',pos_des(1),pos_des(2),pos_des(3));
end
