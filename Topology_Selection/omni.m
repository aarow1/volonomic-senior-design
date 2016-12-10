%% Physical setup of each vehicle
% Weight
weight_6 = 6;
weight_8 = 8;

% Define unit normals for each motor
X_6 = [   1   0   0;
    1   0   0;
    0   1   0;
    0   1   0;
    0   0   1;
    0   0   1   ]';

a = (1/2) + (1/sqrt(12));
b = (1/2) - (1/sqrt(12));
c = (1/sqrt(3));

X_8 = [-a   b   -b  a   a   -b  b   -a;
    b    a   -a  -b  -b  -a  a   b;
    c    -c  -c  c   c   -c  -c  c];

% Define position vector from center to motor
P_6 = [
    0   1   0;
    0   -1  0;
    0   0   1;
    0   0   -1;
    1   0   0;
    -1  0   0   ]';

P_8 = (1 / sqrt(3)) * [
    1 -1 1 -1 1 -1 1 -1;
    1 1 -1 -1 1 1 -1 -1;
    1 1 1 1 -1 -1 -1 -1];

%% Find M Matrix: y = M * f_prop
M_6 = [X_6; cross(X_6, P_6)];

M_8_1 = [X_8; cross(X_8, P_8)];

M_8 = M_8_1' * inv(M_8_1 * M_8_1'); % Note this is a special matrix used for over
                              % actuated systems

%% Find individual prop forces for each unit direction

theta = 0:.1:(2*pi + .1);
phi = -pi/2:.1:pi/2;

rows = length(theta);
cols = length(phi);

tw_surf_6 = zeros(length(theta), length(phi), 3);
tw_surf_8 = zeros(length(theta), length(phi), 3);

f_efficiency_6 = zeros(length(theta), length(phi));
f_efficiency_8 = zeros(length(theta), length(phi));
f_props_6 = zeros(length(theta), length(phi), 6);
f_props_8 = zeros(length(theta), length(phi), 8);

tw_6 = zeros(rows, cols);
tw_8 = zeros(rows, cols);

% TODO add something about battery power usage

eff_surf_6 = zeros(rows, cols, 3);
eff_surf_8 = zeros(rows, cols, 3);

theta_surf = zeros(rows, cols);
phi_surf = zeros(rows, cols);

%% Moments
mw_surf_6 = zeros(length(theta), length(phi), 3);
mw_surf_8 = zeros(length(theta), length(phi), 3);

m_efficiency_6 = zeros(length(theta), length(phi));
m_efficiency_8 = zeros(length(theta), length(phi));
m_props_6 = zeros(length(theta), length(phi), 6);
m_props_8 = zeros(length(theta), length(phi), 8);

% TODO add something about battery power usage

m_eff_surf_6 = zeros(rows, cols, 3);
m_eff_surf_8 = zeros(rows, cols, 3);

mw_6 = zeros(rows, cols);
mw_8 = zeros(rows, cols);

