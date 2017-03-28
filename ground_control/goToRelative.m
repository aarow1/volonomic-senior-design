function [] = goToRelative(delta)
global pos_des pos_store
pos_des = pos_des + [delta];

fprintf('go to relative: [%2.2f \t%2.2f \t%2.2f]\n',pos_des(1),pos_des(2),pos_des(3));
end