for th = 1:length(theta)
    for ph = 1:length(phi)
        
        theta_surf(th,ph) = theta(th);
        phi_surf(th,ph) = phi(ph);
        
        [unit_dir(1) unit_dir(2) unit_dir(3)] = sph2cart(theta(th), phi(ph), 1);
        
        f_des_unit = [unit_dir'; 
            0; 0; 0];
        
        % Solve for prop forces
        f_props_6(th,ph,:) = M_6 \ f_des_unit;
        f_props_8(th,ph,:) = M_8 * f_des_unit;
        
        f_p_6 = M_6 \ f_des_unit;
        f_p_8 = M_8 * f_des_unit;
        
        f_prop_max_6 = max(max(abs(f_p_6)));
        f_prop_max_8 = max(max(abs(f_p_8)));
        
        f_p_6 = f_p_6 ./ f_prop_max_6;
        f_p_8 = f_p_8 ./ f_prop_max_8;
        
        f_max_6 = M_6 * f_p_6;
        f_max_8 = M_8_1 * f_p_8;
        
        norm(f_max_6);
        norm(f_max_8);
        
        tw_6(th,ph) = norm(f_max_6);
        tw_8(th,ph) = norm(f_max_8);
         
        f_prop_sum_6 = sum(abs(f_props_6(th,ph,:)));
        f_prop_sum_8 = sum(abs(f_props_8(th,ph,:)));
        
        f_efficiency_6(th,ph) = 1 / f_prop_sum_6;
        f_efficiency_8(th,ph) = 1 / f_prop_sum_8;
         
        peak_force_6 = norm(reshape(f_props_6(th,ph,:), [1,6]) / f_prop_max_6);
        peak_force_8 = norm(reshape(f_props_8(th,ph,:), [1,8]) / f_prop_max_8);
        
        tw_6(th,ph) = peak_force_6 / 6;
        tw_8(th,ph) = peak_force_8 / 8;
 
        tw_surf_6(th, ph, :) = unit_dir * tw_6(th,ph);
        tw_surf_8(th, ph, :) = unit_dir * tw_8(th,ph);
        
        eff_surf_6(th, ph, :) = unit_dir * f_efficiency_6(th,ph);
        eff_surf_8(th, ph, :) = unit_dir * f_efficiency_8(th,ph);
        
        %% Moment stuff
        
        m_des_unit = [ 0; 0; 0;
            unit_dir' ];
        
        % Solve for prop forces
        m_props_6(th,ph,:) = M_6 \ m_des_unit;
        m_props_8(th,ph,:) = M_8 * m_des_unit;
        
        m_prop_max_6 = max(abs(m_props_6(th,ph,:)));
        m_prop_max_8 = max(abs(m_props_8(th,ph,:)));
         
        m_prop_sum_6 = sum(abs(m_props_6(th,ph,:)));
        m_prop_sum_8 = sum(abs(m_props_8(th,ph,:)));
        
        m_efficiency_6(th,ph) = 1 / m_prop_sum_6;
        m_efficiency_8(th,ph) = 1 / m_prop_sum_8;
         
        m_peak_force_6 = 1 / m_prop_max_6;
        m_peak_force_8 = 1 / m_prop_max_8;
        
        mw_6(th,ph) = m_peak_force_6 / 6;
        mw_8(th,ph) = m_peak_force_8 / 8;
 
        mw_surf_6(th, ph, :) = unit_dir * mw_6(th,ph);
        mw_surf_8(th, ph, :) = unit_dir * mw_8(th,ph);
        
        m_eff_surf_6(th, ph, :) = unit_dir * m_efficiency_6(th,ph);
        m_eff_surf_8(th, ph, :) = unit_dir * m_efficiency_8(th,ph);

    end
end

%% Data analysis

% Max required prop force, normalized to f_max of 1 prop
f_prop_max_6 = max(abs(f_props_6), [], 3);
f_prop_max_8 = max(abs(f_props_8), [], 3);

% % Max attainable force in direction
% f_attainable_6 = 1 ./ f_prop_max_6;
% f_attainable_8 = 1 ./ f_prop_max_8;
% 
% % Max attainable T/W in direction
% tw_6 = f_attainable_6 / weight_6;
% tw_8 = f_attainable_8 / weight_8;

% Total force required to make unit net
f_prop_sum_6 = sum(abs(f_props_6));
f_prop_sum_8 = sum(abs(f_props_8));

%% Moments

% Max required prop force, normalized to f_max of 1 prop
m_prop_max_6 = max(abs(m_props_6), [], 3);
m_prop_max_8 = max(abs(m_props_8), [], 3);

% Max attainable force in direction
% m_attainable_6 = 1 ./ m_prop_max_6;
% m_attainable_8 = 1 ./ m_prop_max_8;
% 
% % Max attainable T/W in direction
% mw_6 = m_attainable_6;% / weight_6;
% mw_8 = m_attainable_8;% / weight_8;

% Total force required to make unit net
m_prop_sum_6 = sum(abs(m_props_6));
m_prop_sum_8 = sum(abs(m_props_8));


%% Plotting
us_color= [255 153 0]/255;
them_color = [153 153 153]/255;

% Surface of our T/W for 6 rotor
figure(1);
surf(tw_surf_6(:,:,1), tw_surf_6(:,:,2), tw_surf_6(:,:,3), 'faceColor', us_color);
axis ([-.5 .5 -.5 .5 -.5 .5 ]);
axis square;
grid off; 
% set(gca,'xtick',[],'ytick',[], 'ztick',[]);
set(gcf, 'Color', 'none');
saveas(gcf, 'Max Attainable Thrust to Weight Ratio-6 rotor.png');
% title('Max Attainable Thrust to Weight Ratio, 6 rotor');

% Surface of our T/W for 8 rotor
figure(2);
surf(tw_surf_8(:,:,1), tw_surf_8(:,:,2), tw_surf_8(:,:,3), 'faceColor', them_color);
axis ([-.5 .5 -.5 .5 -.5 .5 ]);
axis square;
grid off; 
set(gcf, 'Color', 'none');
% set(gca,'xtick',[],'ytick',[], 'ztick',[]);
saveas(gcf, 'Max Attainable Thrust to Weight Ratio-8 rotor.png');
% title('Max Attainable Thrust to Weight Ratio, 8 rotor');

% Surface of our T/W for both vehicles
figure(3);
surf(tw_surf_6(:,:,1), tw_surf_6(:,:,2), tw_surf_6(:,:,3), 'faceColor', us_color);
hold on;
surf(tw_surf_8(:,:,1), tw_surf_8(:,:,2), tw_surf_8(:,:,3), 'faceColor', them_color);
axis ([-.5 .5 -.5 .5 -.5 .5 ]);
axis square;
grid off; 
set(gcf, 'Color', 'none');
% set(gca,'xtick',[],'ytick',[], 'ztick',[]);
saveas(gcf, 'Max Attainable Thrust to Weight Ratio-6 and 8 rotor.png');
% legend('6 rotor', '8 rotor');
% title('Max Attainable Thrust to Weight Ratio, 8 rotor');

% Histogram of T/W ratios
figure(4)
hold on;
histogram(tw_6, 15, 'faceColor', us_color);
histogram(tw_8, 15, 'faceColor', them_color);
grid off; 
legend('6 rotor', '8 rotor');
title('Max Thrust to Weight Ratio distributions, 6 and 8 rotor');
xlabel('Thrust to Weight Ratio [g]');
ylabel('Occurences out of 2048');
set(gcf, 'Color', 'none');
saveas(gcf, 'Max Thrust to Weight Ratio distributions-6 and 8 rotor.png');

% Histogram of force efficiencies
figure(5)
hold on;
histogram(f_efficiency_6, 'faceColor', us_color);
histogram(f_efficiency_8, 'faceColor', them_color);
legend('6 rotor', '8 rotor');
title('Force efficiency distributions, 6 and 8 rotor');
grid off;
set(gcf, 'Color', 'none');
xlabel('Force Efficiency [1]');
ylabel('Occurences out of 2048');
saveas(gcf, 'Force efficiency distributions-6 and 8 rotor.png');

% Surface of our efficiency for 6 rotor
figure(6);
surf(eff_surf_6(:,:,1), eff_surf_6(:,:,2), eff_surf_6(:,:,3), 'faceColor', us_color);
axis ([-1 1 -1 1 -1 1 ]);
axis square;
grid off;
% set(gca,'xtick',[],'ytick',[], 'ztick',[]);
set(gcf, 'Color', 'none');
saveas(gcf, 'Force Efficiency-6 rotor.png');
% title('Force Efficiency, 6 rotor');

% Surface of our T/W for 8 rotor
figure(7);
surf(eff_surf_8(:,:,1), eff_surf_8(:,:,2), eff_surf_8(:,:,3), 'faceColor', them_color);
axis ([-1 1 -1 1 -1 1 ]);
grid off;
axis square;

% set(gca,'xtick',[],'ytick',[], 'ztick',[]);
set(gcf, 'Color', 'none');
saveas(gcf, 'Force Efficiency-8 rotor.png');
% title('Force Efficiency, 8 rotor');

% Surface of our T/W for both vehicles
figure(8);
surf(eff_surf_6(:,:,1), eff_surf_6(:,:,2), eff_surf_6(:,:,3), 'faceColor', us_color);
hold on;
surf(eff_surf_8(:,:,1), eff_surf_8(:,:,2), eff_surf_8(:,:,3), 'faceColor',them_color);
axis ([-1 1 -1 1 -1 1 ]);
axis square;
grid off;
% set(gca,'xtick',[],'ytick',[], 'ztick',[]);
set(gcf, 'Color', 'none');
saveas(gcf, 'Force Efficiency-6 and 8 rotor.png');
% legend('6 rotor', '8 rotor');
% title('Force Efficiency, 8 rotor');
